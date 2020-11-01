//
//  ViewController.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import NVActivityIndicatorView

class ViewController: UIViewController, MVVM.View, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavibar()
        configTextFieldSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAndHiddenNavibar()
        checkAndHiddenTabbar()
    }

    private func configNavibar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.1073630045, blue: 0.06170322477, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: App.Font.navigationBar,
                                                                   NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        clearTitleBackButton()
    }

    private func checkAndHiddenNavibar() {
        var isHidden = true
        let enableNavigationBars = [LocationViewController.self,
                                    DetailViewController.self,
                                    MenuViewController.self,
                                    FavoriteViewController.self,
                                    ProfileViewController.self,
                                    EditProfileViewController.self,
                                    PasswordViewController.self,
                                    ListAlbumViewController.self,
                                    PaymentViewController.self,
                                    CommentViewController.self,
                                    OrderFoodViewController.self,
                                    PaymentViewController.self,
                                    NotificationViewController.self]
        for item in enableNavigationBars where self.isKind(of: item) {
            isHidden = false
            break
        }
        navigationController?.navigationBar.isHidden = isHidden
    }

    private func clearTitleBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func configTabbar() {
        checkAndHiddenTabbar()
    }

    private func checkAndHiddenTabbar() {
        var isHidden = true
        let enableTabBars = [HomeViewController.self,
                             SearchViewController.self,
                             FavoriteViewController.self,
                             ProfileViewController.self,
                             SearchNearlyViewController.self,
                             SearchCorrectViewController.self,
                             HistorySearchViewController.self,
                             RecentlyViewController.self,
                             NotificationViewController.self]
        for item in enableTabBars where self.isKind(of: item) {
            isHidden = false
            break
        }
        tabBarController?.tabBar.isHidden = isHidden
    }

    private func configTextFieldSearchBar() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
