//
//  API.Menu.swift
//  MyApp
//
//  Created by PCI0010 on 3/7/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.Venue {

    @discardableResult
    static func getMenu(id: String, completion: @escaping Completion<Menu>) -> Request? {
        let url = Api.Path.Venue(id: id).menu
        return api.request(method: .get, urlString: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject,
                        let venue = Mapper<Menu>().map(JSONObject: json) else {
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
