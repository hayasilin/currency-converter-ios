//
//  CurrencyListRequest.swift
//  Currency
//
//  Created by kuanwei on 2022/5/29.
//

import Foundation

struct CurrencyListRequest: NetworkRequest {
    typealias Response = CurrencyListResponse

    let url: URL = Config.EndPoint.list.url()!
    let method: HTTPMethod = .get
    let contentType: ContentType = .json

    var parameters: [String : Any] = [
        "access_key": Config.apiAccessKey
    ]
}
