//
//  AlbumPhotoCollectionViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class AlbumPhotoCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    // MARK: - LifeCycle
    var viewModel: AlbumPhotoCellViewModel? {
        didSet {
            updateView()
        }
    }

    private func updateView() {
        guard let viewModel = viewModel else { return }
        thumbnailImageView.setImageWithURL(viewModel.thumbnail)
    }
}
