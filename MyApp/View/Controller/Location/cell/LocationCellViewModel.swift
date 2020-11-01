//
//  LocationCellViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class LocationCellViewModel: ViewModel {

    var name = ""

    init() { }

    init(name: String) {
        self.name = name
    }
}
