//
//  ImageUploadCollectionViewCell.swift
//  MyApp
//
//  Created by Thien Luong Q on 11/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol ImageUploadCollectionViewCellDelegate: class {

    func cell(_ cell: ImageUploadCollectionViewCell, needPerform action: ImageUploadCollectionViewCell.Action)
}

class ImageUploadCollectionViewCell: UICollectionViewCell {

    enum Action {
        case deleteImage(index: Int)
    }

    struct Item {
        var image: UIImage?
        var index: Int?
    }

    @IBOutlet private weak var imageView: UIImageView!

    weak var delegate: ImageUploadCollectionViewCellDelegate?
    var item: Item? {
        didSet {
            guard let item = item else { return }
            imageView.image = item.image
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction private func deleteButtonTouchUpInside(_ sender: Any) {
        guard let index = item?.index else { return }
        delegate?.cell(self, needPerform: .deleteImage(index: index))
    }
}
