//
//  LoginViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/18/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class LoginViewController: ViewController {

    @IBOutlet private weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    @IBAction private func loginButtonTouchUpInside(_ sender: Any) {
        // Firebase change
//        let vc = NewLoginViewController()
//        navigationController?.pushViewController(vc, animated: true)

        let loginWebVC = WebViewController()
        navigationController?.pushViewController(loginWebVC, animated: true)
    }

    func configUI() {
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 25
        loginButton.layer.borderWidth = 0.5
    }
}
