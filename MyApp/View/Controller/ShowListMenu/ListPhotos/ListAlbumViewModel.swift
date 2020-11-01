//
//  ListAlbumViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/6/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class ListAlbumViewModel {

    // MARK: - Properties
    private let venueID: String
    var photos: [Photo] = []
    private var isLoading = false

    init(venueID: String = "") {
        self.venueID = venueID
    }

    // MARK: - Public
    func numberOfItems() -> Int {
        return photos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> AlbumPhotoCellViewModel {
        return AlbumPhotoCellViewModel(photo: photos[indexPath.row])
    }

    func getPhotos(completion: @escaping (APIResult) -> Void) {
        Api.Venue.getPhoto(id: venueID) { [weak self] (result) in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let photos):
                this.photos = photos
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPhotoForDetail(at indexPath: IndexPath) -> PhotoViewModel {
        let photo = photos[indexPath.row]
        return PhotoViewModel(photo: photo)
    }
}
