//
//  FilterViewModel.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 2/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class FilterViewModel: ViewModel {

    // MARK: - Properties
    // Public to unit test
    var categories: [Category] = []
    var selectedCategories: [Category] = []

    var numberOfFilterCount: Int {
        return selectedCategories.count
    }

    // MARK: - Public
    func numberOfItems(inSection section: Int) -> Int {
        return categories.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> FilterCollectionCellViewModel {
        let category = categories[indexPath.row]
        let isSelected = selectedCategories.contains(category)
        return FilterCollectionCellViewModel(category: category, isSelected: isSelected)
    }

    func clearFilter() {
        selectedCategories.removeAll()
    }

    func changeStatusSelect(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        if selectedCategories.contains(category) {
            _ = selectedCategories.remove(category)
        } else {
            selectedCategories.append(category)
        }
    }
}

extension FilterViewModel {

    func getListCategory(completion: @escaping APICompletion) {
        Api.Category.getCategories { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let categories):
                if !categories.isEmpty {
                    this.categories = categories
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
