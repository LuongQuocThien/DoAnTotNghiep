//
//  MenuTableViewCellModel.swift
//  MyApp
//
//  Created by PCI0010 on 2/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class MenuTableCellViewModel: ViewModel {

    // MARK: - Properties
    private var menuRestaurants: [Photo] = []

    init(menus: [Photo] = []) {
        menuRestaurants = menus
    }

    // MARK: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return min(menuRestaurants.count, Configure.minNumber)
    }

    func viewModelForItem(at indexPath: IndexPath) -> MenuCollectionCellViewModel {
        return MenuCollectionCellViewModel(menu: menuRestaurants[indexPath.row])
    }
}

extension MenuTableCellViewModel {

    struct Configure {
        static let minNumber: Int = 4
    }
}
