//
//  MenuFoodCellViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class MenuFoodCellViewModel {

    var menu: FoodInfomation?

    init(menu: FoodInfomation) {
        self.menu = menu
    }
}

// MARK: - Firebase
final class NewMenuFoodCellViewModel {

    var food: NewFoodItem?

    init() { }

    init(food: NewFoodItem) {
        self.food = food
    }
}
