//
//  HistorySearchCellViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 3/11/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class HistorySearchCellViewModel: ViewModel {

    // MARK: - Properties
    // Public to unit test
    var historySearch = History()

    // MARK: - Init
    init() { }

    init(historySearch: History) {
        self.historySearch = historySearch
    }

    func getHistorySearch() -> History {
        return historySearch
    }
}

// MARK: - Realm
extension HistorySearchCellViewModel {

    func deleteHistorySearchRealm() {
        RealmManager.shared.delete(object: historySearch)
    }
}
