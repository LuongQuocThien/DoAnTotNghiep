//
//  NotificationBillTableViewCell.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class NotificationBillTableViewCell: TableCell {

    struct OrdersInfo {
        var code = ""
        var status = 1
        var userName = ""
        var phone = ""
        var address = ""
        var totalPrice = 0
        var dateCreate = ""
    }

    @IBOutlet weak var ordersCodeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateCreateLabel: UILabel!

    var ordersInfo: OrdersInfo? {
        didSet {
            guard let info = ordersInfo else { return }
            ordersCodeLabel.text = info.code
            userNameLabel.text = info.userName
            phoneLabel.text = info.phone
            addressLabel.text = info.address
            totalPriceLabel.text = "\(info.totalPrice)".separate() + "đ"
            dateCreateLabel.text = info.dateCreate
            switch info.status {
            case 0:
                statusLabel.text = "Đã huỷ"
            case 1:
                statusLabel.text = "Đang chờ xác nhận"
            case 2:
                statusLabel.text = "Đang giao hàng"
            case 3:
                statusLabel.text = "Đã giao"
            default:
                break
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
