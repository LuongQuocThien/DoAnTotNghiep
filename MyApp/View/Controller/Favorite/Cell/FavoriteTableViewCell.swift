//
//  FavoriteTableViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 3/8/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var restaurantAddressLabel: UILabel!
    @IBOutlet private weak var restaurantNameLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!

    // MARK: - Property
    var viewModel = FavoriteCellViewModel() {
        didSet {
            updateView()
        }
    }

    func updateView() {
        guard let thumbnai = viewModel.thumnail else { return }
        restaurantNameLabel.text = viewModel.name
        ratingLabel.text = viewModel.rating
        countryLabel.text = viewModel.country
        thumbnailImageView.setImageWithURL(thumbnai)
        restaurantAddressLabel.text = viewModel.address
    }

    func configUI() {
        ratingView.clipsToBounds = true
        ratingView.layer.cornerRadius = ratingView.frame.width / 2
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
}
