//
//  HomeViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 1/29/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import MapKit
import FirebaseDatabase
import Firebase
import ObjectMapper
import GeoFire

final class HomeViewModel: ViewModel {

    // MARK: - Properties
    var restaurants: [DiscoveryRestaurant] = []
    var coordinate: CLLocationCoordinate2D?
    var numberOfItems = 20
    var currentLocation: NewLocation?

    // MARK: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return restaurants.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> DiscoveryCollectionCellViewModel {
        if restaurants.count > indexPath.row {
            return DiscoveryCollectionCellViewModel(restaurant: restaurants[indexPath.row])
        }
        return DiscoveryCollectionCellViewModel()
    }

    func getDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        let id = restaurants[indexPath.row].id
        let vm = DetailViewModel(venueID: id)
        return vm
    }

    func getNumberOfRow() -> Int {
        return restaurants.count
    }

    func saveRestaurantRealm(at indexPath: IndexPath) {
        if restaurants.count > indexPath.row {
            let restaurant = restaurants[indexPath.row]
            RealmManager.shared.add(object: restaurant)
        }
    }
}

// MARK: - API
extension HomeViewModel {

    func discoveryOpenNow(isLoadMore: Bool, completion: @escaping Completion<[DiscoveryRestaurant]>) {
        guard let coordinate = coordinate else { return }
        if !isLoadMore {
            restaurants.removeAll()
        }
        let offset = restaurants.count
        Api.Discovery.query(mode: .openNow(coordinate: coordinate.content, offset: offset)) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let restaurants):
                this.restaurants += restaurants
                completion(.success(this.restaurants))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func discoveryNearly(isLoadMore: Bool, completion: @escaping Completion<[DiscoveryRestaurant]>) {
        guard let coordinate = coordinate else { return }
        if !isLoadMore {
            restaurants.removeAll()
        }
        let offset = restaurants.count
        Api.Discovery.query(mode: .nearly(coordinate: coordinate.content, offset: offset)) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let restaurants):
                this.restaurants += restaurants
                completion(.success(this.restaurants))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Firebase
    func loadNearVenueFirebase(isLoadMore: Bool, completion: @escaping Completion<[DiscoveryRestaurant]>) {
        if !isLoadMore {
            numberOfItems = 20
        } else {
            numberOfItems += Config.limit
        }
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/venue")
        ref.queryOrdered(byChild: "location/city").queryEqual(toValue: currentLocation?.city).queryLimited(toLast: UInt(numberOfItems))
            .observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }

                let restaurants = Mapper<DiscoveryRestaurant>().mapArray(JSONArray: items)
                this.restaurants = restaurants
                completion(.success(this.restaurants))
            }) { (error) in
                completion(.failure(error))
        }
    }

    func loadTrendingVenueFirebase(isLoadMore: Bool, completion: @escaping Completion<[DiscoveryRestaurant]>) {
        if !isLoadMore {
            numberOfItems = 20
        } else {
            numberOfItems += Config.limit
        }
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/venue")
//        ref.queryOrdered(byChild: "stats/checkinsCount").queryStarting(atValue: 50)
        ref.queryLimited(toLast: UInt(numberOfItems))
        .observe(.value, with: { [weak self] (snapshot) in
            guard let this = self else { return }
            let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
            var items: [[String: Any]] = []
            for data in dataSnapShots {
                if let jsonObject = data.value as? [String: Any] {
                    items.append(jsonObject)
                }
            }

            let restaurants = Mapper<DiscoveryRestaurant>().mapArray(JSONArray: items)
            this.restaurants = restaurants
            completion(.success(this.restaurants))
        }) { (error) in
            completion(.failure(error))
        }
    }

    // Query around
    func discoveryVenues(isLoadMore: Bool, completion: @escaping Completion<[DiscoveryRestaurant]>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/geo")
        let geoFire = GeoFire(firebaseRef: ref)
//        geoFire.setLocation(CLLocation(latitude: 16.0614, longitude: 108.22854), forKey: "location")
        let center = CLLocation(latitude: 16.06064813996494, longitude: 108.2169811846068)
        let circleQuery = geoFire.query(at: center, withRadius: 0.65)
        var dataSnapShots: [DataSnapshot] = []
        circleQuery.observe(.keyEntered) { ( _, snapshot: DataSnapshot) in
            dataSnapShots.append(snapshot)
        }

        circleQuery.observeReady({ [weak self] in
            // All initial data has been loaded and events have been fired!
            guard let this = self else { return }
            var items: [[String: Any]] = []
            for data in dataSnapShots {
                if let jsonObject = data.value as? [String: Any] {
                    items.append(jsonObject)
                }
            }
            let geoLocations = Mapper<NewGeo>().mapArray(JSONArray: items)
            var countLoaded = 0
            for geo in geoLocations {
                this.queryRestaurant(with: geo.id, completion: { (result) in
                    countLoaded += 1
                    switch result {
                    case .success(let restaurant):
                        this.restaurants.append(restaurant)
                        if countLoaded == geoLocations.count { // Finish load all location
                            completion(.success(this.restaurants))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            }
        })
    }

    func queryRestaurant(with contextGeoId: Int, completion: @escaping Completion<DiscoveryRestaurant>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/venue")
        ref.queryOrdered(byChild: "location/contextGeoId").queryEqual(toValue: contextGeoId)
            .observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let restaurant = Mapper<DiscoveryRestaurant>().mapArray(JSONArray: items).first ?? DiscoveryRestaurant()
                completion(.success(restaurant))
            }) { (error) in
                completion(.failure(error))
        }
    }
}

extension HomeViewModel {

    struct Config {
        static let limit = 20
        static let offset = 0
    }
}
