//
//  MenuViewController.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class MenuViewController: ViewController {

    // MARK: - Outlet
    @IBOutlet private weak var contentView: UIView!

    // MARK: - Properties
    private var pageVC: UIPageViewController?
    private var arrayVC: [UIViewController] = []
    var viewModel = MenuViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        configPageVC()
        updateUI()
    }

    private func initData() {
        let picture = ListAlbumViewController()
        picture.viewModel = ListAlbumViewModel(venueID: viewModel.venueID)
        arrayVC.append(picture)

        let menu = ListFoodsViewController()
        menu.viewModel = ListFoodViewModel(venueID: viewModel.venueID)
        arrayVC.append(menu)
    }

    func updateUI() {
        title = viewModel.restaurantName
    }

    private func configPageVC() {
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        guard let firstVC = arrayVC.first, let pageVC = pageVC else { return }
        contentView.addSubview(pageVC.view)
        addChild(pageVC)
        pageVC.view.frame = contentView.bounds
        pageVC.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }

    private func switchingPageViewController(type: TypeChildPageViewController) {
        let vc = arrayVC[type.rawValue]
        guard let pageVC = pageVC, vc != pageVC.viewControllers?.first else { return }
        pageVC.setViewControllers([vc],
                                  direction: type.direction,
                                  animated: false,
                                  completion: nil)
    }

    // MARK: - IBAction
    @IBAction private func tabButtonTouchUpInside(_ sender: UIButton) {
        guard let type = TypeChildPageViewController(rawValue: sender.tag) else { return }
        switchingPageViewController(type: type)
    }
}

// MARK: - Config
extension MenuViewController {

    enum TypeChildPageViewController: Int {
        case picture
        case infomation

        var direction: UIPageViewController.NavigationDirection {
            switch self {
            case .infomation:
                return .reverse
            case .picture:
                return .forward
            }
        }

        var opsite: TypeChildPageViewController {
            switch self {
            case .infomation:
                return .picture
            case .picture:
                return .infomation
            }
        }
    }
}
