//
//  URLExt.swift
//  MyApp
//
//  Created by PCI0001 on 2/18/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

extension URL {

    func getQueryStringParameter(key: String) -> String? {
        guard let url = URLComponents(string: urlString) else { return nil }
        return url.queryItems?.first(where: { $0.name == key })?.value
    }
}
