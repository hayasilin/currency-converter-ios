//
//  CurrencyLiveInfoRequest.swift
//  Currency
//
//  Created by kuanwei on 2022/5/29.
//

import Foundation

struct CurrencyLiveInfoRequest: NetworkRequest {
    typealias Response = CurrencyLiveInfoResponse

    let url: URL = Config.EndPoint.live.url()!
    let method: HTTPMethod = .get
    let contentType: ContentType = .json

    var parameters: [String : Any] = [
        "access_key": Config.apiAccessKey
    ]
}
