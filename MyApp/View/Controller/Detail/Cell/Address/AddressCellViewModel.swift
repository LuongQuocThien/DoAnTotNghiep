//
//  AddressCellViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 2/25/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import CoreLocation

final class AddressCellViewModel: ViewModel {

    // MARK: - Properties
    let address: String
    let country: String
    let coordinate: CLLocationCoordinate2D

    // MARK: - Init
    init(restaurant: Restaurant = Restaurant()) {
        address = restaurant.address
        country = restaurant.city
        coordinate = CLLocationCoordinate2D(latitude: restaurant.lat, longitude: restaurant.lng)
    }
}
