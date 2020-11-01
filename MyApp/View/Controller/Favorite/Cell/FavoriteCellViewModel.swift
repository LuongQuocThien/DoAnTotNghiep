//
//  FavoriteCellViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/8/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
final class FavoriteCellViewModel {

    // MARK: - Properties
    var name: String?
    var address: String?
    var country: String?
    var rating: String?
    var thumnail: String?

    // MARK: - Init
    init(restaurantFV: FavoriteRestaurant = FavoriteRestaurant()) {
        name = restaurantFV.name
        address = restaurantFV.address
        country = restaurantFV.countryCity
        rating = restaurantFV.rating
        thumnail = restaurantFV.thumbnail
    }
}
