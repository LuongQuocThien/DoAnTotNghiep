//
//  SearchResultViewController.swift
//  MyApp
//
//  Created by PCI0001 on 3/8/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import CoreLocation

final class SearchResultViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var searchCorrectButton: UIButton!
    @IBOutlet private weak var searchNearlyButton: UIButton!
    @IBOutlet private weak var filterResultButton: UIButton!
    @IBOutlet private weak var containerCounterView: UIView!
    @IBOutlet private weak var counterLabel: UILabel!

    private var viewModel = SearchResultViewModel()
    private let filterVC = FilterViewController()
    private var pageVC: UIPageViewController?
    private var viewControllers = [UIViewController]()
    let searchCorrectVC = SearchCorrectViewController()
    let searchNearlyVC = SearchNearlyViewController()
    private var searchType: SearchType = .correct {
        didSet {
            searchAPI()
        }
    }
    var searchParam: SearchParam? {
        didSet {
            searchAPI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configPageVC()
        setDisplayTab()
    }

    private func setupUI() {
        containerCounterView.layer.cornerRadius = containerCounterView.bounds.width / 2
        containerCounterView.isHidden = true
    }

    private func configPageVC() {
        viewControllers.append(searchCorrectVC)
        viewControllers.append(searchNearlyVC)

        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let pageVC = pageVC {
            containerView.addSubview(pageVC.view)
            addChildViewController(pageVC)
            pageVC.view.frame = containerView.bounds
            pageVC.setViewControllers([searchCorrectVC], direction: .forward, animated: true, completion: nil)
        }
    }

    private func searchAPI() {
        guard let searchParam = searchParam else { return }
        switch searchType {
        case .correct:
            searchCorrectVC.searchCorrect(isLoadMore: false, searchParams: searchParam)
        case .nearly:
            searchNearlyVC.searchNearly(query: searchParam.text)
        }
    }

    private func switchingPage() {
        guard let pageVC = pageVC, let vcs = pageVC.viewControllers else { return }
        let viewVC = viewControllers[searchType.rawValue]
        let direction: UIPageViewController.NavigationDirection
        if !vcs.contains(viewVC) {
            switch searchType {
            case .correct:
                direction = .reverse
            case .nearly:
                direction = .forward
            }
            setDisplayTab()
            pageVC.setViewControllers([viewVC], direction: direction, animated: true, completion: nil)
        }
    }

    private func setDisplayTab() {
        switch searchType {
        case .correct:
            let attributeSelected = NSAttributedString(string: searchCorrectButton.titleLabel?.text ?? "", attributes: Config.attributesForSelected)
            searchCorrectButton.setAttributedTitle(attributeSelected, for: .normal)
            let attributeNormal = NSAttributedString(string: searchNearlyButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
            searchNearlyButton.setAttributedTitle(attributeNormal, for: .normal)
        case .nearly:
            let attributeSelected = NSAttributedString(string: searchNearlyButton.titleLabel?.text ?? "", attributes: Config.attributesForSelected)
            searchNearlyButton.setAttributedTitle(attributeSelected, for: .normal)
            let attributeNormal = NSAttributedString(string: searchCorrectButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
            searchCorrectButton.setAttributedTitle(attributeNormal, for: .normal)
        }
    }

    @IBAction private func searchTypeButtonTouchUpInside(_ sender: UIButton) {
        guard let type = SearchType(rawValue: sender.tag) else { return }
        switch type {
        case .correct:
            guard searchType != .correct else { return }
            searchType = .correct
            switchingPage()
        case .nearly:
            guard searchType != .nearly else { return }
            searchType = .nearly
            switchingPage()
        }
    }

    @IBAction private func filterResultButtonTouchUpInside(_ sender: UIButton) {
        filterVC.delegate = self
        let categories = viewModel.categories
        filterVC.viewModel.selectedCategories = categories
        present(filterVC, animated: true, completion: nil)
    }
}

// MARK: - Extension FilterViewControllerDelegate
extension SearchResultViewController: FilterViewControllerDelegate {

    func controller(_ controller: FilterViewController, needsPerformAction action: FilterViewController.Action) {
        switch action {
        case .apply(let categories):

            viewModel.categories = categories
            let categoryIDs = categories.map { return $0.id }
            counterLabel.text = "\(categoryIDs.count)"
            containerCounterView.isHidden = categoryIDs.isEmpty
            searchCorrectVC.searchWithFilter(categorieIds: categoryIDs)
            searchNearlyVC.searchWithFilter(categorieIds: categoryIDs)
        }
    }
}

extension SearchResultViewController {
    enum SearchType: Int {
        case correct
        case nearly
    }

    struct SearchParam {
        var text: String
        var location: CLLocation
        var categories: [String]?

        init(text: String = "", location: CLLocation = CLLocation(latitude: 16.06064813996494, longitude: 108.2169811846068)) {
            self.text = text
            self.location = location
        }
    }

    struct Config {
        static let attributesForSelected: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor.black]
        static let attributesForNormal: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor: UIColor.gray]
    }
}
