//
//  FilterCollectionCellViewModel.swift
//  MyApp
//
//  Created by TAN HUYNH on 2/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class FilterCollectionCellViewModel: ViewModel {

    // MARK: - Properties
    var name = ""
    var imageUrlString = ""
    var isSelected = false
    var id = ""

    // MARK: - Init
    init() { }

    init(category: Category, isSelected: Bool) {
        name = category.name
        imageUrlString = category.imageUrlString
        id = category.id
        self.isSelected = isSelected
    }
}
