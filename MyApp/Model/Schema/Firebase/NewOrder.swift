//
//  NewOrder.swift
//  MyApp
//
//  Created by TanHuynh on 12/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import Firebase

final class NewOrder: Mappable {

    var id = ""
//    var venueId = ""
//    var venueName = ""
    var foodName = ""
    var numberOfFoods = 0
    var totalPrice = 0
    var createAt = ""
    var info = ""

    init() { }

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
//        venueId <- map["venueId"]
//        venueName <- map["venueName"]
        foodName <- map["foodName"]
        numberOfFoods <- map["numberOfFoods"]
        totalPrice <- map["totalPrice"]
        createAt <- map["createAt"]
        info <- map["info"]
    }
}
