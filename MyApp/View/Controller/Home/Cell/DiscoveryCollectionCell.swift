//
//  DiscoveryCollectionCell.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class DiscoveryCollectionCell: UICollectionViewCell, View {

    // MARK: - Outlets
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var typeRestaurantLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!

    // MARK: - Properties
    var viewModel = DiscoveryCollectionCellViewModel() {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private
    private func updateCell() {
        titleLabel.text = viewModel.name
        commentLabel.text = viewModel.comment
        typeRestaurantLabel.text = viewModel.type
        thumbnailImageView.setImageWithURL(viewModel.imageUrlString)
    }
}
