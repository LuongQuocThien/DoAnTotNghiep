//
//  Mapper.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension Mapper where N: Mappable {
    func map(result: Result<Any>, type: DataType, completion: Completion<Any>) {
        switch result {
        case .success(let json):
            switch type {
            case .object:
                if let json = json as? JSObject {
                    completion(.success(json))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .array:
                if let json = json as? JSArray {
                    completion(.success(json))
                } else {
                    completion(.failure(Api.Error.json))
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func mapArray(array: JSArray, completion: @escaping ([N]) -> Void) {
        let objects = Mapper<N>().mapArray(JSONArray: array)
        DispatchQueue.main.async {
            completion(objects)
        }
    }
}

enum DataType {
    case object
    case array
}
