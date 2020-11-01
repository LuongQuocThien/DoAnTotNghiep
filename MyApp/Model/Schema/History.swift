//
//  History.swift
//  MyApp
//
//  Created by PCI0001 on 3/11/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import RealmSwift

@objcMembers class History: Object {

    dynamic var id = ""
    dynamic var content = ""

    convenience init(content: String) {
        self.init()
        self.content = content
        self.id = content
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
