//
//  ApiManager.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]
typealias Completion<Value> = (Result<Value>) -> Void
typealias SearchCompletion<Value> = (Result<Value>) -> Void
typealias APICompletion = (APIResult) -> Void

enum APIResult {
    case success
    case failure(Error)
}

let api = ApiManager()

final class ApiManager {

    let session = Session.shared

    var defaultHTTPHeaders: [String: String] {
        let headers: [String: String] = [:]
        return headers
    }

    var defaultParams: [String: Any] {
        let params: [String: Any] = [
            "oauth_token": "0WE2MZ4WFIA2TRJWPYJ4LON1QHE0FJCGKL4G3KEENHLXB2LF",
//            "oauth_token": Session.shared.accessToken,
            "v": "20190301"]
        return params
    }
}
