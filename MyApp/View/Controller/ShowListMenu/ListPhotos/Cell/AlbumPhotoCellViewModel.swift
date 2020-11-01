//
//  AlbumPhotoCellViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class AlbumPhotoCellViewModel {

    // MARK: - Properties
    var thumbnail: String = ""

    // MARK: - Init
    init(photo: Photo) {
        thumbnail = photo.path
    }
}
