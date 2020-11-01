//
//  LocationViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol LocationViewControllerDelegate: class {
    func controller(_ controller: LocationViewController, needsPerformAction action: LocationViewController.Action)
}

final class LocationViewController: ViewController {

    // MARK: - Enum
    enum Action {
        case getLocation(location: NewLocation)
    }

    // MARK: - Outets
    @IBOutlet private weak var locationTableView: UITableView!
    @IBOutlet private weak var locationSearchBar: UISearchBar!

    // MARK: - Properties
    private var viewModel = LocationViewModel()
    weak var delegate: LocationViewControllerDelegate?
    private var searchResults: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getAllLocationFirebase()
    }

    // MARK: - ConfigUI
    private func configUI() {
        title = App.Location.title
        configTableView()
        configSearchBar()
    }

    private func configTableView() {
        locationTableView.register(LocationTableViewCell.self)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.tableFooterView = UIView()
    }

    private func configSearchBar() {
        locationSearchBar.delegate = self
    }

    private func getAllLocationFirebase() {
        viewModel.getAllLocationsFireBase { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.locationTableView.reloadData()
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }

    private func searchLocation(keySearch: String) {
        let locations = viewModel.locations
        viewModel.resultSearchLocations = keySearch.isEmpty ? locations : locations.filter({(location: NewLocation) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return location.city.range(of: keySearch, options: .caseInsensitive) != nil
        })
        locationTableView.reloadData()
    }
}

// MARK: - Extension UITableViewDataSource
extension LocationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LocationTableViewCell.self)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension LocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = viewModel.getLocation(at: indexPath)
        delegate?.controller(self, needsPerformAction: .getLocation(location: location))
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension UISearchBarDelegate
extension LocationViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchLocation(keySearch: searchText)
    }
}
