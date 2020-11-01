//
//  TabBarViewController.swift
//  MyApp
//
//  Created by PCI0001 on 1/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabbar()
    }

    private func configTabbar() {
        // Home
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let homeTabbarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "home"), tag: 0)
        homeTabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeNavigationController.tabBarItem = homeTabbarItem
        // Search
        let searchViewController = SearchViewController()
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let searchTabbarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "iconfinder_Search_858732"), tag: 1)
        searchTabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        searchNavigationController.tabBarItem = searchTabbarItem
        // Favorite
        let favoriteViewController = FavoriteViewController()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        let favoriteTabbarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "iconfinder_heart_115727"), tag: 2)
        favoriteTabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        favoriteNavigationController.tabBarItem = favoriteTabbarItem
        // Profile
        let profileViewController = ProfileViewController()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        let profileTabbarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "iconfinder_user-2_430127"), tag: 4)
        profileTabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        profileNavigationController.tabBarItem = profileTabbarItem
        // Notification
        let notificationViewController = NotificationViewController()
        let notificationNavigationController = UINavigationController(rootViewController: notificationViewController)
        let notificationTabbarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "alarm"), tag: 3)
        notificationTabbarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        notificationNavigationController.tabBarItem = notificationTabbarItem
        // Tabbar config
        tabBar.tintColor = App.Color.barTinColor
        viewControllers = [homeNavigationController, searchNavigationController, favoriteNavigationController, notificationNavigationController, profileNavigationController]
    }

    func switchItem(item: TabItem) {
        selectedIndex = item.rawValue
    }
}

extension TabBarViewController {
    enum TabItem: Int {
        case home
        case search
        case favorite
        case notification
        case profile
    }
}
