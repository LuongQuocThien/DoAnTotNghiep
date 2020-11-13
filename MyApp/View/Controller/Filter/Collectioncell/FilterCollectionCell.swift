//
//  FilterCollectionCell.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 2/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class FilterCollectionCell: UICollectionViewCell, View {

    // MARK: - Outlets
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var isSelectImageView: UIImageView!

    // MARK: - Properties
    var viewModel: FilterCollectionCellViewModel? {
        didSet {
            updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        thumbnailImageView.layer.cornerRadius = 3
    }

    // MARK: - Private
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        thumbnailImageView.setImageWithURL(viewModel.imageUrlString)
        if viewModel.isSelected {
            isSelectImageView.image = #imageLiteral(resourceName: "checked_icon")
        } else {
            isSelectImageView.image = nil
        }
    }
}
