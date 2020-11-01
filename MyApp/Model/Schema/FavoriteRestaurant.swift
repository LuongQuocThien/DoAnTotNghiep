//
//  FavoriteRestaurant.swift
//  MyApp
//
//  Created by PCI0010 on 3/8/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objcMembers final class FavoriteRestaurant: Object {

    dynamic var id: String?
    dynamic var name: String?
    dynamic var address: String?
    dynamic var rating: String?
    dynamic var thumbnail: String?
    dynamic var countryCity: String?

    convenience init(id: String? = nil, name: String? = nil, address: String? = nil, rating: String? = nil, thumbnail: String? = nil, countryCity: String? = nil) {
        self.init()
        self.id = id
        self.name = name
        self.address = address
        self.rating = rating
        self.thumbnail = thumbnail
        self.countryCity = countryCity
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
