//
//  RecentlyViewViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import RealmSwift

protocol RecentlyViewViewModelDelegate: class {
    func viewModel(_ viewModel: RecentlyViewModel, needsPerform action: RecentlyViewModel.Action)
}

final class RecentlyViewModel: ViewModel {

    // MARK: - Enum
    enum Action {
        case reLoadData
    }

    // MARK: - Properties
    // Public to unit test
    var restaurants: [DiscoveryRestaurant] = []
    weak var delegate: RecentlyViewViewModelDelegate?
    private var notificationToken: NotificationToken?

    func numberOfItems(inSection section: Int) -> Int {
        return restaurants.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        if indexPath.row <= restaurants.count {
            return SearchCellViewModel(restaurant: restaurants[indexPath.row])
        }
        return SearchCellViewModel()
    }

    func getDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        let id = restaurants[indexPath.row].id
        let vm = DetailViewModel(venueID: id)
        return vm
    }

    func removeRestaurant(at indexPath: IndexPath) {
        if restaurants.count > indexPath.row {
            restaurants.remove(at: indexPath.row)
        }
    }
}

// MARK: - Extension RecentlyViewViewModel
extension RecentlyViewModel {

    func fetchRestaurantsRealm() {
        guard let datas = RealmManager.shared.fetchObjects(DiscoveryRestaurant.self)?.reversed() else { return }
        restaurants = [DiscoveryRestaurant](datas)
        delegate?.viewModel(self, needsPerform: .reLoadData)
    }

    func observe() {
        notificationToken = RealmManager.shared.observe(type: History.self, completion: { [weak self] _ in
            guard let this = self else { return }
            this.fetchRestaurantsRealm()
        })
    }

    func deleteRestaurantRealm(at indexPath: IndexPath) {
        RealmManager.shared.delete(object: restaurants[indexPath.row])
    }
}
