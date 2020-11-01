//
//  DiscoveryRestaurant.swift
//  MyApp
//
//  Created by TAN HUYNH on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class DiscoveryRestaurant: Object, Mappable {

    // MARK: - Properties
    dynamic var id = ""
    dynamic var name = ""
    var categories: List<Category> = List<Category>()
    dynamic var prefixUrlString = ""
    dynamic var suffixUrlString = ""
    dynamic var imageUrlString = ""
    dynamic var representativeComment = ""
    dynamic var latitude: Double = 0
    dynamic var longtitude: Double = 0
    dynamic var geoId: Int = 0
    dynamic var address = ""
    dynamic var city = ""
    dynamic var checkinsCount = 0
    dynamic var thumbnailImageUrlString = ""

    // MARK: - Init
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        geoId <- map["location.contextGeoId"]
        latitude <- map["location.lat"]
        longtitude <- map["location.lng"]
        address <- map["location.address"]
        city <- map["location.city"]
        checkinsCount <- map["stats.checkinsCount"]
        representativeComment <- map["stats.representativeComment"]
        thumbnailImageUrlString <- map["thumbnailImage"]

        var ctegories: [Category] = []
        ctegories <- map["categories"]
        for category in ctegories {
            categories.append(category)
        }

        prefixUrlString <- map["photo.prefix"]
        suffixUrlString <- map["photo.suffix"]
        imageUrlString = prefixUrlString + "original" + suffixUrlString
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
