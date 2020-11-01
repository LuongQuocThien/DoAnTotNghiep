//
//  MapViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 2/18/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MapKit

final class MapViewModel {

    // MARK: - Properties
    var restaurant = Restaurant()
    var coordinate: CLLocationCoordinate2D

    var name: String {
        return restaurant.name
    }

    var address: String {
        return restaurant.address
    }

    var thumbnail: String? {
        return restaurant.thumbnailImageUrlString
    }

    // MARK: - Init
    init(restaurant: Restaurant = Restaurant()) {
        self.restaurant = restaurant
        coordinate = CLLocationCoordinate2D(latitude: restaurant.lat, longitude: restaurant.lng)
    }
}
