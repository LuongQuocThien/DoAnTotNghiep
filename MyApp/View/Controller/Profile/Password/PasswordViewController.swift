//
//  PasswordViewController.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

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
        // TODO: - Submit request to change password
    }
}

extension PasswordViewController {

    struct Config {
        static let cornerRadius: CGFloat = 5
    }
}
