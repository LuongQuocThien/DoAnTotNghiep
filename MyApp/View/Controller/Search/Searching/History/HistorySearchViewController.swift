//
//  SearchedViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol HistorySearchViewControllerDelegate: class {
    func controller(_ controller: HistorySearchViewController, needsPerform action: HistorySearchViewController.Action)
}

final class HistorySearchViewController: ViewController {

    enum Action {
        case keyOfHistory(keySearched: String)
    }

    @IBOutlet private weak var tableView: UITableView!

    var viewModel = HistorySearchViewModel()
    weak var delegate: HistorySearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    private func configUI() {
        configTableView()
        configViewModel()
    }

    private func loadData() {
        viewModel.fetchHistorySearchRealm()
        viewModel.observe()
    }

    private func configTableView() {
        tableView.register(HistorySearchTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configViewModel() {
        viewModel.delegate = self
    }
}

// MARK: - Extension UITableViewDataSource
extension HistorySearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HistorySearchTableCell.self)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }
}

// MARK: - Extension UITableViewDelegate
extension HistorySearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keySearched = viewModel.getKeyOfHistory(at: indexPath)
        delegate?.controller(self, needsPerform: .keyOfHistory(keySearched: keySearched))
    }
}

// MARK: - Extension SearchedViewModel
extension HistorySearchViewController: HistorySearchViewModelDelegate {

    func viewModel(_ viewModel: HistorySearchViewModel, needsPerform action: HistorySearchViewModel.Action) {
        tableView.reloadData()
    }
}

// MARK: - Extension SearchedViewController
extension HistorySearchViewController {

    struct Config {
        static let heightForRow: CGFloat = 40
    }
}
