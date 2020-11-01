//
//  LocationTableViewCell.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class LocationTableViewCell: UITableViewCell, View {

    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel: LocationCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
    }
}
