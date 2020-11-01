//
//  Photo.swift
//  MyApp
//
//  Created by PCI0010 on 3/4/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

final class Photo: Mappable {

    var id = ""
    private var prefix: String = ""
    private var suffix: String = ""

    init?(map: Map) {}

    init() {}

    func mapping(map: Map) {
        id <- map["id"]
        prefix <- map["prefix"]
        suffix <- map["suffix"]
    }

    var path: String {
        return prefix + "original" + suffix
    }
}
