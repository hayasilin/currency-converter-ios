//
//  Request.swift
//  Currency
//
//  Created by kuanwei on 2022/5/28.
//

import Foundation

enum ResponseError: Error {
    case nilData
    case nonHTTPResponse
    case tokenError
    case apiError(error: APIError, statusCode: Int)
}

struct APIError: Decodable {
    let success: Bool
    let error: ErrorInfo

    struct ErrorInfo: Decodable {
        let code: Int
        let info: String
    }
}

protocol NetworkRequest {
    associatedtype Response: Decodable

    var url: URL { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var contentType: ContentType { get }

    var adapters: [NetworkRequestAdapter] { get }
    var decisions: [NetworkResponseDecision] { get }
}

extension NetworkRequest {
    var method: HTTPMethod { return .get }
    var parameters: [String: Any] { return [:] }

    var adapters: [NetworkRequestAdapter] {
        return [
            method.adapter,
            RequestContentAdapter(method: method, contentType: contentType, content: parameters)
        ]
    }

    var decisions: [NetworkResponseDecision] { return [
        RetryDecision(leftCount: 1),
        BadResponseStatusCodeDecision(),
        DataMappingDecision(condition: { $0.isEmpty }) { _ in
            return "{}".data(using: .utf8)!
        },
        ParseResultDecision()
        ]
    }

    func buildRequest() throws -> URLRequest {
        let request = URLRequest(url: url)
        return try adapters.reduce(request) { try $1.adapted($0) }
    }
}
