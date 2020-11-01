//
//  CollectionCellViewModel.swift
//  MyApp
//
//  Created by TAN HUYNH on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class DiscoveryCollectionCellViewModel {

    // MARK: - Properties
    var name = ""
    var type = ""
    var comment = ""
    var imageUrlString = ""

    // MARK: - Init
    init() { }

    init(restaurant: DiscoveryRestaurant = DiscoveryRestaurant()) {
        name = restaurant.name
        if !restaurant.representativeComment.isEmpty {
            comment = restaurant.representativeComment
        }
        for category in restaurant.categories {
            type += "\(category.name)"
        }
        imageUrlString = restaurant.thumbnailImageUrlString
    }
}
