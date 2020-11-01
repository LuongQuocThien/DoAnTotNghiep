//
//  Strings.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

/**
 This file defines all localizable strings which are used in this application.
 Please localize defined strings in `Resources/Localizable.strings`.
 */

import Foundation
import SwiftUtils

extension App {
    struct String {
        static let error = "ERROR".localized()
        static let ok = "OK".localized()
        static let home = "Home"
        static let search = "Search"
        static let favorite = "Favorite"
        static let profile = "Profile"
        static let kShowBillInfoNotificationName = "BillInfoNotificationName"
    }

    struct Home {
        static let titleHeaderForTableView = "Near-me"
        static let titleHeaderForCollectionView = "Hot-trend"
    }

    struct Search {
        static let title = "Search"
        static let placeHolder = "Search for restaurant in: "
    }

    struct Location {
        static let title = "Select location"
    }

    struct Map {
        static let title = "Request location service"
        static let msg = "Please go to Setting > Privacy > Location service to turn on location service for \"Map Demo\""
    }

    struct Login {
        static let title = "Đăng nhập"
    }

    struct Detail {
        static let open = "Mở cửa"
        static let close = "Đóng cửa"
    }

    struct Favorite {
        static let title = "Xoá địa điểm"
        static let msg = "Bạn có chắc muốn xoá địa điểm này khỏi danh sách yêu thích?"
        static let titleNavi = "Danh sách yêu thích"
    }

    struct Profile {
        static let edit = "Thay đổi thông tin cá nhân"
        static let password = "Thay đổi mật khẩu"
    }

    struct Payment {
        static let title = "Thanh toán"
    }

    struct Comment {
        static let placeHolderMessage = "Nội dung bình luận"
    }
}
