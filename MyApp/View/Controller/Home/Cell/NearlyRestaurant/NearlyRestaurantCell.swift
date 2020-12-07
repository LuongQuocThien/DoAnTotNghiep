//
//  NearlyRestaurantCell.swift
//  MyApp
//
//  Created by PCI0001 on 1/29/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class NearlyRestaurantCell: UITableViewCell, View {

    // MARK: - Outlets
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var typeRestaurantLabel: UILabel!
    @IBOutlet private weak var checkinsCountLabel: UILabel!

    // MARK: - Properties
    var viewModel: NearlyRestaurantCellViewModel? {
        didSet {
            updateCell()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        addressLabel.text = ""
        typeRestaurantLabel.text = ""
        checkinsCountLabel.text = ""
        thumbnailImageView.image = nil
    }

    // MARK: - Private
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        typeRestaurantLabel.text = viewModel.type
        checkinsCountLabel.text = viewModel.checkinsCount
        thumbnailImageView.setImageWithURL(viewModel.imageUrlString)
    }
}
