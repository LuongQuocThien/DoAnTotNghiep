//
//  AddressPaymentViewController.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/26/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import MapKit
import CoreLocation

protocol AddressPaymentViewControllerDelegate: class {
    func controller(_ controller: AddressPaymentViewController, needsPerformAction action: AddressPaymentViewController.Action)
}

class AddressPaymentViewController: ViewController {

    // MARK: - Enum
    enum Action {
        case getAddress(address: NewAddressOrder)
    }

    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    weak var delegate: AddressPaymentViewControllerDelegate?
    var matchingItems: [MKMapItem] = []
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    // MARK: Touch Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - ConfigUI
    private func configUI() {
        title = App.Location.title
        configTableView()
        configSearchBar()
    }

    private func configTableView() {
        tableView.register(AddressPaymentTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    private func configSearchBar() {
        locationSearchBar.delegate = self
    }

    func updateSearchResultsForSearchController(keySearch: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = keySearch
        let search = MKLocalSearch(request: request)
        isSearching = true
        search.start { response, _ in
            self.isSearching = false
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension UITableViewDataSource
extension AddressPaymentViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AddressPaymentTableViewCell.self)
        let item = matchingItems[indexPath.row].placemark
        let address = NewAddressOrder(street: item.thoroughfare ?? "",
                                      district: item.subLocality ?? "",
                                      city: item.locality ?? "",
                                      country: item.country ?? "",
                                      coordinate: item.coordinate)
        cell.address = address
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension AddressPaymentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = matchingItems[indexPath.row].placemark
        let address = NewAddressOrder(street: item.thoroughfare ?? "",
                                      district: item.subLocality ?? "",
                                      city: item.locality ?? "",
                                      country: item.country ?? "",
                                      coordinate: item.coordinate)
        delegate?.controller(self, needsPerformAction: .getAddress(address: address))
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension UISearchBarDelegate
extension AddressPaymentViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !isSearching {
            updateSearchResultsForSearchController(keySearch: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension AddressPaymentViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
