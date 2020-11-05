//
//  DetailViewController.swift
//  MyApp
//
//  Created by PCI0001 on 1/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import SwiftUtils
import MVVM

final class DetailViewController: ViewController {

    // MARK: - Outlet
    @IBOutlet private weak var tableViewRestaurant: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    var viewModel = DetailViewModel()
    private let favoriteButton = UIButton(type: .custom)

    // MARK: - LifeCyCle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getDetailVenue()
    }

    func getDetailVenue() {
        viewModel.getDetailVenue { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableViewRestaurant.reloadData()
                this.getDetailPhotos()
                this.updateUI()
                this.favoriteButton.isSelected = this.viewModel.restaurant.isFavorite
            case .failure(let error):
                this.alert(error: error) { _ in
                    this.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func getDetailComment(isLoadMore: Bool) {
        HUD.show()
        viewModel.getComment(isLoadMore: isLoadMore) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableViewRestaurant.reloadData()
            case .failure(let error):
                this.alert(error: error)
            }
            HUD.dismiss()
        }
    }

    func getDetailPhotos() {
        HUD.show()
        viewModel.getPhotos { [weak self] (result) in
            guard let this = self else { return }
            HUD.dismiss()
            switch result {
            case .success:
                this.tableViewRestaurant.reloadData()
                this.getDetailComment(isLoadMore: false)
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }

    private func configUI() {
        configNavigationBar()
        configTableView()
    }

    private func configNavigationBar() {
        favoriteButton.setImage(#imageLiteral(resourceName: "858712-32 (1)"), for: .selected)
        favoriteButton.setImage(#imageLiteral(resourceName: "858712-32"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(addFavoriteButtonTouchUpInside(_:)), for: .touchUpInside)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let barButton = UIBarButtonItem(customView: favoriteButton)
        navigationItem.rightBarButtonItem = barButton
    }

    @objc func addFavoriteButtonTouchUpInside(_ sender: UIButton) {
        if sender.isSelected {
            // Unlike
            sender.isSelected = false
            viewModel.removeOutRealm()
        } else {
            // Like
            sender.isSelected = true
            viewModel.saveToRealm()
        }
    }

    private func updateUI() {
        title = viewModel.restaurant.name
    }

    private func configTableView() {
        tableViewRestaurant.register(InfomationCell.self)
        tableViewRestaurant.register(MenuTableViewCell.self)
        tableViewRestaurant.register(CommentTableViewCell.self)
        tableViewRestaurant.register(AddressTableViewCell.self)
        tableViewRestaurant.dataSource = self
        tableViewRestaurant.delegate = self
        tableViewRestaurant.contentInset = Configure.contentInset
    }

    @IBAction func commentButtonTouchUpInside(_ sender: Any) {
        if !Session.shared.isLogin {
            let vc = NewLoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CommentViewController()
            vc.venueId = viewModel.venueID
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func orderButtonTouchUpInside(_ sender: Any) {
        if !Session.shared.isLogin {
            let vc = NewLoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = OrderFoodViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return "Bình luận"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = viewModel.sections[indexPath.section]
        switch type {
        case .menu:
            let cell = tableView.dequeue(MenuTableViewCell.self)
            cell.delegate = self
            if let vm = viewModel.viewModelForItem(at: indexPath) as? MenuTableCellViewModel {
                cell.viewModel = vm
            }
            return cell
        case .comment:
            let cell = tableView.dequeue(CommentTableViewCell.self)
            if let vm = viewModel.viewModelForItem(at: indexPath) as? CommentCellViewModel {
                cell.viewModel = vm
            }
            return cell
        case .infomation:
            let cell = tableView.dequeue(InfomationCell.self)
            if let vm = viewModel.viewModelForItem(at: indexPath) as? InformationCellViewModel {
                cell.viewModel = vm
            }
            return cell
        case .address:
            let cell = tableView.dequeue(AddressTableViewCell.self)
            if let vm = viewModel.viewModelForItem(at: indexPath) as? AddressCellViewModel {
                cell.viewModel = vm
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height + Configure.heighNavigation
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        if !viewModel.getComment().isEmpty && distanceFromBottom <= height && viewModel.isCanLoadMore {
            getDetailComment(isLoadMore: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = viewModel.sections[indexPath.section]
        switch type {
        case .menu:
            if viewModel.photos.count <= 2 {
                return Configure.heighMinForRowAtMenu
            }
            return Configure.heighForRowAtMenu
        default:
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = viewModel.sections[indexPath.section]
        switch type {
        case .address:
            let vc = MapViewController()
            vc.viewModel = viewModel.viewModelForMapVC()
            navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
}

// MARK: - DetailSectionHeaderViewDelegate
extension DetailViewController: MenuTableViewCellDelegate {

    func headerView(_ headerView: MenuTableViewCell, needPerformAction action: MenuTableViewCell.Action) {
        switch action {
        case .seeAllList:
            let vc = MenuViewController()
            vc.viewModel = viewModel.getMenuViewModel()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Config
extension DetailViewController {

    struct Configure {
        static let minimumLineSpacing: CGFloat = 10
        static let contentInsetCollection = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        static let heighForRowAtMenu: CGFloat = ((kScreenSize.width - minimumLineSpacing) / 2 - contentInsetCollection.left) * 2 + 35
        static let heighForRowAtInfo: CGFloat = 350
        static let heighForRowAtAddress: CGFloat = kScreenSize.width / 2.5
        static let contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -40, right: 0)
        static let heighMinForRowAtMenu: CGFloat = (kScreenSize.width - minimumLineSpacing) / 2 - contentInsetCollection.left
        static let heighNavigation: CGFloat = 64
    }
}
