//
//  LocationViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import Firebase
import ObjectMapper

final class LocationViewModel: ViewModel {

    // MARK: - Properties
    private(set) var locations: [NewLocation] = []
    var resultSearchLocations: [NewLocation] = []

    // MARK: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return resultSearchLocations.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> LocationCellViewModel {
        return LocationCellViewModel(name: resultSearchLocations[indexPath.row].city)
    }

    func getLocation(at indexPath: IndexPath) -> NewLocation {
        return resultSearchLocations[indexPath.row]
    }
}

extension LocationViewModel {

    // MARK: - Firebase
    func getAllLocationsFireBase(completion: @escaping APICompletion) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/location")
            ref.observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let locations = Mapper<NewLocation>().mapArray(JSONArray: items)
                this.locations = locations
                this.resultSearchLocations = locations
                completion(.success)
            }) { (error) in
                completion(.failure(error))
        }
    }
}
