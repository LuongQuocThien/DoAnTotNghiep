//
//  NewLocation.swift
//  MyApp
//
//  Created by TanHuynh on 11/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import Firebase

final class NewLocation: Mappable {

    var id = ""
    var city = ""
    var latitude: Double = 0
    var longtitude: Double = 0

    init() { }

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        city <- map["city"]
        longtitude <- map["longtitude"]
        latitude <- map["latitude"]
    }
}
