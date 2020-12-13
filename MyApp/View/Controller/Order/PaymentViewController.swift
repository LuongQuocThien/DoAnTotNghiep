//
//  PaymentViewController.swift
//  MyApp
//
//  Created by Thien Luong Q on 10/27/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import Firebase
import NotificationCenter
import CoreLocation

final class PaymentViewController: ViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foodPriceLabel: UILabel!
    @IBOutlet weak var shipPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    var foodPrice = 0
    var shipPrice = 0
    var orderItems: [NewOrder] = []
    var venueCoordinate: CLLocationCoordinate2D?
    var distance: Double = 0 {
        didSet {
            shipPrice = Int(distance * 5_000) < 1000 ? 0 : Int(distance * 5_000)
            shipPriceLabel.text = "\(shipPrice)".separate() + "đ"
            let total = shipPrice + foodPrice
            totalPriceLabel.text = "\(total)".separate() + "đ"
        }
    }

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

        // Address
        userNameLabel.text = Session.shared.lastName + " " + Session.shared.firstName
        phoneLabel.text = Session.shared.phone
        getAddressFromLatLon(lat: Session.shared.currentLocationCoordinateLat, lng: Session.shared.currentLocationCoordinateLng)
    }

    @IBAction func changeAddressButtonTouchUpInside(_ sender: Any) {
        let vc = AddressPaymentViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func changeInforPaymentButtonTouchUpInside(_ sender: Any) {
        let vc = UserInforPaymentViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func confirmOrderFoodButtonTouchUpInside(_ sender: Any) {
        // Check distance <= 15km
        guard distance <= 15 else {
            let alert = UIAlertController(title: "Khoảng cách giao hàng", message: "Khoảng cách giao hàng hiện tại lớn hơn 15 Km. Vui lòng chọn địa điểm hoặc địa chỉ giao hàng khác.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Xác nhận", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        // Order
        HUD.show()
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
        HUD.dismiss()

        // go to notification
        showAlert(title: "", message: "Đặt hàng thành công", buttons: ["OK"]) { (_) in
            self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: Notification.Name(rawValue: App.String.kShowBillInfoNotificationName), object: nil)
        }
    }
}

extension PaymentViewController: AddressPaymentViewControllerDelegate {

    func controller(_ controller: AddressPaymentViewController, needsPerformAction action: AddressPaymentViewController.Action) {
        switch action {
        case .getAddress(let address):
            // Address
            var addressStr = ""
            addressStr += address.street.isEmpty ? "" : addressStr.isEmpty ? address.street : ", \(address.street)"
            addressStr += address.district.isEmpty ? "" : addressStr.isEmpty ? address.district : ", \(address.district)"
            addressStr += address.city.isEmpty ? "" : addressStr.isEmpty ? address.city : ", \(address.city)"
            addressStr += address.country.isEmpty ? "" : addressStr.isEmpty ? address.country : ", \(address.country)"
            addressLabel.text = addressStr

            // Distance
            guard let venueCoordinate = venueCoordinate,
                let addressCoordinate = address.coordinate else { return }
            let venueLocation = CLLocation(latitude: venueCoordinate.latitude, longitude: venueCoordinate.longitude)
            let addressLocation = CLLocation(latitude: addressCoordinate.latitude, longitude: addressCoordinate.longitude)
            let dis = addressLocation.distance(from: venueLocation) / 1_000
            distance = Double(round(100*dis)/100)
            distanceLabel.text = "\(distance) Km"
        }
    }
}

extension PaymentViewController: UserInforPaymentViewControllerDelegate {

    func controller(_ controller: UserInforPaymentViewController, needsPerformAction action: UserInforPaymentViewController.Action) {
        switch action {
        case .getInfoPayment(let name, let phone):
            userNameLabel.text = name
            phoneLabel.text = phone
        }
    }
}

extension PaymentViewController {

    func getAddressFromLatLon(lat: Double, lng: Double) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lng
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        HUD.show()
        ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            HUD.dismiss()
                if let error = error {
                    self.alert(error: error)
                    return
                }
                guard let placemarks = placemarks else { return }
                if !placemarks.isEmpty {
                    let item = placemarks[0]
                    let address = NewAddressOrder(street: item.thoroughfare ?? "",
                                                  district: item.subLocality ?? "",
                                                  city: item.locality ?? "",
                                                  country: item.country ?? "",
                                                  coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    var addressStr = ""
                    addressStr += address.street.isEmpty ? "" : addressStr.isEmpty ? address.street : ", \(address.street)"
                    addressStr += address.district.isEmpty ? "" : addressStr.isEmpty ? address.district : ", \(address.district)"
                    addressStr += address.city.isEmpty ? "" : addressStr.isEmpty ? address.city : ", \(address.city)"
                    addressStr += address.country.isEmpty ? "" : addressStr.isEmpty ? address.country : ", \(address.country)"

                    // Update Address UI
                    DispatchQueue.main.async {
                        self.addressLabel.text = addressStr
                        // Distance
                        guard let venueCoordinate = self.venueCoordinate,
                            let addressCoordinate = address.coordinate else { return }
                        let venueLocation = CLLocation(latitude: venueCoordinate.latitude, longitude: venueCoordinate.longitude)
                        let addressLocation = CLLocation(latitude: addressCoordinate.latitude, longitude: addressCoordinate.longitude)
                        let dis = addressLocation.distance(from: venueLocation) / 1_000
                        self.distance = Double(round(100*dis)/100)
                        self.distanceLabel.text = "\(self.distance) Km"
                    }
                }
        })
    }
}
