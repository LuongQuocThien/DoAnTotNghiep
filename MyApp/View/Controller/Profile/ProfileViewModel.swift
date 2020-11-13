//
//  ProfileViewModel.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM
import Firebase

final class ProfileViewModel: ViewModel {

    // MARK: - Properties
    var profile = UserProfile()

    // MARK: - Public
    func numberOfSections() -> Int {
        return SectionType.allCases.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        return sectionType.rowTypes.count
    }

    func titleForHeader(in section: Int) -> String {
        guard let section = SectionType(rawValue: section) else { return "" }
        return section.title
    }

    func viewModelForItem(at indexPath: IndexPath) -> ViewModel {
        guard let sectionType = SectionType(rawValue: indexPath.section),
            let rowType = sectionType.rowTypes[safe: indexPath.row] else { return ProfileTableCellViewModel() }
        return ProfileTableCellViewModel(title: rowType.title)
    }
}

extension ProfileViewModel {

    enum SectionType: Int, CaseIterable {
        case profile
        case support
        case logout

        var rowTypes: [RowType] {
            switch self {
            case .profile:
                return [.changeProfile, .changePassword, .followPeople]
            case .support:
                return [.feedBack]
            case .logout:
                return [.logOut]
            }
        }

        var title: String {
            switch self {
            case .profile:
                return SectionConfig.titleForProfile
            case .support:
                return SectionConfig.titleForSupport
            case .logout:
                return SectionConfig.titleForLogout
            }
        }
    }

    enum RowType: Int, CaseIterable {
        case changeProfile
        case changePassword
        case followPeople
        case feedBack
        case logOut

        var title: String {
            switch self {
            case .changeProfile:
                return ProfileConfig.titleForChangeProfile
            case .changePassword:
                return ProfileConfig.titleForChangePassword
            case .followPeople:
                return ProfileConfig.titleForFollowPeople
            case .feedBack:
                return SupportConfig.titleForFeedBack
            case .logOut:
                return LogOutConfig.titleForLogout
            }
        }
    }
}

// MARK: - API
extension ProfileViewModel {

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

// MAKR: - Computed property
extension ProfileViewModel {

    var homeCity: String { return profile.homeCity }

    var thumbnail: String { return profile.path }

    var name: String { return profile.name }

    var countTips: Int { return profile.countTips }

    var countPhotos: Int { return profile.countPhotos }

    var countFriend: Int { return profile.countFriend }
}

extension ProfileViewModel {
    struct SectionConfig {
        static let titleForProfile = "Thông tin cá nhân"
        static let titleForSupport = "Hỗ trợ"
        static let titleForLogout = "Đăng xuất"
    }

    struct ProfileConfig {
        static let titleForChangeProfile = "Thay đổi thông tin cá nhân"
        static let titleForChangePassword = "Thay đổi mật khẩu"
        static let titleForFollowPeople = "Theo dõi người dùng khác"
    }

    struct SupportConfig {
        static let titleForFeedBack = "Gửi phản hồi"
    }

    struct LogOutConfig {
        static let titleForLogout = "Đăng xuất khỏi ứng dụng"
    }
}
