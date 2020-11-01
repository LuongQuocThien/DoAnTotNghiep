//
//  ListFoodsViewController.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class ListFoodsViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Property
    var viewModel = ListFoodViewModel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        // Firebase
        getMenuFirebase()
    }

    func getMenu() {
        viewModel.getMenu { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
                this.checkStateOfTableView()
            case .failure(let error):
                this.alert(error: error) { _ in
                    this.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    // Firebase
    func getMenuFirebase() {
        viewModel.getMenuFirebase { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
                this.checkStateOfTableView()
            case .failure(let error):
                this.alert(error: error) { _ in
                    this.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func configTableView() {
        tableView.register(MenuFoodTableViewCell.self)
        tableView.rowHeight = Configure.heightRow
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func checkStateOfTableView() {
        if viewModel.numberOfItems() > 0 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource
extension ListFoodsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.newMenu?.foods.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newMenu?.foods[section].items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MenuFoodTableViewCell.self)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.newMenu?.foods[section].title ?? ""
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AddFoodItemPopupViewController()
        vc.foodItem = viewModel.newMenu?.foods[indexPath.section].items[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Config
extension ListFoodsViewController {

    struct Configure {
        static let heightRow: CGFloat = 70
    }
}
