//
//  UIScrollViewExt.swift
//  MyApp
//
//  Created by PCI0001 on 2/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import SwiftUtils

extension UIScrollView {

    func setupSlide(with images: [UIImage]) {
        for (index, image) in images.enumerated() {
            let xPos = kScreenSize.width * CGFloat(index)
            let imageView = UIImageView(frame: CGRect(x: xPos,
                                                      y: 0,
                                                      width: kScreenSize.width,
                                                      height: bounds.height))
            imageView.image = image
            addSubview(imageView)
        }
        contentSize = CGSize(width: kScreenSize.width * CGFloat(images.count), height: bounds.height)
    }

    func setupSlide(with paths: [String]) {
        for (index, path) in paths.enumerated() {
            let xPos = kScreenSize.width * CGFloat(index)
            let imageView = UIImageView(frame: CGRect(x: xPos,
                                                      y: 0,
                                                      width: kScreenSize.width,
                                                      height: bounds.height))
            imageView.setImageWithURL(path)
            addSubview(imageView)
        }
        contentSize = CGSize(width: kScreenSize.width * CGFloat(paths.count), height: bounds.height)
    }
}
