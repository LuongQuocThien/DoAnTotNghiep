//
//  SearchTableViewCell.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class SearchTableViewCell: UITableViewCell, View {

    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var typeRestaurantLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    // MARK: - Properties
    var viewModel: SearchCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        typeRestaurantLabel.text = viewModel.type
        thumbnailImageView.setImageWithURL(viewModel.imageUrlString)
    }
}
