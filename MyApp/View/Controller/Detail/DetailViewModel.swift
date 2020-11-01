//
//  DetailViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 1/29/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import MVVM
import SwiftUtils
import CoreLocation
import RealmSwift

final class DetailViewModel: ViewModel {

    // MARK: - Properties
    // MARK: - Public to unit test
    var sections: [SectionType] = []
    var restaurant = Restaurant()
    var comments: [Comment] = []
    private(set) var venueID: String
    var isLoading = false
    var photos: [Photo] = []
    var numberOfItems = 20

    var isCanLoadMore: Bool {
        return comments.count < restaurant.commentsCount
    }

    init(venueID: String = "") {
        self.venueID = venueID
    }

    // MARK: - Public
    func viewModelForMapVC() -> MapViewModel {
        return MapViewModel(restaurant: restaurant)
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        if sections.count > section {
            let type = sections[section]
            switch type {
            case .menu:
                return 1
            case .comment:
                return comments.count
            case .infomation:
                return 1
            case .address:
                return 1
            }
        }
        return 0
    }

    func viewModelForItem(at indexPath: IndexPath) -> ViewModel {
        let type = sections[indexPath.section]
        switch type {
        case .menu:
            return MenuTableCellViewModel(menus: photos)
        case .comment:
            return CommentCellViewModel(comment: comments[indexPath.row])
        case .infomation:
            return InformationCellViewModel(restaurant: restaurant)
        case .address:
            return AddressCellViewModel(restaurant: restaurant)
        }
    }

    func getComment() -> [Comment] {
        return comments
    }

    func getMenuViewModel() -> MenuViewModel {
        return MenuViewModel(venueID: restaurant.id, restaurantName: restaurant.name)
    }
}

// MARK: - API
extension DetailViewModel {

    func getDetailVenue(_ completion: @escaping APICompletion) {
        Api.Venue.getDetailVenue(id: venueID) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let value):
                this.restaurant = value
                this.sections.append(.infomation)
                this.sections.append(.address)
                this.fetchData()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getComment(isLoadMore: Bool = false, completion: @escaping APICompletion) {
        if !isLoadMore {
            numberOfItems = 20
        } else {
            numberOfItems += Config.limit
        }
        Api.Venue.getComment(venueId: venueID, limits: numberOfItems) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let comments):
                this.comments = comments
                if !comments.isEmpty && !this.sections.contains(.comment) {
                    this.sections.append(.comment)
                }
                completion(.success)
                this.isLoading = false
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPhotos(completion: @escaping APICompletion) {
        Api.Venue.getPhoto(id: venueID) { [weak self] (result) in
            guard let this = self else { return }
            this.isLoading = false
            switch result {
            case .success(let photos):
                this.photos = photos
                if !photos.isEmpty {
                    this.sections.append(.menu)
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Realm
extension DetailViewModel {

    func saveToRealm() {
        let favoriteRestaurant = FavoriteRestaurant(id: restaurant.id,
            name: restaurant.name,
            address: restaurant.address,
            rating: String(restaurant.rating),
            thumbnail: restaurant.thumbnailImageUrlString,
            countryCity: restaurant.city)
        RealmManager.shared.add(object: favoriteRestaurant)
    }

    func removeOutRealm() {
        guard let favoriteRestaurant = RealmManager.shared.fetchObject(FavoriteRestaurant.self, filter: NSPredicate(format: "id=%@", venueID)) else { return }
        RealmManager.shared.delete(object: favoriteRestaurant)
    }

    func fetchData() {
        guard let data = RealmManager.shared.fetchObjects(FavoriteRestaurant.self) else { return }
        restaurant.isFavorite = data.contains(where: { return $0.id == venueID })
    }
}

// MARK: - Enum
extension DetailViewModel {

    enum SectionType: Int {
        case infomation
        case menu
        case comment
        case address
    }
}

extension DetailViewModel {

    struct Config {
        static let limit = 20
        static let offset = 0
    }
}
