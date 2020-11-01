//
//  UIKitEx.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils

typealias Action = (String?, (() -> Void)?)

extension UIViewController {

    func alert(error: Error, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: "Error", message: error.localizedDescription, buttons: ["OK"], handler: handler)
    }

    func showAlert(title: String, message: String, buttons: [String], handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for button in buttons {
            let alertAction = UIAlertAction(title: button, style: .default) { action in
                handler?(action)
            }
            alert.addAction(alertAction)
        }
        present(alert, animated: true, completion: nil)
    }
}
