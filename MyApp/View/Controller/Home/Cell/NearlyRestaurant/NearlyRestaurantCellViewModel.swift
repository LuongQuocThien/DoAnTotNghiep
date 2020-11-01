//
//  NearlyRestaurantCellViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 1/29/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class NearlyRestaurantCellViewModel: ViewModel {

    // MARK: - Properties
    var name = ""
    var address = ""
    var type = ""
    var checkinsCount = ""
    var imageUrlString = ""

    // MARK: - Init
    init(restaurant: SearchRestaurant) {
        name = restaurant.name
        address = restaurant.address
        for category in restaurant.categories {
            type += category.name
        }
        checkinsCount = "Checkin: \(restaurant.checkinsCount)"
        imageUrlString = restaurant.imageUrlString
    }
}
