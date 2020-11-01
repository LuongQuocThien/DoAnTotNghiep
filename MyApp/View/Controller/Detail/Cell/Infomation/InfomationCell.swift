//
//  InfomationCell.swift
//  MyApp
//
//  Created by PCI0010 on 2/25/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class InfomationCell: UITableViewCell, View {

    // MARK: - Outlet
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var numberImageLabel: UILabel!
    @IBOutlet private weak var numberOfCommentLabel: UILabel!
    @IBOutlet private weak var nameRestaurantLabel: UILabel!
    @IBOutlet private weak var restaurantImageView: UIImageView!

    // MARK: - Properties
    var viewModel: InformationCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        updateView()
    }

    func configUI() {
        ratingLabel.clipsToBounds = true
        ratingLabel.layer.cornerRadius = ratingLabel.frame.width / 2
    }

    func updateView() {
        guard let viewModel = viewModel else { return }
        timeLabel.text = viewModel.renderedTime
        ratingLabel.text = viewModel.rating
        nameRestaurantLabel.text = viewModel.name
        numberOfCommentLabel.text = String(viewModel.numberOfComment)
        numberImageLabel.text = String(viewModel.numberOfImage)
        restaurantImageView.setImageWithURL(viewModel.thumbnail)
        if viewModel.isOpening {
            statusLabel.text = App.Detail.open
        } else {
            statusLabel.text = App.Detail.close
        }
    }
}
