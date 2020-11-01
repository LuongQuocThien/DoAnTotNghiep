//
//  API.Search.swift
//  MyApp
//
//  Created by TAN HUYNH on 2/26/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Firebase
import GeoFire

extension Api.Search {

    enum SearchMode {
        case correct(query: String, coordinate: String, categoryId: String, offset: Int)
        case nearly(query: String, coordinate: String, categoryId: String, radius: Double)
    }

    struct QueryParams {
        var mode: SearchMode
        var limit = 20

        func toJSON() -> Parameters {
            switch mode {
            case .correct(let query, let coordinate, let categories, let offset):
                return [
                    "ll": coordinate,
                    "query": query,
                    "categories": categories,
                    "limit": limit,
                    "offset": offset
                    ]
            case .nearly(let query, let coordinate, let categories, let radius):
                return [
                    "ll": coordinate,
                    "query": query,
                    "radius": radius,
                    "categories": categories
                ]
            }
        }

        init(mode: SearchMode) {
            self.mode = mode
        }
    }

    @discardableResult
    static func query(mode: SearchMode, completion: @escaping Completion<[SearchRestaurant]>) -> Request? {
        let path = Api.Path.Venue.searchUrlString
        let params = QueryParams(mode: mode)
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject,
                        let response = json["response"] as? JSObject,
                        let group = response["group"] as? JSObject,
                        let results = group["results"] as? JSArray else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    let restaurants = Mapper<SearchRestaurant>().mapArray(JSONArray: results)
                    completion(.success(restaurants))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    /// ----------------------------------- FIRE BASE --------------------------------------------- ///

    enum SearchType {
        case hasKey
        case noKey
    }

    static func getGeoLocationsAround(type: SearchType, location: CLLocation, completion: @escaping Completion<[NewGeo]>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/geo")
        let geoFire = GeoFire(firebaseRef: ref)
        let radius = type == .hasKey ? 15 : 0.3
        let circleQuery = geoFire.query(at: location, withRadius: radius)
        var dataSnapShots: [DataSnapshot] = []
        circleQuery.observe(.keyEntered) { ( _ , snapshot: DataSnapshot) in
            dataSnapShots.append(snapshot)
        }

        circleQuery.observeReady({
            // All initial data has been loaded and events have been fired!
            var items: [[String: Any]] = []
            for data in dataSnapShots {
                if let jsonObject = data.value as? [String: Any] {
                    items.append(jsonObject)
                }
            }
            let geoLocations = Mapper<NewGeo>().mapArray(JSONArray: items)
            completion(.success(geoLocations))
        })
    }

    // Struct can't define weak self
    static func queryWithKey(key: String, location: CLLocation, categoryIDs: [String], completion: @escaping Completion<[DiscoveryRestaurant]>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/venue")
        ref.queryOrdered(byChild: "keyName").queryStarting(atValue: key.lowercased()).queryEnding(atValue: key.lowercased() + "\u{f8ff}")
            .observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let restaurants = Mapper<DiscoveryRestaurant>().mapArray(JSONArray: items)

                // Get geo locations
                self.getGeoLocationsAround(type: .hasKey, location: location, completion: { result in
                    switch result {
                    case .success(let geos):
                        let geoIds: [Int] = geos.map { $0.id }
                        let results: [DiscoveryRestaurant] = restaurants.filter { geoIds.contains($0.geoId)}
                        let filtingResults = Api.Search.filting(restaurants: results, with: categoryIDs)
                        completion(.success(filtingResults))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            }) { (error) in
                completion(.failure(error))
        }
    }

    static func queryNoKey(key: String, location: CLLocation, categoryIDs: [String], completion: @escaping Completion<[DiscoveryRestaurant]>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/venue")
            ref.observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let restaurants = Mapper<DiscoveryRestaurant>().mapArray(JSONArray: items)

                // Get location around center with radius
                var resultRestaurants: [DiscoveryRestaurant] = []
                for res in restaurants {
                    let loca = CLLocation(latitude: res.latitude, longitude: res.longtitude)
                    if loca.distance(from: location) <= SearchNearlyViewModel.Config.radiusSearch {
                        resultRestaurants.append(res)
                    }
                }
                let filtingResults = Api.Search.filting(restaurants: resultRestaurants, with: categoryIDs)
                completion(.success(filtingResults))

                // Get geo locations
//                self.getGeoLocationsAround(type: .noKey, location: location, completion: { result in
//                    switch result {
//                    case .success(let geos):
//                        let geoIds: [Int] = geos.map { $0.id }
//                        let results: [DiscoveryRestaurant] = restaurants.filter { geoIds.contains($0.geoId)}
//                        completion(.success(results))
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                })
            }) { (error) in
                completion(.failure(error))
        }
    }

    static func filting(restaurants: [DiscoveryRestaurant], with categoryIDs: [String]) -> [DiscoveryRestaurant] {
        guard !categoryIDs.isEmpty else { return restaurants }
        var results: [DiscoveryRestaurant] = []
        for restaurant in restaurants {
            for category in restaurant.categories where categoryIDs.contains(category.id) {
                results.append(restaurant)
                break
            }
        }
        return results
    }
}
