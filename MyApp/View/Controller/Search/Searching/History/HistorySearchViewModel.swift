//
//  SearchedViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import RealmSwift

protocol HistorySearchViewModelDelegate: class {
    func viewModel(_ viewModel: HistorySearchViewModel, needsPerform action: HistorySearchViewModel.Action)
}

final class HistorySearchViewModel: ViewModel {

    // MARK: - Enum
    enum Action {
        case reloadData
    }

    // MARK: - Properties
    // Public to unit test
    var historySearchs: [History] = []
    private var notificationToken: NotificationToken?
    weak var delegate: HistorySearchViewModelDelegate?

    func numberOfItems(inSection section: Int) -> Int {
        return historySearchs.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> HistorySearchCellViewModel {
        if historySearchs.count > indexPath.row {
            return HistorySearchCellViewModel(historySearch: historySearchs[indexPath.row])
        }
        return HistorySearchCellViewModel(historySearch: History(content: ""))
    }

    func getKeyOfHistory(at indexPath: IndexPath) -> String {
        return historySearchs[indexPath.row].content
    }
}

// MARK: - Realm
extension HistorySearchViewModel {

    func fetchHistorySearchRealm() {
        guard let datas = RealmManager.shared.fetchObjects(History.self)?.reversed() else { return }
        historySearchs = [History](datas)
        delegate?.viewModel(self, needsPerform: .reloadData)
    }

    func observe() {
        notificationToken = RealmManager.shared.observe(type: History.self, completion: { [weak self] _ in
            guard let this = self else { return }
            this.fetchHistorySearchRealm()
        })
    }
}
