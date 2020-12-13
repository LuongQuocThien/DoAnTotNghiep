//
//  UserInforPaymentViewController.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/29/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

protocol UserInforPaymentViewControllerDelegate: class {
    func controller(_ controller: UserInforPaymentViewController, needsPerformAction action: UserInforPaymentViewController.Action)
}

class UserInforPaymentViewController: ViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!

    weak var delegate: UserInforPaymentViewControllerDelegate?

    // MARK: - Enum
    enum Action {
        case getInfoPayment(name: String, phone: String)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Thông tin người nhận"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @IBAction func updateInforPaymentButtonTouchUpInside(_ sender: Any) {
        guard let name = nameTextField.text,
            let phone = phoneTextField.text else { return }
        if name.isEmpty || phone.isEmpty {
            showAlert(title: "", message: "Vui lòng nhập đầy đủ thông tin nhận hàng!", buttons: ["OK"], handler: nil)
        } else {
            delegate?.controller(self, needsPerformAction: .getInfoPayment(name: name, phone: phone))
            navigationController?.popViewController(animated: true)
        }
    }
}
