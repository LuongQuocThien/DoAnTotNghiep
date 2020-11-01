//
//  OrderFoodTableViewCell.swift
//  MyApp
//
//  Created by TanHuynh on 12/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol OrderFoodTableViewCellDelegate: class {

    func cell(_ cell: OrderFoodTableViewCell, needPerform action: OrderFoodTableViewCell.Action)
}
class OrderFoodTableViewCell: TableCell {

    struct OrderFoodItem {
        var name = ""
        var number = 0
        var price = 0
    }

    enum Action {
        case removeFromOrders(index: Int)
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    weak var delegate: OrderFoodTableViewCellDelegate?
    var index = 0

    var item: OrderFoodItem? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
            numberLabel.text = "\(item.number)"
            priceLabel.text = "\(item.price)".separate() + "đ"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func removeFromOrdersButtonTouchUpInside(_ sender: Any) {
        delegate?.cell(self, needPerform: .removeFromOrders(index: index))
    }
}
