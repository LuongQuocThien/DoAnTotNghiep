//
//  ProfileViewController.swift
//  MyApp
//
//  Created by PCI0001 on 1/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class ProfileViewController: ViewController {

    // MARK: - Outlets
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var tipCountLabel: UILabel!
    @IBOutlet private weak var photoCountLabel: UILabel!
    @IBOutlet private weak var friendCountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var countryLabel: UILabel!

    // MARK: - Properties
    private var viewModel = ProfileViewModel()
    typealias SectionType = ProfileViewModel.SectionType

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Session.shared.isLogin {
            configUI()
            getProfile()
        } else {
            let vc = NewLoginViewController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Config
    private func configUI() {
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        configTableView()
    }

    private func configTableView() {
        tableView.register(ProfileTableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    func updateUI() {
        thumbnailImageView.setImageWithURL(viewModel.thumbnail)
        userNameLabel.text = viewModel.name
        tipCountLabel.text = String(viewModel.countTips)
        photoCountLabel.text = String(viewModel.countPhotos)
        friendCountLabel.text = String(viewModel.countFriend)
        countryLabel.text = viewModel.homeCity
        navigationItem.title = Config.titleNavi
    }

    func updateUIFirebase() {
        thumbnailImageView.setImageWithURL(Session.shared.avatarUrlSring)
        userNameLabel.text = "\(Session.shared.lastName) \(Session.shared.firstName)"
        countryLabel.text = Session.shared.address
        tipCountLabel.text = String(viewModel.countTips)
        photoCountLabel.text = String(viewModel.countPhotos)
        friendCountLabel.text = String(viewModel.countFriend)
        navigationItem.title = Config.titleNavi
    }

    func getProfile() {
        HUD.show()
        viewModel.getProfile { [weak self] (result) in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
//                this.updateUI()
                this.updateUIFirebase()
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }
}

// MARK: - Extension UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ProfileTableCell.self)
        let vm = viewModel.viewModelForItem(at: indexPath) as? ProfileTableCellViewModel
        cell.viewModel = vm
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}

// MARK: - Extension UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return }
        let rowType = sectionType.rowTypes[indexPath.row]
        switch rowType {
        case .changeProfile:
            let vc = EditProfileViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .changePassword:
            let vc = PasswordViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .logOut:
            Session.shared.isLogin = false
            let vc = NewLoginViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

// MARK: - Extension Config
extension ProfileViewController {

    struct Config {
        static let heightForRow: CGFloat = 50
        static let titleNavi: String = "Cài đặt"
    }
}

extension ProfileViewController: NewLoginViewControllerDelegate {

    func controller(_ controller: NewLoginViewController, needPerform action: NewLoginViewController.Action) {
        switch action {
        case .loginSuccess:
            getProfile()
        }
    }
}
