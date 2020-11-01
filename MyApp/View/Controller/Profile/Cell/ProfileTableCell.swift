//
//  ProfileTableCell.swift
//  MyApp
//
//  Created by TAN HUYNH on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class ProfileTableCell: UITableViewCell, View {

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    var viewModel: ProfileTableCellViewModel? {
        didSet {
            updateCell()
        }
    }

    private func updateCell() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.title
    }
}
