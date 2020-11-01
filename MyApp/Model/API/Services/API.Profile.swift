//
//  API.Profile.swift
//  MyApp
//
//  Created by PCI0010 on 3/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

extension Api.Users {

    @discardableResult
    static func getProfile(completion: @escaping Completion<UserProfile>) -> Request? {
        let url = Api.Path.Users().profile
        return api.request(method: .get, urlString: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject,
                        let venue = Mapper<UserProfile>().map(JSONObject: json) else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    completion(.success(venue))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
