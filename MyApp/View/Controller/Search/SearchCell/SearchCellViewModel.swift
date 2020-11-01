//
//  SearchViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class SearchCellViewModel: ViewModel {

    // MARK: - Properties
    var name = ""
    var address = ""
    var type = ""
    var checkin = ""
    var imageUrlString = ""

    // MARK: - Init
    init() { }

    init(restaurant: DiscoveryRestaurant) {
        name = restaurant.name
        address = restaurant.address + ", " + restaurant.city
        for category in restaurant.categories {
            type += category.name
        }
        checkin = "\(restaurant.checkinsCount)"
        imageUrlString = restaurant.thumbnailImageUrlString
    }
}
