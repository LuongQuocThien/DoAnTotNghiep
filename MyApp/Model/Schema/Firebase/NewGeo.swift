//
//  NewGeo.swift
//  MyApp
//
//  Created by Thien Luong Q on 11/21/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import Firebase

final class NewGeo: Mappable {

    var id: Int = 0
    var lattitude: Double = 0
    var longtitude: Double = 0

    init() { }

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["contextGeoId"]
        var coordinate: [Double] = []
        coordinate <- map["l"]
        if coordinate.count >= 2 {
            lattitude = coordinate[0]
            longtitude = coordinate[1]
        }
    }
}
