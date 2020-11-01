//
//  API.Category.swift
//  MyApp
//
//  Created by PCI0001 on 3/13/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import Firebase

extension Api.Category {

    struct QueryParams {

        func toJSON() -> Parameters {
            return [:]
        }
    }

    @discardableResult
    static func query(completion: @escaping Completion<[Category]>) -> Request? {
        let path = Api.Path.EndPoint().categoryUrlString
        let params = QueryParams()
        return api.request(method: .get, urlString: path, parameters: params.toJSON()) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    guard let json = value as? JSObject,
                        let response = json["response"] as? JSObject,
                        let food_Categories = (response["categories"] as? JSArray)?[3],
                        let asian_Categories = (food_Categories["categories"] as? JSArray)?[3],
                        let country_Categories = asian_Categories["categories"] as? JSArray else {
                            completion(.failure(Api.Error.json))
                            return
                    }
                    let categories = Mapper<Category>().mapArray(JSONArray: country_Categories)
                    completion(.success(categories))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    static func getCategories(completion: @escaping Completion<[Category]>) {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/category")
        ref.observe(.value, with: { (snapshot) in
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let categories = Mapper<Category>().mapArray(JSONArray: items)
                completion(.success(categories))
            }) { (error) in
                completion(.failure(error))
        }
    }
}
