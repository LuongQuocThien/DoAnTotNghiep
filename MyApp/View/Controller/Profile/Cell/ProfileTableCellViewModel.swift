//
//  ProfileTableCellViewModel.swift
//  MyApp
//
//  Created by TAN HUYNH on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class ProfileTableCellViewModel: ViewModel {

    // MARK: - Properties
    var title = ""

    // MARK: - Init
    init() { }

    init(title: String) {
        self.title = title
    }
}
