//
//  ShowListMenuViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class MenuViewModel {

    // MARK: - Properties
    var restaurantName = ""
    var venueID = ""

    init(venueID: String = "", restaurantName: String = "") {
        self.restaurantName = restaurantName
        self.venueID = venueID
    }
}
