//
//  Api.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

final class Api {

    struct Path {
        static var version: String { return "v2" }
        static var baseURL: String { return "https://api.foursquare.com" / version }
        static let baseAuthURL = "https://foursquare.com/oauth2"
    }

    struct Discovery { }
    struct WebView { }
    struct Search { }
    struct Photo { }
    struct GeoLocation { }
    struct Category { }

    struct Venue {
        let id: String
    }

    struct Users {
        let id: String
    }
}

extension Api.Path {

    struct Venue {
        let id: String
        static var path: String { return baseURL / "venues" }
        var urlString: String { return Venue.path }
        var detail: String { return Venue.path / id }
        var comments: String { return detail / "tips" }
        var photos: String { return detail / "photos" }
        var menu: String { return detail / "menu" }
        static var searchUrlString: String { return baseURL / "search/recommendations" }
        static var geoLocationUrlString: String { return baseURL / "search/geoautocomplete" }
    }

    struct OAuth {
        private static let oauthPath = "/authenticate"
        private static let accessPath = "/access_token"
        static var authenticateUrl: String = baseAuthURL + oauthPath
        static var accessTokenUrl: String = baseAuthURL + accessPath
    }

    struct EndPoint {
        static var path: String { return baseURL }
        private let search = "search/recommendations"
        var urlString: String { return EndPoint.path / "venues" }
        var discoveryUrlString: String { return EndPoint.path / search }
        var categoryUrlString: String { return EndPoint.path / "venues" / "categories" }
    }

    struct Users {
        var id = "self"
        static var path: String { return baseURL / "users" }
        var profile: String { return Users.path / id }
    }
}

protocol URLStringConvertible {
    var urlString: String { get }
}

protocol ApiPath: URLStringConvertible {
    static var path: String { get }
}

extension URL: URLStringConvertible {
    var urlString: String { return absoluteString }
}

extension Int: URLStringConvertible {
    var urlString: String { return String(describing: self) }
}

private func / (lhs: URLStringConvertible, rhs: URLStringConvertible) -> String {
    return lhs.urlString + "/" + rhs.urlString
}

extension String: URLStringConvertible {
    var urlString: String { return self }
}

extension CustomStringConvertible where Self: URLStringConvertible {
    var urlString: String { return description }
}
