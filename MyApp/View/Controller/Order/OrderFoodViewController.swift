//
//  OrderFoodViewController.swift
//  MyApp
//
//  Created by TanHuynh on 12/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import Firebase
import ObjectMapper

class OrderFoodViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!

    var orders: [NewOrder] = [] {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Giỏ hàng"
        tableView.register(OrderFoodTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        getFirbaseData()
    }

    func getFirbaseData() {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/order")
        ref.queryOrdered(byChild: "userId").queryEqual(toValue: Session.shared.userId)
            .observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }

                let orders = Mapper<NewOrder>().mapArray(JSONArray: items)
                this.orders = orders
                this.tableView.reloadData()
            }) { (error) in
                self.alert(error: error)
        }
    }

    func updateUI() {
        tableView.reloadData()
        orderButton.isEnabled = !orders.isEmpty
        orderButton.backgroundColor = orders.isEmpty ? .lightGray : .red
    }

    @IBAction func paymentButtonTouchUpInside(_ sender: Any) {
        let vc = PaymentViewController()
        var priceFoods = 0
        for order in orders {
            priceFoods += order.totalPrice
        }
        vc.foodPrice = priceFoods
        vc.shipPrice = 0
        vc.orderItems = orders
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension OrderFoodViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OrderFoodTableViewCell.self)
        let name = orders[indexPath.row].foodName
        let number = orders[indexPath.row].numberOfFoods
        let price = orders[indexPath.row].totalPrice
        cell.item = OrderFoodTableViewCell.OrderFoodItem(name: name, number: number, price: price)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// OrderFoodTableViewCellDelegate
extension OrderFoodViewController: OrderFoodTableViewCellDelegate {

    func cell(_ cell: OrderFoodTableViewCell, needPerform action: OrderFoodTableViewCell.Action) {
        switch action {
        case .removeFromOrders(let index):
            let alert = UIAlertController(title: nil, message: "Bạn có chắc muốn xoá khỏi giỏ hàng?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: {(_: UIAlertAction) in
            }))
            alert.addAction(UIAlertAction(title: "Xoá", style: .default, handler: {(_: UIAlertAction) in
                let id = self.orders[index].id
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("response").child("order").child(id).removeValue()
                self.updateUI()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
