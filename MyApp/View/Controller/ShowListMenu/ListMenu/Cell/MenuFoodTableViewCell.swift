//
//  MenuFoodTableViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 3/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class MenuFoodTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameCategoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    // MARK: - Property
    var viewModel: NewMenuFoodCellViewModel? {
        didSet {
            updateView()
        }
    }

    func updateView() {
        guard let viewModel = viewModel else { return }
        nameCategoryLabel.text = viewModel.food?.name
        let price = viewModel.food?.discountPrice != 0 ? "\(viewModel.food?.discountPrice ?? 0)" : "\(viewModel.food?.price ?? 0)"
        priceLabel.text = price.separate()
    }
}
