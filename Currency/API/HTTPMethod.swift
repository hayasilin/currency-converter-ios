//
//  HTTPMethod.swift
//  Currency
//
//  Created by kuanwei on 2022/5/28.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

extension HTTPMethod {
    var adapter: AnyAdapter {
        return AnyAdapter { request in
            var req = request
            req.httpMethod = self.rawValue
            return req
        }
    }
}

enum ContentType: String {
    case json = "application/json"
    case urlForm = "application/x-www-form-urlencoded; charset=utf-8"

    enum ContentTypeField: String {
        case field = "Content-Type"
    }

    var headerAdapter: AnyAdapter {
        return AnyAdapter { request in
            var request = request
            request.setValue(self.rawValue, forHTTPHeaderField: ContentTypeField.field.rawValue)
            return request
        }
    }

    func dataAdapter(for data: [String: Any]) -> NetworkRequestAdapter {
        switch self {
        case .json: return JSONRequestDataAdapter(data: data)
        case .urlForm: return URLFormRequestDataAdapter(data: data)
        }
    }
}
