//
//  AppDelegate.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import Firebase

let networkIndicator = NetworkActivityIndicatorManager.shared

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    enum Root {
        case home
        case login
    }

    var window: UIWindow?

    static let shared: AppDelegate = {
        guard let shared = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
        }
        return shared
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        FirebaseApp.configure()
        setRootViewController(root: .home)
//        if Session.shared.isLogin {
//            setRootViewController(root: .home)
//        } else {
//            setRootViewController(root: .login)
//        }
        window?.makeKeyAndVisible()
        configNetwork()
        return true
    }

    func setRootViewController(root: Root) {
        let tabbarVC = TabBarViewController()
        window?.rootViewController = tabbarVC
        switch root {
        case .home:
            let tabbarVC = TabBarViewController()
            window?.rootViewController = tabbarVC
        case .login:
            let loginViewController = NewLoginViewController()
            window?.rootViewController = UINavigationController(rootViewController: loginViewController)
        }
    }
}

extension AppDelegate {
    fileprivate func configNetwork() {
        networkIndicator.isEnabled = true
        networkIndicator.startDelay = 0
    }

    fileprivate func configFirebase() {
        FirebaseApp.configure()
    }
}
