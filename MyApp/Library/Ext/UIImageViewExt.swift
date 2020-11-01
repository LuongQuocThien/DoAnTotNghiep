//
//  UIImageViewExt.swift
//  MyApp
//
//  Created by PCI0001 on 1/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import SDWebImage

extension UIImageView {

    func setImageWithURL(_ url: String, placeholderImage: UIImage? = nil) {
        guard let url = URL(string: url) else { return }
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [.allowInvalidSSLCertificates,
                                                                             .continueInBackground,
                                                                             .retryFailed], completed: nil)
    }
}
