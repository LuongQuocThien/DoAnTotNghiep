//
//  SearchViewController.swift
//  MyApp
//
//  Created by PCI0001 on 1/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MapKit

final class SearchViewController: ViewController {

    // MARK: - Outlets
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var searchBarView: UIView!
    @IBOutlet private weak var searchBarTextField: UITextField!
    @IBOutlet private weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightSearchBarContainerConstant: NSLayoutConstraint!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var locationLabel: UILabel!

    private let searchingVC = SearchingViewController()
    private let searchResult = SearchResultViewController()

    // MARK: - Properties
    private var viewModel = SearchViewModel()
    private var isSearching = false {
        didSet {
            setUISearchBar()
        }
    }
    var state: State = .searching {
        didSet {
            showView()
        }
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSearching = true
        searchBarTextField.becomeFirstResponder()
    }

    // MARK: - ConfigUI
    private func setupUI() {
        configSearchBar()
        setupContainerView()
    }

    private func setupData() {
        let coordinate = CLLocationCoordinate2D(latitude: Session.shared.currentLocationCoordinateLat, longitude: Session.shared.currentLocationCoordinateLng)
        viewModel.coordinate = coordinate
        locationButton.setTitle(Session.shared.currentLocationName, for: .normal)
    }

    private func setupContainerView() {
        containerView.addSubview(searchResult.view)
        addChild(searchResult)
        searchResult.view.frame = containerView.bounds

        containerView.addSubview(searchingVC.view)
        addChild(searchingVC)
        searchingVC.view.frame = containerView.bounds
        searchingVC.delegate = self
    }

    private func showView() {
        switch state {
        case .searching:
            containerView.bringSubviewToFront(searchingVC.view)
        case .searchResult:
            containerView.bringSubviewToFront(searchResult.view)
        }
    }

    private func configSearchBar() {
        searchBarView.layer.cornerRadius = Config.cornerRadiusSearchBar
        searchBarTextField.delegate = self
        searchBarTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cancelButtonWidthConstraint.constant = 0
        heightSearchBarContainerConstant.constant = Config.heightSearchBarContainerConstant
        searchBarTextField.autocorrectionType = .no
    }

    private func configLocationService() {
        LocationManager.shared.configLocationService()
    }

    // MARK: - Action
    @IBAction func setLocationButtonTouchUpInside(_ sender: UIButton) {
        let locationVC = LocationViewController()
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }

    @IBAction private func cancelButtonTouchUpInside(_ sender: Any) {
        isSearching = false
    }

    private func setUISearchBar() {
        if isSearching {
            locationLabel.isHidden = true
            locationButton.isHidden = true
            cancelButtonWidthConstraint.constant = Config.cancelButtonWidthConstraint
        } else {
            locationLabel.isHidden = false
            locationButton.isHidden = false
            cancelButtonWidthConstraint.constant = 0
            dismissKeyboard()
        }
        view.layoutIfNeeded()
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            state = .searching
            return
        }
    }

    private func searchWithKeyword(_ keyword: String) {
        guard !keyword.isEmpty else { return }
        viewModel.keyword = keyword
        searchResult.searchParam = viewModel.getParamForSearchResult()
        state = .searchResult
    }
}

// MARK: - Extension UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        searchWithKeyword(text)
        isSearching = false

        viewModel.saveHistorySearchRealm(keyword: text)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
    }
}

// MARK: - Extension LocationViewControllerDelegate
extension SearchViewController: LocationViewControllerDelegate {

    func controller(_ controller: LocationViewController, needsPerformAction action: LocationViewController.Action) {
        switch action {
        case .getLocation(let location):
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longtitude)
            viewModel.coordinate = coordinate
            locationButton.setTitle(location.city, for: .normal)
            searchResult.searchParam = viewModel.getParamForSearchResult()
        }
    }
}

extension SearchViewController: SearchingViewControllerDelegate {

    func controller(_ controller: SearchingViewController, needsPerform action: SearchingViewController.Action) {
        switch action {
        case .keyOfHistory(let keySearched):
            searchBarTextField.text = keySearched
            searchWithKeyword(keySearched)
        }
    }
}

// MARK: - Extension HomeViewController
extension SearchViewController {

    enum State {
        case searching
        case searchResult
    }

    struct Config {
        static let boldSystemFont = UIFont.boldSystemFont(ofSize: 13)
        static let systemFont = UIFont.systemFont(ofSize: 13)
        static let cancelButtonWidthConstraint: CGFloat = 70
        static let cornerRadiusSearchBar: CGFloat = 3
        static let heightSearchBarContainerConstant = UIApplication.shared.statusBarFrame.height + 40
    }
}
