//
//  NewRegisterViewController.swift
//  MyApp
//
//  Created by Thien Luong Q on 11/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

protocol NewRegisterViewControllerDelegate: class {
    func controller(_ controller: NewRegisterViewController, needPerform action: NewRegisterViewController.Action)
}

class NewRegisterViewController: ViewController {

    enum Action {
        case login(email: String, password: String)
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorConstraint: NSLayoutConstraint!
    @IBOutlet weak var isExistedEmailErrorConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordErrorConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailFormatErrorConstraint: NSLayoutConstraint!

    weak var delegate: NewRegisterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        confirmPasswordErrorConstraint.constant = 0
        passwordErrorConstraint.constant = 0
        emailFormatErrorConstraint.constant = 0
        isExistedEmailErrorConstraint.constant = 0
    }

    private func isValidInfo() -> Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {
                return false
        }

        // validate
        emailFormatErrorConstraint.constant = isValidEmail(email: email) ? 0 : 100
        passwordErrorConstraint.constant = isValidPassword(password: password) ? 0 : 100
        confirmPasswordErrorConstraint.constant = confirmPassword == password ? 0 : 100
        if isValidEmail(email: email) && isValidPassword(password: password) && password == confirmPassword {
            return true
        } else {
            return false
        }
    }

    func isValidPassword(password: String) -> Bool {
        return true
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func checkToRegister() {
        HUD.show()
        guard let email = emailTextField.text else { return }
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/user")
        ref.queryOrdered(byChild: "email").queryEqual(toValue: email)
            .observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                HUD.dismiss()
                if snapshot.childrenCount == 0 {
                    this.isExistedEmailErrorConstraint.constant = 0
                    this.register() // check exist email
                } else {
                    this.isExistedEmailErrorConstraint.constant = 100
                }

            }) { [weak self] (error) in
                guard let this = self else { return }
                HUD.dismiss()
                this.alert(error: error, handler: nil)
        }
    }

    func register() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        let id = NSUUID().uuidString
        let data = ["id": id,
                    "email": email,
                    "password": password,
                    "firstName": "",
                    "lastName": "",
                    "gender": 1,
                    "address": "",
                    "city": "",
                    "dateOfBirth": "",
                    "phone": "",
                    "avatar": "",
                    "status": 1] as [String : Any]

        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("response").child("user").child(id).setValue(data)

        delegate?.controller(self, needPerform: .login(email: email, password: password))
        navigationController?.popViewController(animated: false)
    }

    @IBAction func registerButtonTouchUpInside(_ sender: Any) {
        if isValidInfo() {
            checkToRegister()
        }
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
}
