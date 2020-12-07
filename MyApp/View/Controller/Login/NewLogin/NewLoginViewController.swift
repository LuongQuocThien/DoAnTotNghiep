//
//  NewLoginViewController.swift
//  MyApp
//
//  Created by TanHuynh on 11/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

protocol NewLoginViewControllerDelegate: class {

    func controller(_ controller: NewLoginViewController, needPerform action: NewLoginViewController.Action)
}

class NewLoginViewController: ViewController {

    enum Action {
        case loginSuccess
    }

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextFied: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var heightErrorMessageConstraint: NSLayoutConstraint!

    weak var delegate: NewLoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        heightErrorMessageConstraint.constant = 0
        loginButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTextFied.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }

    private func login(email: String, password: String) {
        HUD.show()
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/user")
        ref.queryOrdered(byChild: "email").queryEqual(toValue: email)
            .observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                HUD.dismiss()
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let users = Mapper<NewUser>().mapArray(JSONArray: items)

                if !users.isEmpty,
                    let user = users.first,
                    user.password == password {
                    this.heightErrorMessageConstraint.constant = 0
                    // set user session
                    Session.shared.isLogin = true
                    Session.shared.userId = user.id
                    Session.shared.firstName = user.firstName
                    Session.shared.lastName = user.lastName
                    Session.shared.address = "\(user.address), \(user.city)"
                    Session.shared.avatarUrlSring = user.avatarUrlString
                    Session.shared.email = user.email

                    this.delegate?.controller(this, needPerform: .loginSuccess)
                    this.navigationController?.popViewController(animated: false)
//                    AppDelegate.shared.setRootViewController(root: .home)
                } else {
                    this.heightErrorMessageConstraint.constant = 100
                    this.passwordTextFied.text = ""
                }
            }) { [weak self] error in
                guard let this = self else { return }
                HUD.dismiss()
                this.alert(error: error, handler: nil)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text,
            let password = passwordTextFied.text else { return }
        loginButton.isEnabled = !email.isEmpty && !password.isEmpty
    }

    @IBAction func loginButtonTouchUpInside(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextFied.text else { return }
        login(email: email, password: password)
    }

    @IBAction func registerButtonTouchUpInside(_ sender: UIButton) {
        let vc = NewRegisterViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        if let viewControllers = navigationController?.viewControllers,
            viewControllers.count >= 2,
            viewControllers[viewControllers.count - 2].isKind(of: ProfileViewController.self) {
                AppDelegate.shared.setRootViewController(root: .home)
        } else {
            navigationController?.popViewController(animated: false)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
}

extension NewLoginViewController: NewRegisterViewControllerDelegate {

    func controller(_ controller: NewRegisterViewController, needPerform action: NewRegisterViewController.Action) {
        switch action {
        case .login(let email, let password):
            login(email: email, password: password)
        }
    }
}
