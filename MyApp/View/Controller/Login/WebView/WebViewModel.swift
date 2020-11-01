//
//  WebViewModel.swift
//  MyApp
//
//  Created by PCI0001 on 2/18/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class WebViewModel: ViewModel {

    enum Request {
        case authenticate
        case accessToken(code: String)
    }

    func urlForLoadWebView(type: Request) -> URLComponents {
        switch type {
        case .authenticate:
            guard var url = URLComponents(string: Api.Path.OAuth.authenticateUrl) else { return URLComponents() }
            let params = FoursquareParam()
            var queryItems: [URLQueryItem] = []
            for item in params.toJson_Code {
                queryItems.append(URLQueryItem(name: item.key, value: item.value))
            }
            url.queryItems = queryItems
            return url
        case .accessToken(let code):
            guard var url = URLComponents(string: Api.Path.OAuth.accessTokenUrl) else { return URLComponents() }
            let params = FoursquareParam(code: code)
            var queryItems: [URLQueryItem] = []
            for item in params.toJson_AccessToken {
                queryItems.append(URLQueryItem(name: item.key, value: item.value))
            }
            url.queryItems = queryItems
            return url
        }
    }

    func convertToken(html: Any?) -> String? {
        guard let htmlString = html as? String, htmlString.contains("access_token"),
            let accessToken = String(htmlEncodedString: htmlString),
            let token = accessToken.replace("\"access_token\":\"", withString: "")?.replace("\"", withString: "") else { return nil }
        return token.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}\n", with: "")
    }
}

extension WebViewModel {

    struct FoursquareParam {
        let clienID = App.Foursquare.clienID
        let clientSecret = App.Foursquare.clienSecret
        let grant_type = "authorization_code"
        let responseType = "code"
        let redirectURI = "https://www.google.com"
        var code = ""

        init() {}

        init(code: String) {
            self.code = code
        }

        var toJson_Code: [String: String] {
            var json: [String: String] = [:]
            json["client_id"] = clienID
            json["response_type"] = responseType
            json["redirect_uri"] = redirectURI
            return json
        }

        var toJson_AccessToken: [String: String] {
            var json: [String: String] = [:]
            json["client_id"] = clienID
            json["client_secret"] = clientSecret
            json["grant_type"] = grant_type
            json["redirect_uri"] = redirectURI
            json["code"] = code
            return json
        }
    }
}
