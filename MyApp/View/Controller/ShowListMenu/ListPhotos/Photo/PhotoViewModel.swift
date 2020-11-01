//
//  PhotoViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 3/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class PhotoViewModel: ViewModel {

    var photo: Photo

    init(photo: Photo = Photo()) {
        self.photo = photo
    }
}
