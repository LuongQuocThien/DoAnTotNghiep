//
//  infoRestaurant.swift
//  MyApp
//
//  Created by PCI0010 on 1/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import CoreLocation
import ObjectMapper

final class Restaurant: Mappable {

    // MARK: - Properties
    var id = ""
    var name = ""
    var lat: Double = 0
    var lng: Double = 0
    var address = ""
    var city = ""
    var isFavorite = false
    var commentsCount = 0
    var imagesCount = 0
    var email = ""
    var phone = ""
    var openTime = ""
    var isOpening = false
    var rating: Double = 0
    var thumbnailImageUrlString = ""

    var coordinate: CLLocationCoordinate2D {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        return location
    }

    init() {}

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        rating <- map["rating"]
        lat <- map["location.lat"]
        lng <- map["location.lng"]
        address <- map["location.address"]
        city <- map["location.city"]
        commentsCount <- map["stats.commentsCount"]
        imagesCount <- map["stats.imagesCount"]
        email <- map["contact.email"]
        phone <- map["contact.phone"]
        openTime <- map["openTime"]
        isOpening <- map["isOpenNow"]
        rating <- map["stats.rating"]
        thumbnailImageUrlString <- map["thumbnailImage"]
    }
}
