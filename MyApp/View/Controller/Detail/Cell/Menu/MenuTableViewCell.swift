//
//  MenuTableViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 1/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import MVVM

protocol MenuTableViewCellDelegate: class {

    func headerView(_ headerView: MenuTableViewCell, needPerformAction action: MenuTableViewCell.Action)
}

final class MenuTableViewCell: UITableViewCell, View {

    // MARK: - Outlet
    @IBOutlet private weak var menuCollectionView: UICollectionView!

    enum Action {
        case seeAllList
    }

    // MARK: - Properties
    weak var delegate: MenuTableViewCellDelegate?
    var viewModel = MenuTableCellViewModel() {
        didSet {
            updateView()
        }
    }

    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }

    // MARK: - Private
    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Configure.minimumLineSpacing
        layout.minimumInteritemSpacing = Configure.minimumInteritemSpacing
        layout.itemSize = CGSize(width: Configure.widthImageFood, height: Configure.widthImageFood)
        menuCollectionView.contentInset = Configure.contentInset
        menuCollectionView.collectionViewLayout = layout
        menuCollectionView.register(MenuCollectionViewCell.self)
        menuCollectionView.dataSource = self
    }

    @IBAction func listFoodButtonTouchUpInsde(_ sender: UIButton) {
         delegate?.headerView(self, needPerformAction: .seeAllList)
    }

    private func updateView() {
        menuCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MenuTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeue(MenuCollectionViewCell.self, forIndexPath: indexPath)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }
}

extension MenuTableViewCell {

    struct Configure {
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        static let widthImageFood: CGFloat = (kScreenSize.width - minimumLineSpacing) / 2 - contentInset.left
    }
}
