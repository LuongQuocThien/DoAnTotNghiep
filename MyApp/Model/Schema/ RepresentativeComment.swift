//
//   RepresentativeComment.swift
//  MyApp
//
//  Created by PCI0001 on 3/1/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper

final class RepresentativeComment: Mappable {

    // MARK: - Properties
    var comment = ""

    // MARK: - Init
    init() {}

    init?(map: Map) { }

    func mapping(map: Map) {
        comment <- map["detail.object.text"]
    }
}
