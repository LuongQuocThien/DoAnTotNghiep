//
//  EditProfileViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 3/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class EditProfileViewModel {

    var profile = UserProfile()
}

// MAKR: - Computed property
extension EditProfileViewModel {

    var firstname: String { return profile.firstName }

    var lastname: String { return profile.lastName }

    var phone: Int { return profile.phone }

    var email: String { return profile.email }

    var thumbnail: String { return profile.path }

    var gender: String { return profile.gender }

    var infomation: String { return profile.infomation }
}

// MARK: - API
extension EditProfileViewModel {

    func getProfile(_ completion: @escaping APICompletion) {
        Api.Users.getProfile { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success(let profile):
                this.profile = profile
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
