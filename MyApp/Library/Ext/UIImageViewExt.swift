//
//  UIImageViewExt.swift
//  MyApp
//
//  Created by PCI0001 on 1/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import SDWebImage

extension UIImageView {

    private static var taskKey = 0
    private static var urlKey = 0

    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setImageWithURL(_ url: String, completion: (() -> Void)? = nil) {
        // Cancel task
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()

        // Reset image
        image = nil

        guard let url = URL(string: url) else { return }

        // Get image in cache if have
        if let cachedImage = ImageManager.shared.image(forKey: url.absoluteString) {
            image = cachedImage
            completion?()
            return
        }

        // Download image
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let this = self else { return }

            this.currentTask = nil
            if let error = error {
                print(error.localizedDescription)
                completion?()
                return
            }
            if let data = data, let image = UIImage(data: data) {
                ImageManager.shared.save(image: image, forKey: url.absoluteString)
                if url == this.currentURL {
                    DispatchQueue.main.async {
                        this.image = image
                        completion?()
                    }
                }
            }
        }
        currentTask = task
        task.resume()
    }
}
