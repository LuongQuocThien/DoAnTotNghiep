//
//  MenuCollectionViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 1/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

final class MenuCollectionViewCell: UICollectionViewCell, View {

    // MARK: - Outlet
    @IBOutlet private weak var menuCollectionImageView: UIImageView!

    // MARK: - Properties
    var viewModel: MenuCollectionCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Public
    func updateView() {
        guard let viewModel = viewModel else { return }
        menuCollectionImageView.setImageWithURL(viewModel.thumbnail)
    }
}
