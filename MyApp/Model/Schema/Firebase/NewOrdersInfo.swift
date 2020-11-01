//
//  NewOrdersInfo.swift
//  MyApp
//
//  Created by TanHuynh on 12/14/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import Firebase

final class NewOrdersInfo: Mappable {

    var id = ""
    var userName = ""
    var phone = ""
    var address = ""
    var totalPrice = 0
    var createAt = ""
    var status = 1
    var orders: [NewOrder] = []
    
    init() { }
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        userName <- map["userName"]
        phone <- map["phone"]
        address <- map["address"]
        totalPrice <- map["totalPrice"]
        totalPrice <- map["totalPrice"]
        createAt <- map["createAt"]
        status <- map["status"]
        orders <- map["orders"]
    }
}
