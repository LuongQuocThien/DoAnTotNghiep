//
//  Menu.swift
//  MyApp
//
//  Created by PCI0010 on 3/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

final class Menu: Mappable {

    var category: [FoodCategory] = []

    init?(map: Map) {}

    func mapping(map: Map) {
        category <- map["response.menu.menus.items.0.entries.items"]
    }
}

class FoodCategory: Mappable {

    var product: [FoodInfomation] = []

    required init?(map: Map) {}

    func mapping(map: Map) {
        product <- map["entries.items"]
    }
}

class FoodInfomation: Mappable {

    var name = ""
    var price = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        name <- map["name"]
        price <- map["price"]
    }

    var convertPrice: String {
        return price + "$"
    }
}

// MARK: - Firebase
final class NewMenu: Mappable {

    var id = ""
    var foods: [NewFood] = []

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        foods <- map["foods"]
    }
}

final class NewFood: Mappable {

    var title = ""
    var items: [NewFoodItem] = []

    init?(map: Map) {}

    func mapping(map: Map) {
        title <- map["title"]
        items <- map["items"]
    }
}

final class NewFoodItem: Mappable {

    var id = ""
    var name = ""
    var price = 0
    var discountPrice = 0

    init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        discountPrice <- map["discountPrice"]
    }
}

@objcMembers final class NewCart: Object {

    dynamic var id = ""
    dynamic var name = ""
    dynamic var price = 0
    dynamic var number = 0
    dynamic var info = ""

    convenience init(id: String, name: String, price: Int, number: Int, info: String) {
        self.init()
        self.id = id
        self.name = name
        self.price = price
        self.number = number
        self.info = info
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
