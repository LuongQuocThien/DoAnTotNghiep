//
//  AddFoodItemPopupViewController.swift
//  MyApp
//
//  Created by TanHuynh on 12/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Firebase

class AddFoodItemPopupViewController: UIViewController {

    @IBOutlet private weak var numberItemsLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var noticeTextView: UITextView!
    @IBOutlet private weak var titleLabel: UILabel!

    var numberItems = 1 {
        didSet {
            updateUI()
        }
    }
    var foodItem: NewFoodItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        updateUI()
    }

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateUI() {
        guard let item = foodItem else { return }
        numberItemsLabel.text = "\(numberItems)"
        totalPriceLabel.text = "\(numberItems * item.price)"
        titleLabel.text = item.name
    }

    @IBAction func decreaseNumberItemTouchUpInside(_ sender: Any) {
        numberItems = numberItems > 1 ? numberItems - 1 : numberItems
    }

    @IBAction func increaseNumberItemTouchUpInside(_ sender: Any) {
        numberItems = numberItems < 50 ? numberItems + 1 : numberItems
    }

    @IBAction func addToCartButtonTouchUpInside(_ sender: Any) {
        // Save to realm
        guard let item = foodItem,
            let info = noticeTextView.text else { return }
        saveToRealm(foodItem: item, number: numberItems, info: info)

        // post to firebase
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateString = formatter.string(from: currentDateTime)

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let id = NSUUID().uuidString
        let data = ["id": id,
                    "userId": Session.shared.userId,
                    "foodId": item.id,
                    "foodName": item.name,
                    "numberOfFoods": numberItems,
                    "totalPrice": numberItems * item.price,
                    "info": info,
                    "createdAt": currentDateString] as [String : Any]
        ref.child("response").child("order").child(id).setValue(data)

        let alert = UIAlertController(title: "Thông báo", message: "Thêm vào giỏ hàng thành công!", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    @IBAction func dissMissPopUpTapGesture(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Realm
extension AddFoodItemPopupViewController {

    func saveToRealm(foodItem: NewFoodItem, number: Int, info: String) {
        let cartItem = NewCart(id: foodItem.id, name: foodItem.name, price: foodItem.price, number: number, info: info)
        RealmManager.shared.add(object: cartItem)
    }
}
