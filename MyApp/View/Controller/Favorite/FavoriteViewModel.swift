//
//  FavoriteViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/8/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift

protocol FavoriteViewModellDelegate: class {
    func viewModel(_ viewModel: FavoriteViewModel, needsPerform action: FavoriteViewModel.Action)
}

final class FavoriteViewModel {

    // MARK: - Properties
    var restaurantsFV: [FavoriteRestaurant] = []
    private var notificationToken: NotificationToken?
    weak var delegate: FavoriteViewModellDelegate?

    // MARK: - Public
    func numberOfRowInSections() -> Int {
        return restaurantsFV.count
    }

    func getDetailViewModel(at indexPath: IndexPath) -> DetailViewModel {
        guard let id = restaurantsFV[indexPath.row].id else { return DetailViewModel() }
        let vm = DetailViewModel(venueID: id)
        return vm
    }

    func viewModelForItem(at indexpath: IndexPath) -> FavoriteCellViewModel {
        return FavoriteCellViewModel(restaurantFV: restaurantsFV[indexpath.row])
    }

    func removeAtIndexPaths(indexPaths: [IndexPath]) {
        var filterRestaurants: [Object] = []
        for indexPath in indexPaths {
            guard let id = restaurantsFV[indexPath.row].id, let filterRestaurant = RealmManager.shared.fetchObject(FavoriteRestaurant.self, filter: NSPredicate(format: "id = %@", id)) else { return }
            filterRestaurants.append(filterRestaurant)
        }
        RealmManager.shared.deleteAll(objects: filterRestaurants)
    }
}

// MARK: - Realm
extension FavoriteViewModel {

    func delete(at indexPath: IndexPath) {
        guard let id = restaurantsFV[indexPath.row].id else { return }
        guard let filterRestaurant = RealmManager.shared.fetchObject(FavoriteRestaurant.self, filter: NSPredicate(format: "id = %@", id)) else { return }
        RealmManager.shared.delete(object: filterRestaurant)
    }

    func observe() {
        notificationToken = RealmManager.shared.observe(type: FavoriteRestaurant.self) { [weak self] _ in
            guard let this = self else { return }
            this.fetchHistorySearchRealm()
        }
    }

    func fetchHistorySearchRealm() {
        guard let datas = RealmManager.shared.fetchObjects(FavoriteRestaurant.self)?.reversed() else { return }
        restaurantsFV = [FavoriteRestaurant](datas)
        delegate?.viewModel(self, needsPerform: .reloadData)
    }
}

// MARK: - Enum
extension FavoriteViewModel {

    enum Action {
        case reloadData
    }
}
