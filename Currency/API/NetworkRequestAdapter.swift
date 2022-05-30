//
//  RequestAdapter.swift
//  Currency
//
//  Created by kuanwei on 2022/5/28.
//

import Foundation

protocol NetworkRequestAdapter {
    func adapted(_ request: URLRequest) throws -> URLRequest
}

struct AnyAdapter: NetworkRequestAdapter {
    let block: (URLRequest) throws -> URLRequest
    func adapted(_ request: URLRequest) throws -> URLRequest {
        return try block(request)
    }
}

struct RequestContentAdapter: NetworkRequestAdapter {
    let method: HTTPMethod
    let contentType: ContentType
    let content: [String: Any]

    func adapted(_ request: URLRequest) throws -> URLRequest {
        switch method {
        case .get:
            return try URLQueryDataAdapter(data: content).adapted(request)
        case .post:
            let headerAdapter = contentType.headerAdapter
            let dataAdapter = contentType.dataAdapter(for: content)
            let req = try headerAdapter.adapted(request)
            return try dataAdapter.adapted(req)
        }
    }
}

struct URLQueryDataAdapter: NetworkRequestAdapter {
    let data: [String: Any]
    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        if let url = request.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = data.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            request.url = urlComponents.url
        }
        return request
    }
}

struct JSONRequestDataAdapter: NetworkRequestAdapter {
    let data: [String: Any]
    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        return request
    }
}

struct URLFormRequestDataAdapter: NetworkRequestAdapter {
    let data: [String: Any]
    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.httpBody =
            data.map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .data(using: .utf8)
        return request
    }
}
