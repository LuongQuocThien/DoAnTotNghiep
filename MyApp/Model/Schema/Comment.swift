//
//  Comment.swift
//  MyApp
//
//  Created by PCI0010 on 2/15/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

final class Comment: Mappable {

    var id = ""
    var title = ""
    var content = ""
    var firstName = ""
    var lastName = ""
    var createdAt = ""
    var avatar: String = ""
    var images: [String] = []
    var rating = 0

    init() { }

    init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        firstName <- map["user.firstName"]
        lastName <- map["user.lastName"]
        createdAt <- map["createdAt"]
        avatar <- map["user.avatar"]
        images <- map["images"]
        rating <- map["rating"]
    }
}
