//
//  TrendingRestaurant.swift
//  MyApp
//
//  Created by PCI0001 on 2/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

final class TredingRestaurant: Mappable {

    // MARK: - Properties
    var id = ""
    var name = ""
    var address = ""
    var type = ""
    var imageUrlString = ""

    // MARK: - Init
    init() {}

    init(id: String, name: String, address: String, type: String, imageUrlString: String) {
        self.id = id
        self.name = name
        self.address = address
        self.type = type
        self.imageUrlString = imageUrlString
    }

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
    }
}
