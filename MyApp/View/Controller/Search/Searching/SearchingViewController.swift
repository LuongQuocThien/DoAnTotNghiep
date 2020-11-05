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
    @IBOutlet private weak var recentlyButton: UIButton!
    @IBOutlet private weak var historyButton: UIButton!

    private var pageVC: UIPageViewController?
    private var viewControllers: [UIViewController] = []
    let recentlyVC = RecentlyViewController()
    let historyVC = HistorySearchViewController()
    private var searchType: SearchType = .recently {
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
        viewControllers.append(recentlyVC)
        viewControllers.append(historyVC)
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let pageVC = pageVC {
            containerView.addSubview(pageVC.view)
            addChildViewController(pageVC)
            pageVC.view.frame = containerView.bounds
            pageVC.setViewControllers([recentlyVC], direction: .forward, animated: true, completion: nil)
        }
        setDisplayTab()
        historyVC.delegate = self
    }

    private func switchingPage() {
        guard let pageVC = pageVC, let vcs = pageVC.viewControllers else { return }
        let viewVC = viewControllers[searchType.rawValue]
        let direction: UIPageViewController.NavigationDirection
        if !vcs.contains(viewVC) {
            switch searchType {
            case .recently:
                direction = .reverse
            case .history:
                direction = .forward
            }
            setDisplayTab()
            pageVC.setViewControllers([viewVC], direction: direction, animated: true, completion: nil)
        }
    }

    private func setDisplayTab() {
        switch searchType {
        case .recently:
            let attributeSelected = NSAttributedString(string: recentlyButton.titleLabel?.text ?? "", attributes: Config.attributesForSelected)
            recentlyButton.setAttributedTitle(attributeSelected, for: .normal)
            let attributeNormal = NSAttributedString(string: historyButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
            historyButton.setAttributedTitle(attributeNormal, for: .normal)
        case .history:
            let attributeSelected = NSAttributedString(string: historyButton.titleLabel?.text ?? "", attributes: Config.attributesForSelected)
            historyButton.setAttributedTitle(attributeSelected, for: .normal)
            let attributeNormal = NSAttributedString(string: recentlyButton.titleLabel?.text ?? "", attributes: Config.attributesForNormal)
            recentlyButton.setAttributedTitle(attributeNormal, for: .normal)
        }
    }

    @IBAction private func searchTypeButtonTouchUpInside(_ sender: UIButton) {
        guard let type = SearchType(rawValue: sender.tag) else { return }
        switch type {
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
        }
    }
}

extension SearchingViewController {

    enum SearchType: Int {
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
