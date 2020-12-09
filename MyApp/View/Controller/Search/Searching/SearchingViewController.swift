//
//  SearchingViewController.swift
//  MyApp
//
//  Created by PCI0001 on 3/8/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol SearchingViewControllerDelegate: class {
    func controller(_ controller: SearchingViewController, needsPerform action: SearchingViewController.Action)
}

final class SearchingViewController: UIViewController {

    enum Action {
        case keyOfHistory(keySearched: String)
    }

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var correctButton: UIButton!
    @IBOutlet private weak var recentlyButton: UIButton!
    @IBOutlet private weak var historyButton: UIButton!

    private var pageVC: UIPageViewController?
    private var viewControllers: [UIViewController] = []
    let searchCorrectVC = SearchCorrectViewController()
    let recentlyVC = RecentlyViewController()
    let historyVC = HistorySearchViewController()
    var searchParam: SearchResultViewController.SearchParam? {
        didSet {
            searchCorrectVC.searchCorrect(isLoadMore: false, searchParams: searchParam)
        }
    }
    var searchType: SearchType = .correctly {
        didSet {
            switchingPage()
        }
    }
    weak var delegate: SearchingViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
    }

    private func setupContainerView() {
        viewControllers.append(searchCorrectVC)
        viewControllers.append(recentlyVC)
        viewControllers.append(historyVC)
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let pageVC = pageVC {
            containerView.addSubview(pageVC.view)
            addChildViewController(pageVC)
            pageVC.view.frame = containerView.bounds
            pageVC.setViewControllers([searchCorrectVC], direction: .forward, animated: true, completion: nil)
        }
        setDisplayTab()
        historyVC.delegate = self
    }

    private func switchingPage() {
        guard let pageVC = pageVC, let vcs = pageVC.viewControllers else { return }
        let viewVC = viewControllers[searchType.rawValue]
        if !vcs.contains(viewVC) {
            setDisplayTab()
            pageVC.setViewControllers([viewVC], direction: getAnimation(), animated: true, completion: nil)
        }
    }

    private func getAnimation() -> UIPageViewController.NavigationDirection {
        switch searchType {
        case .correctly:
            return .reverse
        case .recently:
            return .forward
        case .history:
            return .forward
        }
    }

    private func setDisplayTab() {
        switch searchType {
        case .correctly:
            setButtonSelected(button: correctButton)
        case .recently:
            setButtonSelected(button: recentlyButton)
        case .history:
            setButtonSelected(button: historyButton)
        }
    }

    private func setButtonSelected(button: UIButton) {
        let attributeNormal1 = NSAttributedString(string: correctButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
        correctButton.setAttributedTitle(attributeNormal1, for: .normal)
        let attributeNormal2 = NSAttributedString(string: historyButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
        historyButton.setAttributedTitle(attributeNormal2, for: .normal)
        let attributeNormal3 = NSAttributedString(string: recentlyButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
        recentlyButton.setAttributedTitle(attributeNormal3, for: .normal)
        let attributeSelected = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: Config.attributesForSelected)
        button.setAttributedTitle(attributeSelected, for: .normal)
    }

    @IBAction private func searchTypeButtonTouchUpInside(_ sender: UIButton) {
        guard let type = SearchType(rawValue: sender.tag) else { return }
        switch type {
        case .correctly:
            guard searchType != .correctly else { return }
            searchType = .correctly
        case .recently:
            guard searchType != .recently else { return }
            searchType = .recently
        case .history:
            guard searchType != .history else { return }
            searchType = .history
        }
    }
}

extension SearchingViewController: HistorySearchViewControllerDelegate {

    func controller(_ controller: HistorySearchViewController, needsPerform action: HistorySearchViewController.Action) {
        switch action {
        case .keyOfHistory(let keySearched):
            delegate?.controller(self, needsPerform: .keyOfHistory(keySearched: keySearched))
            searchType = .correctly
            switchingPage()
        }
    }
}

extension SearchingViewController {

    enum SearchType: Int {
        case correctly
        case recently
        case history
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
