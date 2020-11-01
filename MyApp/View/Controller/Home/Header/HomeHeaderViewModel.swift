//
//  HeaderReuseableViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class HomeHeaderViewModel: ViewModel {

    private(set) var images: [UIImage] = [#imageLiteral(resourceName: "home1"), #imageLiteral(resourceName: "japanese"), #imageLiteral(resourceName: "home3")]

    var pageCount: Int {
        return images.count
    }
}
