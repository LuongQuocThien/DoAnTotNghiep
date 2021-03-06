//
//  NewUser.swift
//  MyApp
//
//  Created by Thien Luong Q on 11/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import Firebase

final class NewUser: Mappable {

    var id = ""
    var email = ""
    var password = ""
    var firstName = ""
    var lastName = ""
    var dateOfBirth = ""
    var gender = 0
    var address = ""
    var city = ""
    var avatarUrlString = ""
    var phone = ""
    var info = ""

    init() { }

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        email <- map["email"]
        password <- map["password"]
        dateOfBirth <- map["dateOfBirth"]
        gender <- map["gender"]
        address <- map["address"]
        city <- map["city"]
        avatarUrlString <- map["avatar"]
        phone <- map["phone"]
        info <- map["info"]
    }
}

