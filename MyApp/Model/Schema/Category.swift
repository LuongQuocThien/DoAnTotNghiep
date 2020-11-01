//
//  Category.swift
//  MyApp
//
//  Created by PCI0001 on 2/27/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

@objcMembers final class Category: Object, Mappable {

    // MARK: - Properties
    dynamic var id = ""
    dynamic var name = ""
    dynamic var prefixUrlString = ""
    dynamic var suffixUrlString = ""
    dynamic var imageUrlString = ""

    // MARK: - Init
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        prefixUrlString <- map["icon.prefix"]
        suffixUrlString <- map["icon.suffix"]
        imageUrlString <- map["iconImage"]
    }
}
