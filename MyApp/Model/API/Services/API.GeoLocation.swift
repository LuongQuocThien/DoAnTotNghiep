//
//  API.Location.swift
//  MyApp
//
//  Created by TAN HUYNH on 2/27/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Api.GeoLocation {

    struct QueryParams {
        var query: String

        func toJSON() -> Parameters {
            return [
                "query": query
                ]
        }

        init(query: String) {
            self.query = query
        }
    }

    @discardableResult
    static func query(query: String, completion: @escaping Completion<[GeoLocation]>) -> Request? {
        let path = Api.Path.Venue.geoLocationUrlString
        let params = QueryParams(query: query)
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject,
                        let response = json["response"] as? JSObject,
                        let results = response["results"] as? JSArray else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    let locations = Mapper<GeoLocation>().mapArray(JSONArray: results)
                    completion(.success(locations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
