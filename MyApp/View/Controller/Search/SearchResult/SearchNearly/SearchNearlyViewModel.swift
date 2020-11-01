//
//  SearchNearlyViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import MapKit

final class SearchNearlyViewModel: ViewModel {

    // MARK: - Properties
    // Public to unit test
    var restaurants: [DiscoveryRestaurant] = []
    var categoryIDs: [String] = []
    var searchingLocation: CLLocationCoordinate2D?
    var radiusSearch = Config.radiusSearch
    var query = ""

    func numberOfItems(inSection section: Int) -> Int {
        return restaurants.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        if restaurants.count > indexPath.row {
            return SearchCellViewModel(restaurant: restaurants[indexPath.row])
        }
        return SearchCellViewModel()
    }

    func getDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        let id = restaurants[indexPath.row].id
        let vm = DetailViewModel(venueID: id)
        return vm
    }

    func getDetailViewModelWhenTapCallOut(id: String) -> DetailViewModel {
        return DetailViewModel(venueID: id)
    }

    func getAnnotations() -> [SearchPointAnnotation] {
        var annotations: [SearchPointAnnotation] = []
        for restaurant in restaurants {
            let id = restaurant.id
            let cordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longtitude)
            let name = restaurant.name
            let address = restaurant.address
            let imageUrlString = restaurant.thumbnailImageUrlString
            let annotation = SearchPointAnnotation(id: id, coordinate: cordinate, title: name, subtitle: address, imageUrlString: imageUrlString, imagePin: Config.imagePin)
            annotations.append(annotation)
        }
        return annotations
    }

    func updateCategoryId(categoryIds: [String]) {
        categoryIDs = categoryIds
    }
}

// MARK: - API
extension SearchNearlyViewModel {

    func searchNearly(query: String, completion: @escaping APICompletion) {
        self.query = query
        guard let coordinate = searchingLocation else { return }
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        Api.Search.queryNoKey(key: query, location: location, categoryIDs: categoryIDs) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let restaurants):
                this.restaurants = restaurants
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Realm
extension SearchNearlyViewModel {

    func saveRestaurantRealm(at indexPath: IndexPath) {
        if restaurants.count > indexPath.row {
            let restaurant = restaurants[indexPath.row]
            RealmManager.shared.add(object: restaurant)
        }
    }

    func saveRestaurantWithIdRealm(id: String) {
        for restaurant in restaurants where restaurant.id == id {
            RealmManager.shared.add(object: restaurant)
        }
    }
}

extension SearchNearlyViewModel {

    struct Config {
        static let foodCategoryId = ""
        static let imagePin = #imageLiteral(resourceName: "location1")
        static let radiusSearch: Double = 300
    }
}
