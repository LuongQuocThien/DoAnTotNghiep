//
//  RecentlyViewViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class RecentlyViewController: ViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel = RecentlyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func loadData() {
        viewModel.fetchRestaurantsRealm()
        tableView.reloadData()
    }

    private func configTableView() {
        tableView.register(SearchTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Extension UITableViewDataSource
extension RecentlyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchTableViewCell.self)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }
}

// MARK: - Extension UITableViewDelegate
extension RecentlyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.viewModel = viewModel.getDetailViewModel(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: Config.titleActionDelete) { _, indexPath in
            let alert = UIAlertController(title: nil, message: Config.deleteActionMessage, preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes", style: .cancel) { [weak self] _ in
                guard let this = self else { return }
                this.viewModel.deleteRestaurantRealm(at: indexPath)
                this.viewModel.removeRestaurant(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let action2 = UIAlertAction(title: "No", style: .default) { _ in }
            alert.addAction(action1)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }
}

// MARK: - Extension SearchCorrectViewController
extension RecentlyViewController {

    struct Config {
        static let heightForRow: CGFloat = 70
        static let titleActionDelete = "Remove"
        static let deleteActionMessage = "Are you sure remove this venue?"
    }
}
