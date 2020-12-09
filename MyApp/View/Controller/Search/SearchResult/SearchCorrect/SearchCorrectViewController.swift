//
//  SearchCorrectViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class SearchCorrectViewController: ViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noResultView: UIView!

    private var viewModel = SearchCorrectViewModel()
    private var isLoadingApi: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        configTableView()
    }

    func searchCorrect(isLoadMore: Bool, searchParams: SearchResultViewController.SearchParam?) {
        isLoadingApi = true
        HUD.show()
        viewModel.searchCorrect(isLoadMore: isLoadMore, searchParams: searchParams) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let restaurants):
                if restaurants.isEmpty {
                    this.view.bringSubview(toFront: this.noResultView)
                } else {
                    this.view.bringSubview(toFront: this.tableView)
                    this.tableView.reloadData()
                }
            case .failure(let error):
                this.alert(error: error)
            }
            this.isLoadingApi = false
            HUD.dismiss()
        }
    }

    func searchWithFilter(categorieIds: [String]) {
        viewModel.updateCategoryId(categoryIds: categorieIds)
        searchCorrect(isLoadMore: false, searchParams: nil)
    }

    private func configTableView() {
        tableView.register(SearchTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissKeyboard()
    }
}

// MARK: - Extension UITableViewDataSource
extension SearchCorrectViewController: UITableViewDataSource {

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
extension SearchCorrectViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.saveRestaurantRealm(at: indexPath)
        let vc = DetailViewController()
        vc.viewModel = viewModel.getDetailViewModel(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let height = scrollView.frame.size.height + 120
//        let contentOffsetY = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
//        if viewModel.getNumberOfRow() != 0 && distanceFromBottom <= height {
//            searchCorrect(isLoadMore: true, searchParams: viewModel.searchParams)
//        }
    }
}

// MARK: - Extension SearchCorrectViewController
extension SearchCorrectViewController {

    struct Config {
        static let heightForRow: CGFloat = 70
    }
}
