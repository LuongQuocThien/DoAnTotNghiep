//
//  informationCellViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 2/25/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class InformationCellViewModel: ViewModel {

    // MARK: - Properties
    let name: String
    let renderedTime: String
    let rating: String
    var isOpening: Bool = false
    var thumbnail: String = ""
    var numberOfImage: Int
    var numberOfComment: Int

    // MARK: - Init
    init(restaurant: Restaurant) {
        name = restaurant.name
        renderedTime = restaurant.openTime
        rating = String(restaurant.rating)
        isOpening = restaurant.isOpening
        thumbnail = restaurant.thumbnailImageUrlString
        numberOfImage = restaurant.imagesCount
        numberOfComment = restaurant.commentsCount
    }
}
