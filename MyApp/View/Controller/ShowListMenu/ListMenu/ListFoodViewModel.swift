//
//  ListFoodViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

final class ListFoodViewModel {

    // MARK: - Properties
    var venueID: String
    var menus: Menu?
    var foodCategories: [FoodCategory] = []
    var foodInfomations: [FoodInfomation] = []
    // Firebase
    var newMenu: NewMenu?

    init(venueID: String = "") {
        self.venueID = venueID
    }

    func numberOfItems () -> Int {
        return newMenu?.foods.count ?? 0
    }

    func viewModelForItem(at indexPath: IndexPath) -> NewMenuFoodCellViewModel {
        guard let food = newMenu?.foods[indexPath.section].items[indexPath.row] else { return NewMenuFoodCellViewModel() }
        return NewMenuFoodCellViewModel(food: food)
    }

    enum DetailVenueResult {
        case success
        case failure(Error)
    }

    func getMenu(_ completion: @escaping (DetailVenueResult) -> Void) {
        Api.Venue.getMenu(id: venueID) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let menus):
                this.menus = menus
                this.foodCategories = menus.category
                this.foodCategories.forEach({ (item) in
                    this.foodInfomations.append(contentsOf: item.product)
                })
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Firebase
    func getMenuFirebase(_ completion: @escaping (DetailVenueResult) -> Void) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/menu")
        ref.queryOrdered(byChild: "venueId").queryEqual(toValue: venueID)
            .observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }

                let menus = Mapper<NewMenu>().mapArray(JSONArray: items)
                this.newMenu = menus.first
                completion(.success)
            }) { (error) in
                completion(.failure(error))
        }
    }
}
