//
//  FavoriteViewController.swift
//  MyApp
//
//  Created by PCI0001 on 1/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

final class FavoriteViewController: ViewController {

    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = FavoriteViewModel()
    var isSelected = false

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        viewModel.delegate = self
        reloadData()
        configNavi()
        editButtonNavi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkStateOfTableView()
    }

    func configTableView() {
        tableView.register(FavoriteTableViewCell.self)
        tableView.rowHeight = Configure.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func reloadData() {
        viewModel.fetchHistorySearchRealm()
        viewModel.observe()
    }

    private func checkStateOfTableView() {
        viewModel.fetchHistorySearchRealm()
        if viewModel.numberOfRowInSections() > 0 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }

    @objc func editButtonNavi() {
        isSelected = true
        tableView.isEditing = false
        navigationItem.rightBarButtonItem = nil
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        button.addTarget(self, action: #selector(cancleButtonNavi), for: .touchUpInside)
        let editButton = UIBarButtonItem(customView: button)
        if let customView = editButton.customView {
            let currWidth = customView.widthAnchor.constraint(equalToConstant: 20)
            currWidth.isActive = true
            let currHeight = customView.heightAnchor.constraint(equalToConstant: 20)
            currHeight.isActive = true
        }
        navigationItem.leftBarButtonItem = editButton
    }

    @objc func cancleButtonNavi() {
        isSelected = false
        tableView.isEditing = true
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(editButtonNavi))
        navigationItem.leftBarButtonItem = cancelButton
        let deleteAll = UIBarButtonItem(title: "Xoá", style: .plain, target: self, action: #selector(deleteCell))
        navigationItem.rightBarButtonItem = deleteAll
    }

      @objc func deleteCell() {
        var selectedIndexPaths: [IndexPath] {
            if let selected = tableView.indexPathsForSelectedRows {
                return selected.sorted().reversed()
            } else {
                return []
            }
        }
        viewModel.removeAtIndexPaths(indexPaths: selectedIndexPaths)
        checkStateOfTableView()
    }

    private func configNavi() {
        navigationItem.title = App.Favorite.titleNavi
    }
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowInSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteTableViewCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlert(title: App.Favorite.title, message: App.Favorite.msg, buttons: ["Cancel", "OK"]) { [weak self] (actions) in
                guard let this = self else { return }
                if actions.title == "OK" {
                    this.viewModel.delete(at: indexPath)
                    this.checkStateOfTableView()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelected {
            let vc = DetailViewController()
            vc.viewModel = viewModel.getDetailViewModel(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - FavoriteViewModellDelegate
extension FavoriteViewController: FavoriteViewModellDelegate {

    func viewModel(_ viewModel: FavoriteViewModel, needsPerform action: FavoriteViewModel.Action) {
        tableView.reloadData()
    }
}

extension FavoriteViewController {

    struct Configure {
        static let rowHeight: CGFloat = 80
    }
}
