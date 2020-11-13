//
//  API.Discovery.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.Discovery {

    enum DiscoveryMode {
        case openNow(coordinate: String, offset: Int)
        case nearly(coordinate: String, offset: Int)
    }

    struct QueryParams {
        var mode: DiscoveryMode
        let radius = 5_000
        var openNow = "true"
        var categories = "4d4b7105d754a06374d81259"
        let limit = 20

        func toJSON() -> Parameters {
            switch mode {
            case .openNow(let coordinate, let offset):
                return [
                    "ll": coordinate,
                    "openNow": openNow,
                    "categories": categories,
                    "limit": limit,
                    "offset": offset
                    ]
            case .nearly(let coordinate, let offset):
                return [
                    "ll": coordinate,
                    "radius": radius,
                    "categories": categories,
                    "limit": limit,
                    "offset": offset
                    ]
            }
        }

        init(mode: DiscoveryMode) {
            self.mode = mode
        }
    }

    @discardableResult
    static func query(mode: DiscoveryMode, completion: @escaping Completion<[DiscoveryRestaurant]>) -> Request? {
        let path = Api.Path.EndPoint().discoveryUrlString
        let params = QueryParams(mode: mode)
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject,
                        let response = json["response"] as? JSObject,
                        let group = response["group"] as? JSObject,
                        let results = group["results"] as? JSArray else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    let restaurants = Mapper<DiscoveryRestaurant>().mapArray(JSONArray: results)
                    completion(.success(restaurants))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
