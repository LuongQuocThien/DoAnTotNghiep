//
//  NewAddressOrder.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/27/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import CoreLocation

final class NewAddressOrder {

    var street = ""
    var district = ""
    var city = ""
    var country = ""
    var coordinate: CLLocationCoordinate2D?

    init() { }

    init(street: String, district: String, city: String, country: String, coordinate: CLLocationCoordinate2D) {
        self.street = street
        self.district = district
        self.city = city
        self.country = country
        self.coordinate = coordinate
    }
}
