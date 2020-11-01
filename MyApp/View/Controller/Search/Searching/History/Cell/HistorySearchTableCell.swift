//
//  HistorySearchTableCell.swift
//  MyApp
//
//  Created by PCI0001 on 3/11/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class HistorySearchTableCell: UITableViewCell {

    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var removeButton: UIButton!

    // MARK: - Properties
    var viewModel: HistorySearchCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Private
    private func updateCell() {
        guard let viewModel = viewModel else { return }
        contentLabel.text = viewModel.getHistorySearch().content
    }

    @IBAction private func removeHistorySearchButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        viewModel.deleteHistorySearchRealm()
    }
}
