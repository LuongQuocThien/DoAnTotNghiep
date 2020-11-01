//
//  CommentTableViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 2/15/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Cosmos

final class CommentTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var postTimeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private var images: [UIImageView]!
    @IBOutlet private var plusImageView: UIImageView!
    @IBOutlet private weak var ratingView: CosmosView!
    @IBOutlet private weak var maxHeightImagesConstraint: NSLayoutConstraint!

    // MARK: - Properties
    var viewModel: CommentCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Public
    func updateView() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
        postTimeLabel.text = viewModel.dateTimeText
        userNameLabel.text = viewModel.username
        avatarImageView.setImageWithURL(viewModel.avatar)
        ratingView.rating = Double(viewModel.rating) / 2

        if viewModel.images.isEmpty {
            maxHeightImagesConstraint.constant = 0
        } else {
            maxHeightImagesConstraint.constant = 1000
        }
        layoutIfNeeded()

        for image in images {
            image.isHidden = true
        }
        plusImageView.isHidden = true

        for i in 0..<viewModel.images.count {
            if i < 3 {
                images[i].isHidden = false
                images[i].setImageWithURL(viewModel.images[i])
            } else {
                plusImageView.isHidden = false
            }
        }
    }

    func configUI() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2

        ratingView.settings.disablePanGestures = true
        ratingView.settings.passTouchesToSuperview = false
    }

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
}
