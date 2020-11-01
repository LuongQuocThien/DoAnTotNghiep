//
//  Filter.swift
//  MyApp
//
//  Created by PCI0001 on 2/20/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

final class CategoryFood {

    var name = ""
    var image = UIImage()
    var isSelected = false

    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}
