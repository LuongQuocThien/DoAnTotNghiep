//
//  Profile.swift
//  MyApp
//
//  Created by PCI0010 on 3/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

final class UserProfile: Mappable {

    var id = ""
    var firstName = ""
    var lastName = ""
    var prefix = ""
    var suffix = ""
    var countTips = 0
    var countPhotos = 0
    var countFriend = 0
    var homeCity = ""
    var gender = ""
    var phone = 0
    var email = ""
    var infomation = ""

    init?(map: Map) {}

    init() {}

    func mapping(map: Map) {
        id <- map["response.user.id"]
        firstName <- map["response.user.firstName"]
        lastName <- map["response.user.lastName"]
        prefix <- map["response.user.photo.prefix"]
        suffix <- map["response.user.photo.suffix"]
        countTips <- map["response.user.tips.count"]
        countPhotos <- map["response.user.photos.count"]
        countFriend <- map["response.user.friends.count"]
        homeCity <- map["response.user.homeCity"]
        gender <- map["response.user.gender"]
        phone <- map["response.user.contact.verifiedPhone"]
        email <- map["response.user.contact.email"]
        infomation <- map["response.user.bio"]
    }

    var path: String {
        return prefix + "original" + suffix
    }

    var name: String {
        return firstName + " " + lastName
    }
}
