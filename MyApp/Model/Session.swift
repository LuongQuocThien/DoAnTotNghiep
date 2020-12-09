//
//  Session.swift
//  MyApp
//
//  Created by PCI0001 on 2/18/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MapKit

final class Session {

    private let userDefault = UserDefaults.standard
    static let shared = Session()

    var accessToken: String {
        get {
            return userDefault.string(forKey: App.UserDefault.accessToken) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.accessToken)
            if newValue.isEmpty {
                isLogin = false
            } else {
                isLogin = true
            }
        }
    }

    var isLogin: Bool {
        get {
            return userDefault.bool(forKey: App.UserDefault.isLogin)
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.isLogin)
        }
    }

    // Firebase --------------------------------
    var userId: String {
        get {
            return userDefault.string(forKey: App.UserDefault.userId) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.userId)
        }
    }

    var password: String {
        get {
            return userDefault.string(forKey: App.UserDefault.password) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.password)
        }
    }

    var email: String {
        get {
            return userDefault.string(forKey: App.UserDefault.email) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.email)
        }
    }

    var firstName: String {
        get {
            return userDefault.string(forKey: App.UserDefault.firstName) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.firstName)
        }
    }

    var lastName: String {
        get {
            return userDefault.string(forKey: App.UserDefault.lastName) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.lastName)
        }
    }

    var address: String {
        get {
            return userDefault.string(forKey: App.UserDefault.address) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.address)
        }
    }

    var avatarUrlSring: String {
        get {
            return userDefault.string(forKey: App.UserDefault.userAvatar) ?? ""
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.userAvatar)
        }
    }
    // ---------------------------

    var currentLocationCoordinateLat: Double {
        get {
            if userDefault.double(forKey: App.UserDefault.currentLocationCoordinateLatitue) == 0 {
                return 16.070_266
            }
            return userDefault.double(forKey: App.UserDefault.currentLocationCoordinateLatitue)
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.currentLocationCoordinateLatitue)
        }
    }

    var currentLocationCoordinateLng: Double {
        get {
            if userDefault.double(forKey: App.UserDefault.currentLocationCoordinateLongtitude) == 0 {
                return 108.213_342
            }
            return userDefault.double(forKey: App.UserDefault.currentLocationCoordinateLongtitude)
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.currentLocationCoordinateLongtitude)
        }
    }

    var currentLocationName: String {
        get {
            return userDefault.string(forKey: App.UserDefault.currentLocationName) ?? "Da Nang, Viet Nam"
        } set {
            userDefault.set(newValue, forKey: App.UserDefault.currentLocationName)
        }
    }
}
