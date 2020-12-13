//
//  NotificationViewController.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/9/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import Firebase
import ObjectMapper

class NotificationViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!

    var ordersInfos: [NewOrdersInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tình trạng đơn hàng"
        tableView.register(NotificationBillTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFirebaseData()
    }

    func getFirebaseData() {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/bill")
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

                let infos = Mapper<NewOrdersInfo>().mapArray(JSONArray: items)
                this.ordersInfos = infos
                this.tableView.reloadData()
                this.tableView.isHidden = this.ordersInfos.isEmpty
            }) { (error) in
                self.alert(error: error)
        }
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordersInfos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NotificationBillTableViewCell.self)
        cell.ordersInfo = NotificationBillTableViewCell.OrdersInfo(code: ordersInfos[indexPath.row].id,
                                                                   status: ordersInfos[indexPath.row].status,
                                                                   userName: ordersInfos[indexPath.row].userName,
                                                                   phone: ordersInfos[indexPath.row].phone,
                                                                   address: ordersInfos[indexPath.row].address,
                                                                   totalPrice: ordersInfos[indexPath.row].totalPrice,
                                                                   dateCreate: ordersInfos[indexPath.row].createAt)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
