//
//  GeoLocation.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 2/27/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

final class GeoLocation: Mappable {

    // MARK: - Properties
    var name = ""
    var lat: Double = 0
    var lng: Double = 0

    // MARK: - Init
    init() { }

    init?(map: Map) { }

    func mapping(map: Map) {
        name <- map["displayText"]
        lat <- map["ll.lat"]
        lng <- map["ll.lng"]
    }
}
