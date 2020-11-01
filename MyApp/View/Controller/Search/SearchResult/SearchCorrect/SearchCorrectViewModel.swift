//
//  SearchCorrectViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class SearchCorrectViewModel: ViewModel {

    // MARK: - Properties
    // Public to unit test
    var restaurants: [DiscoveryRestaurant] = []
    var categoryIDs: [String] = []
    private(set) var searchParams = SearchResultViewController.SearchParam()

    func numberOfItems(inSection section: Int) -> Int {
        return restaurants.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        if restaurants.count > indexPath.row {
            return SearchCellViewModel(restaurant: restaurants[indexPath.row])
        }
        return SearchCellViewModel()
    }

    func getNumberOfRow() -> Int {
        return restaurants.count
    }

    func getDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        let id = restaurants[indexPath.row].id
        let vm = DetailViewModel(venueID: id)
        return vm
    }

    func updateCategoryId(categoryIds: [String]) {
        categoryIDs = categoryIds
    }
}

// MARK: - API
extension SearchCorrectViewModel {

    func searchCorrect(isLoadMore: Bool, searchParams: SearchResultViewController.SearchParam?, completion: @escaping Completion<[DiscoveryRestaurant]>) {
        if let searchParams = searchParams {
            self.searchParams = searchParams
        }
        if !isLoadMore {
            restaurants.removeAll()
        }
        let offset = restaurants.count
        Api.Search.queryWithKey(key: self.searchParams.text, location: self.searchParams.location, categoryIDs: categoryIDs) { [weak self] result in
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
}

// MARK: - Realm
extension SearchCorrectViewModel {

    func saveRestaurantRealm(at indexPath: IndexPath) {
        if restaurants.count > indexPath.row {
            let restaurant = restaurants[indexPath.row]
            RealmManager.shared.add(object: restaurant)
        }
    }
}

extension SearchCorrectViewModel {
    struct Config {
        static let foodCategoryId = ""
        static let limit = 20
        static let offset = 0
    }
}
