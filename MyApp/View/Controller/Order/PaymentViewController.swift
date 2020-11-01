//
//  PaymentViewController.swift
//  MyApp
//
//  Created by TanHuynh on 10/27/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import Firebase
import NotificationCenter

final class PaymentViewController: ViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var shipPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!

    var foodPrice = 0
    var shipPrice = 0
    var orderItems: [NewOrder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        title = "Thanh toán"
        navigationItem.title = App.Payment.title
        foodPriceLabel.text = "\(foodPrice)".separate() + "đ"
        shipPriceLabel.text = "\(shipPrice)".separate() + "đ"
        let total = shipPrice + foodPrice
        totalPriceLabel.text = "\(total)".separate() + "đ"
    }

    @IBAction func changeAddressButtonTouchUpInside(_ sender: Any) {
    }

    @IBAction func confirmOrderFoodButtonTouchUpInside(_ sender: Any) {
        var orders: [[String: Any]] = []
        for item in orderItems {
            var order: [String: Any] = [:]
            order["foodId"] = item.id
            order["foodName"] = item.foodName
            order["numberOfFoods"] = item.numberOfFoods
            order["totalPrice"] = item.totalPrice
            orders.append(order)
        }

        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateString = formatter.string(from: currentDateTime)

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let id = NSUUID().uuidString
        guard let userName = userNameLabel.text,
            let address = addressLabel.text,
            let phone = phoneLabel.text else { return }
        let data = ["id": id,
                    "createAt": currentDateString,
                    "paymentAt": "",
                    "status": 1, // 1: Đợi xác nhận, 2: Đang giao, 3: Đã giao, 0: Đã huỷ
                    "userId": Session.shared.userId,
                    "userName": userName,
                    "address": address,
                    "phone": phone,
                    "totalPrice": shipPrice + foodPrice,
                    "orders": orders] as [String: Any]
        ref.child("response").child("bill").child(id).setValue(data)

        // Xoá giỏ hàng sau khi đặt hàng thành công
        for item in orderItems {
            let id = item.id
            ref.child("response").child("order").child(id).removeValue()
        }

        // go to notification
        showAlert(title: "", message: "Đặt hàng thành công", buttons: ["OK"]) { (_) in
            self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: Notification.Name(rawValue: App.String.kShowBillInfoNotificationName), object: nil)
        }
    }
}
