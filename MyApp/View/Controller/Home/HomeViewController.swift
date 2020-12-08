//
//  HomeViewController.swift
//  MyApp
//
//  Created by PCI0001 on 1/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import MapKit

final class HomeViewController: ViewController {

    enum TypeDiscovery {
        case openNow
        case nearly
    }

    // MARK: - Outlets
    @IBOutlet private weak var locationView: UIView!
    @IBOutlet private weak var heightLocationViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchBarView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var buttonContainViewheightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nearlyButton: UIButton!
    @IBOutlet private weak var openNowButton: UIButton!
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var noResultView: NoResultView!

    // MARK: - Properties
    private var viewModel = HomeViewModel()
    private var refreshControl = UIRefreshControl()
    private var headerView: HomeHeaderView?
    private var isLoadingApi: Bool = false
    private var homeType: TypeDiscovery = .openNow {
        didSet {
            headerView?.toggleNearlyOrOpenNow(isOpenNow: homeType == .openNow)
            toggleNearlyOrOpenNow(isOpenNow: homeType == .openNow)
            callAPI(isLoadMore: false)
        }
    }

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(switchToNotificationScreen(_:)),
                                               name: Notification.Name(rawValue: App.String.kShowBillInfoNotificationName),
                                               object: nil)
        configUI()
        setupData()
        configRefreshControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView?.toggleTimer(isOff: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headerView?.toggleTimer(isOff: true)
    }

    // MARK: - ConfigUI
    private func configUI() {
        configCollectionView()
        configLocationView()
        searchTextField.delegate = self
        buttonContainViewheightConstraint.constant = Config.buttonContainViewheightConstraintWhenHidden
    }

    private func setupData() {
        let lat = Session.shared.currentLocationCoordinateLat
        let lng = Session.shared.currentLocationCoordinateLng
        viewModel.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        locationButton.setTitle(Session.shared.currentLocationName, for: .normal)
        homeType = .openNow
    }

    private func configCollectionView() {
        collectionView.register(DiscoveryCollectionCell.self)
        collectionView.register(header: HomeHeaderView.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Config.sizeForItem
        layout.sectionInset = Config.insetForSection
        layout.headerReferenceSize = Config.headerCollectionSize
        collectionView.collectionViewLayout = layout
    }

    private func configLocationView() {
        searchBarView.layer.cornerRadius = 3
        heightLocationViewConstraint.constant = Config.heightLocationView
    }

    // MARK: - Private
    private func callAPI(isLoadMore: Bool = false) {
//        if !isLoadMore {
//            scrollToTop()
//        }
        // Foursquare
//        loadDataFoursquare(isLoadMore: isLoadMore)

        // Firebase
        loadDataFirebase(isLoadMore: isLoadMore)
//        discoveryVenues(isLoadMore: isLoadMore)
    }

    // Load data FoursquareAPI
    private func loadDataFoursquare(isLoadMore: Bool) {
        isLoadingApi = true
        HUD.show()
        switch homeType {
        case .openNow:
            viewModel.discoveryOpenNow(isLoadMore: isLoadMore) { [weak self] (result) in
                guard let this = self else { return }
                this.isLoadingApi = false
                HUD.dismiss()
                switch result {
                case .success(let restaurants):
                    if !isLoadMore {
                        this.noResultView.alpha = restaurants.isEmpty ? 1 : 0
                    }
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(error: error)
                }
            }
        case .nearly:
            viewModel.discoveryNearly(isLoadMore: isLoadMore) { [weak self] (result) in
                guard let this = self else { return }
                this.isLoadingApi = false
                HUD.dismiss()
                switch result {
                case .success(let restaurants):
                    if !isLoadMore {
                        this.noResultView.alpha = restaurants.isEmpty ? 1 : 0
                    }
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(error: error)
                }
            }
        }
    }

    // Load data from Firebase
    private func loadDataFirebase(isLoadMore: Bool) {
        isLoadingApi = true
        HUD.show()
        switch homeType {
        case .nearly:
            viewModel.loadNearVenueFirebase(isLoadMore: isLoadMore) { [weak self] (result) in
                guard let this = self else { return }
                this.isLoadingApi = false
                HUD.dismiss()
                switch result {
                case .success(let restaurants):
                    this.noResultView.alpha = restaurants.isEmpty ? 1 : 0
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(error: error)
                }
            }
        case .openNow:
            viewModel.loadTrendingVenueFirebase(isLoadMore: isLoadMore) { [weak self] (result) in
                guard let this = self else { return }
                this.isLoadingApi = false
                HUD.dismiss()
                switch result {
                case .success(let restaurants):
                    this.noResultView.alpha = restaurants.isEmpty ? 1 : 0
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(error: error)
                }
            }
        }
    }

    // Find location according to radius
    func discoveryVenues(isLoadMore: Bool) {
        isLoadingApi = true
        HUD.show()
        switch homeType {
        case .nearly:
            viewModel.discoveryVenues(isLoadMore: isLoadMore) { [weak self] (result) in
                guard let this = self else { return }
                this.isLoadingApi = false
                HUD.dismiss()
                switch result {
                case .success(let restaurants):
                    this.noResultView.alpha = restaurants.isEmpty ? 1 : 0
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(error: error)
                }
            }
        case .openNow:
            viewModel.discoveryVenues(isLoadMore: isLoadMore) { [weak self] (result) in
                guard let this = self else { return }
                this.isLoadingApi = false
                HUD.dismiss()
                switch result {
                case .success(let restaurants):
                    this.noResultView.alpha = restaurants.isEmpty ? 1 : 0
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(error: error)
                }
            }
        }
    }

    private func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: false)
    }

    func configRefreshControl() {
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    @objc func refreshData(sender: AnyObject) {
        callAPI(isLoadMore: false)
        refreshControl.endRefreshing()
    }

    private func toggleNearlyOrOpenNow(isOpenNow: Bool) {
        if isOpenNow {
            openNowButton.setTitleColor(.black, for: .normal)
            openNowButton.titleLabel?.font = Config.buttonSelectedFont

            nearlyButton.setTitleColor(.gray, for: .normal)
            nearlyButton.titleLabel?.font = Config.buttonNormalFont
        } else {
            nearlyButton.setTitleColor(.black, for: .normal)
            nearlyButton.titleLabel?.font = Config.buttonSelectedFont

            openNowButton.setTitleColor(.gray, for: .normal)
            openNowButton.titleLabel?.font = Config.buttonNormalFont
        }
    }

    // MARK: - IBAction
    @IBAction private func locationButtonTouchUpInside(_ sender: UIButton) {
        let locationVC = LocationViewController()
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }

    @IBAction private func changeNearlyButtonTouchUpInside(_ sender: Any) {
        guard homeType != .nearly else { return }
        homeType = .nearly
    }

    @IBAction private func changeOpenNowButtonTouchUpInside(_ sender: Any) {
        guard homeType != .openNow else { return }
        homeType = .openNow
    }

    @objc func switchToNotificationScreen(_ sender: Any) {
        guard let tabbar = self.tabBarController as? TabBarViewController else { return }
        tabbar.switchItem(item: .notification)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DiscoveryCollectionCell.self, forIndexPath: indexPath)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            headerView = collectionView.dequeue(header: HomeHeaderView.self, forIndexPath: indexPath)
            guard let header = headerView else { return UICollectionReusableView() }
            header.delegate = self
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.saveRestaurantRealm(at: indexPath)
        let vc = DetailViewController()
        vc.viewModel = viewModel.getDetailViewModel(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > Config.headerCollectionHeight {
            buttonContainViewheightConstraint.constant = Config.buttonContainViewheightConstraintWhenShow
        } else {
            buttonContainViewheightConstraint.constant = Config.buttonContainViewheightConstraintWhenHidden
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height + 120
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        if viewModel.getNumberOfRow() != 0 && distanceFromBottom <= height {
            callAPI(isLoadMore: true)
        }
    }
}

extension HomeViewController: HeaderDiscoveryReusableViewDelegate {

    func headerView(_ headerView: HomeHeaderView, needsPerformAction action: HomeHeaderView.Action) {
        switch action {
        case .changeToNearly:
            guard homeType != .nearly else { return }
            homeType = .nearly
        case .changeToOpenNow:
            guard homeType != .openNow else { return }
            homeType = .openNow
        }
    }
}

extension HomeViewController: LocationViewControllerDelegate {

    func controller(_ controller: LocationViewController, needsPerformAction action: LocationViewController.Action) {
        switch action {
        case .getLocation(let location):
            guard let currentLocation = viewModel.currentLocation,
                currentLocation.city != location.city else { return }
            viewModel.currentLocation = location
            locationButton.setTitle(location.city, for: .normal)
            callAPI(isLoadMore: false)
        }
    }
}

extension HomeViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        dismissKeyboard()
        guard let tabbar = tabBarController as? TabBarViewController else { return }
        tabbar.switchItem(item: .search)
    }
}

// MARK: - Extension HomeViewController
extension HomeViewController {

    struct Config {
        static let sizeForItem = CGSize(width: (UIScreen.main.bounds.width - 20) / 2, height: 150)
        static let insetForSection = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        static let headerCollectionHeight: CGFloat = 220
        static let buttonContainViewheightConstraintWhenHidden: CGFloat = 0
        static let buttonContainViewheightConstraintWhenShow: CGFloat = 35
        static let headerCollectionSize = CGSize(width: UIScreen.main.bounds.width, height: 220)
        static let heightLocationView: CGFloat = UIApplication.shared.statusBarFrame.height + 40
        static let buttonNormalFont = UIFont.systemFont(ofSize: 14)
        static let buttonSelectedFont = UIFont.boldSystemFont(ofSize: 15)
    }
}
