//
//  ImageManager.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/5/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class ImageManager {

    static let shared = ImageManager()

    // MARK: - Properties
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol = NSObject()

    // MARK: - Init
    private init() {
        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil, queue: nil) { [weak self] _ in
            self?.cache.removeAllObjects()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(observer)
    }

    // MARK: - Public func
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
