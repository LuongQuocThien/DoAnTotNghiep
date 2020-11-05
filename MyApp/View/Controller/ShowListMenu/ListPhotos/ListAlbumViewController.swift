//
//  ListAlbumViewController.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

final class ListAlbumViewController: ViewController {

    // MARK: - Outlet
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel = ListAlbumViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailPhotos()
        configCollectionView()
    }

    func getDetailPhotos() {
        HUD.show()
        viewModel.getPhotos { [weak self] (result) in
            guard let this = self else { return }
            HUD.dismiss()
            switch result {
            case .success:
                this.collectionView.reloadData()
            case .failure(let error):
                this.alert(error: error) { _ in
                    this.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Configure.minimumLineSpacing
        layout.minimumInteritemSpacing = Configure.minimumInteritemSpacing
        layout.itemSize = CGSize(width: Configure.widthImageFood, height: Configure.widthImageFood)
        collectionView.contentInset = Configure.contentInset
        collectionView.collectionViewLayout = layout
        collectionView.register(AlbumPhotoCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension ListAlbumViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(AlbumPhotoCollectionViewCell.self, forIndexPath: indexPath)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListAlbumViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoViewController()
        vc.viewModel = viewModel.getPhotoForDetail(at: indexPath)
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Config
extension ListAlbumViewController {

    struct Configure {
        static let minimumLineSpacing: CGFloat = 2
        static let minimumInteritemSpacing: CGFloat = 2
        static let contentInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        static let widthImageFood: CGFloat = (kScreenSize.width - minimumLineSpacing * 2) / 3 - contentInset.left
    }
}
