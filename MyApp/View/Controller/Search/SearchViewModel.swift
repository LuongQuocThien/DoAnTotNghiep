//
//  SearchViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import CoreLocation

final class SearchViewModel: ViewModel {

    // MARK: - Properties
    var keyword = ""
    var coordinate = CLLocationCoordinate2D()

    func getParamForSearchResult() -> SearchResultViewController.SearchParam {
        return SearchResultViewController.SearchParam(text: keyword, location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}

// MARK: - Realm
extension SearchViewModel {

    func saveHistorySearchRealm(keyword: String) {
        guard !keyword.isEmpty else { return }
        let historySearch = History(content: keyword)
        RealmManager.shared.add(object: historySearch)
    }
}
