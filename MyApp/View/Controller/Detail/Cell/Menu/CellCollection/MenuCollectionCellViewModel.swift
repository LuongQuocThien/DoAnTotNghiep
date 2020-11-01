//
//  MenuCollectionViewCellModel.swift
//  MyApp
//
//  Created by PCI0010 on 2/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class MenuCollectionCellViewModel {

    // MARK: - Properties
    var thumbnail = ""

    // MARK: - Init
    init(menu: Photo = Photo()) {
        thumbnail = menu.path
    }
}
