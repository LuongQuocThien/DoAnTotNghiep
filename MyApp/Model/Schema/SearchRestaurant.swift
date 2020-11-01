//
//  SearchRestaurant.swift
//  MyApp
//
//  Created by PCI0001 on 1/29/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class SearchRestaurant: Object, Mappable {

    // MARK: - Properties
    dynamic var id = ""
    dynamic var name = ""
    dynamic var street = ""
    dynamic var district = ""
    dynamic var city = ""
    dynamic var address = ""
    var categories: List<Category> = List<Category>()
    dynamic var prefixUrlString = ""
    dynamic var suffixUrlString = ""
    dynamic var imageUrlString = ""
    dynamic var checkinsCount = 0
    dynamic var lat: Double = 0
    dynamic var lng: Double = 0

    // MARK: - Init
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["venue.id"]
        name <- map["venue.name"]

        var ctegories: [Category] = []
        ctegories <- map["venue.categories"]
        for category in ctegories {
            categories.append(category)
        }

        street <- map["venue.location.address"]
        city <- map["venue.location.city"]
        address += street.isEmpty ? "" : "\(street)"
        address += city.isEmpty ? "" : ", \(city)"
        lat <- map["venue.location.lat"]
        lng <- map["venue.location.lng"]

        prefixUrlString <- map["photo.prefix"]
        suffixUrlString <- map["photo.suffix"]
        imageUrlString = prefixUrlString + "original" + suffixUrlString
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
