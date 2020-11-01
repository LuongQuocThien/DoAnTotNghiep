//
//  PhotoViewController.swift
//  MyApp
//
//  Created by PCI0001 on 3/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class PhotoViewController: UIViewController {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var photoScrollView: UIScrollView!

    var viewModel = PhotoViewModel()

    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        photoImageView.setImageWithURL(viewModel.photo.path)
        configScrollView()
    }

    private func configScrollView() {
        photoScrollView.delegate = self
        photoScrollView.minimumZoomScale = 1.0
        photoScrollView.maximumZoomScale = 10.0
    }

    @IBAction private func dismissButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
