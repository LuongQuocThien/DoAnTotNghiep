//
//  HeaderDiscoveryReusableView.swift
//  MyApp
//
//  Created by PCI0001 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM

protocol HeaderDiscoveryReusableViewDelegate: class {
    func headerView(_ headerView: HomeHeaderView, needsPerformAction action: HomeHeaderView.Action)
}

final class HomeHeaderView: UICollectionReusableView, View {

    enum Action {
        case changeToOpenNow
        case changeToNearly
    }

    @IBOutlet private weak var openNowButton: UIButton!
    @IBOutlet private weak var nearlyButton: UIButton!
    @IBOutlet private weak var imagesScrollView: UIScrollView!
    @IBOutlet private weak var imagesPageControl: UIPageControl!
    @IBOutlet private weak var imagesContaintView: UIView!

    weak var delegate: HeaderDiscoveryReusableViewDelegate?
    private var timer: Timer?
    private var currentPage = 0
    private var viewModel = HomeHeaderViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runImage), userInfo: nil, repeats: true)
    }

    func toggleTimer(isOff: Bool) {
        if isOff {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runImage), userInfo: nil, repeats: true)
        }
    }

    private func configUI() {
        configScrollView()
        configPageControl()
        toggleNearlyOrOpenNow(isOpenNow: true)
    }

    private func configScrollView() {
        imagesScrollView.delegate = self
        imagesScrollView.isPagingEnabled = true
    }

    private func configPageControl() {
        imagesPageControl.numberOfPages = viewModel.pageCount
        imagesPageControl.currentPage = currentPage
        imagesPageControl.addTarget(self, action: #selector(changePage(sender:)), for: .valueChanged)
    }

    func toggleNearlyOrOpenNow(isOpenNow: Bool) {
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

    // MARK: - Function ObjectC
    @objc private func changePage(sender: AnyObject) {
        let x = CGFloat(imagesPageControl.currentPage) * imagesScrollView.frame.size.width
        imagesScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    @objc private func runImage() {
        imagesPageControl.currentPage = currentPage
        if currentPage == viewModel.pageCount - 1 {
            currentPage = 0
        } else {
            currentPage += 1
        }
        imagesScrollView.setContentOffset(CGPoint(x: imagesContaintView.frame.size.width * CGFloat(currentPage), y: 0), animated: true)
    }

    @IBAction private func changeOpenNowButtonTouchUpInside(_ sender: Any) {
        toggleNearlyOrOpenNow(isOpenNow: true)
        delegate?.headerView(self, needsPerformAction: .changeToOpenNow)
    }

    @IBAction private func changeNearlyButtonTouchUpInside(_ sender: Any) {
        toggleNearlyOrOpenNow(isOpenNow: false)
        delegate?.headerView(self, needsPerformAction: .changeToNearly)
    }
}

// MARK: - Extension UIScrollViewDelegate
extension HomeHeaderView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = imagesScrollView.contentOffset.x / imagesScrollView.frame.size.width
        imagesPageControl.currentPage = Int(pageIndex)
        currentPage = Int(pageIndex)
    }
}

// MARK: - Extension HomeViewController
extension HomeHeaderView {

    struct Config {
        static let buttonNormalFont = UIFont.systemFont(ofSize: 14)
        static let buttonSelectedFont = UIFont.boldSystemFont(ofSize: 14)
    }
}
