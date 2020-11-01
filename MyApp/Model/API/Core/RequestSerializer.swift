//
//  RequestSerializer.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2016 AsianTech Co., Ltd. All rights reserved.
//

import Alamofire
import Foundation

extension ApiManager {
    @discardableResult
    func request(method: HTTPMethod,
                 urlString: URLStringConvertible,
                 parameters: [String: Any]? = nil,
                 headers: [String: String]? = nil,
                 completion: Completion<Any>?) -> Request? {
        guard Network.shared.isReachable else {
            completion?(.failure(Api.Error.network))
            return nil
        }

        let encoding: ParameterEncoding
        if method == .post {
            encoding = JSONEncoding.default
        } else {
            encoding = URLEncoding.default
        }

        var defaultHeader = api.defaultHTTPHeaders
        defaultHeader.updateValues(headers)

        var defaultParams = api.defaultParams
        defaultParams.updateValues(parameters)

        let request = Alamofire.request(urlString.urlString,
                                        method: method,
                                        parameters: defaultParams,
                                        encoding: encoding,
                                        headers: defaultHeader
        ).responseJSON(completion: { (response) in
            completion?(response.result)
        })

        return request
    }
}
