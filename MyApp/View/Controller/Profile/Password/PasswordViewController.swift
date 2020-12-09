//
//  PasswordViewController.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Firebase

final class PasswordViewController: ViewController {

    @IBOutlet private weak var emailAddressLabel: UILabel!
    @IBOutlet private weak var newpasswordTextField: UITextField!
    @IBOutlet private weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet private weak var currentPasswordTextField: UITextField!
    @IBOutlet private weak var submitView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        title = App.Profile.password
        configSubmitView()
    }

    private func configSubmitView() {
        submitView.layer.cornerRadius = Config.cornerRadius
    }

    @IBAction private func submitButtonTouchUpInside(_ sender: UIButton) {
        view.endEditing(true)
        guard let currentPass = currentPasswordTextField.text,
            let newPass = newpasswordTextField.text,
            let confirmPass = confirmNewPasswordTextField.text else { return }
        if currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty {
            showAlert(title: "", message: "Vui lòng nhập đầy đủ thông tin!", buttons: ["Nhập lại"], handler: nil)
        } else if currentPass != Session.shared.password {
            showAlert(title: "", message: "Mật khẩu hiện tại không chính xác!", buttons: ["Nhập lại"], handler: nil)
        } else if newPass != confirmPass {
            showAlert(title: "", message: "Xác nhận mật khẩu ko trùng khớp", buttons: ["Nhập lại"], handler: nil)
        } else {
            HUD.show()
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("response").child("user").child(Session.shared.userId).updateChildValues(["password": newPass])
            Session.shared.password = newPass
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                HUD.dismiss()
                self.showAlert(title: "", message: "Đổi mật khẩu thành công!", buttons: ["Xác nhận"], handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}

extension PasswordViewController {

    struct Config {
        static let cornerRadius: CGFloat = 5
    }
}
