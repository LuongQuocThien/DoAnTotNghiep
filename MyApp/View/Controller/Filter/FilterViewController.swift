//
//  FilterViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/21/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate: class {
    func controller(_ controller: FilterViewController, needsPerformAction action: FilterViewController.Action)
}

final class FilterViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var countFilterView: UIView!
    @IBOutlet private weak var countFilterLabel: UILabel!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var heightFilterViewConstraint: NSLayoutConstraint!

    var viewModel = FilterViewModel()
    weak var delegate: FilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        callAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCountFilterLabel()
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {
        configCollectionView()
        countFilterView.layer.cornerRadius = countFilterView.bounds.size.width / 2
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        heightFilterViewConstraint.constant = UIScreen.main.bounds.height / 2
    }

    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Config.sizeForItem
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(FilterCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func callAPI() {
        viewModel.getListCategory { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.collectionView.reloadData()
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }

    private func updateCountFilterLabel() {
        countFilterLabel.text = String(viewModel.numberOfFilterCount)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Action
    @IBAction private func cancelButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func applyButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.controller(self, needsPerformAction: .apply(viewModel.selectedCategories))
    }

    @IBAction private func clearButtonTouchUpInside(_ sender: Any) {
        viewModel.clearFilter()
        updateCountFilterLabel()
        collectionView.reloadData()
    }
}

extension FilterViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(FilterCollectionCell.self, forIndexPath: indexPath)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }
}

extension FilterViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.changeStatusSelect(at: indexPath)
        collectionView.reloadItems(at: [indexPath])
        updateCountFilterLabel()
    }
}

// MARK: Enum
extension FilterViewController {

    enum Action {
        case apply([Category])
    }

    struct Config {
        static let heightForRow: CGFloat = 250
        static let sizeForItem = CGSize(width: 78, height: 85)
    }
}
