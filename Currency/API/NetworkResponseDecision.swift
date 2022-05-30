//
//  Decision.swift
//  Currency
//
//  Created by kuanwei on 2022/5/28.
//

import Foundation

protocol NetworkResponseDecision {
    func shouldApply<Request: NetworkRequest>(request: Request, data: Data, response: HTTPURLResponse) -> Bool
    func apply<Request: NetworkRequest>(
        request: Request,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Request>) -> Void)
}

enum DecisionAction<Request: NetworkRequest> {
    case continueWith(Data, HTTPURLResponse)
    case restartWith([NetworkResponseDecision])
    case errored(Error)
    case done(Request.Response)
}

struct DataMappingDecision: NetworkResponseDecision {

    let condition: (Data) -> Bool
    let transform: (Data) -> Data

    init(condition: @escaping ((Data) -> Bool), transform: @escaping (Data) -> Data) {
        self.transform = transform
        self.condition = condition
    }

    func shouldApply<Request: NetworkRequest>(request: Request, data: Data, response: HTTPURLResponse) -> Bool {
        return condition(data)
    }

    func apply<Request: NetworkRequest>(
        request: Request,
        data: Data, response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Request>) -> Void)
    {
        closure(.continueWith(transform(data), response))
    }
}

struct ParseResultDecision: NetworkResponseDecision {
    func shouldApply<Request: NetworkRequest>(request: Request, data: Data, response: HTTPURLResponse) -> Bool {
        return true
    }

    func apply<Request: NetworkRequest>(
        request: Request,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Request>) -> Void)
    {
        do {
            let value = try JSONDecoder().decode(Request.Response.self, from: data)
            closure(.done(value))
        } catch {
            closure(.errored(error))
        }
    }
}

struct RetryDecision: NetworkResponseDecision {
    let leftCount: Int
    func shouldApply<Request: NetworkRequest>(request: Request, data: Data, response: HTTPURLResponse) -> Bool {
        let isStatusCodeValid = (200..<300).contains(response.statusCode)
        return !isStatusCodeValid && leftCount > 0
    }

    func apply<Request: NetworkRequest>(
        request: Request,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Request>) -> Void)
    {
        let retryDecision = RetryDecision(leftCount: leftCount - 1)
        let newDecisions = request.decisions.replacing(self, with: retryDecision)
        closure(.restartWith(newDecisions))
    }
}

struct BadResponseStatusCodeDecision: NetworkResponseDecision {
    func shouldApply<Request: NetworkRequest>(request: Request, data: Data, response: HTTPURLResponse) -> Bool {
        return !(200..<300).contains(response.statusCode)
    }

    func apply<Request: NetworkRequest>(
        request: Request,
        data: Data,
        response: HTTPURLResponse,
        done closure: @escaping (DecisionAction<Request>) -> Void)
    {
        do {
            let value = try JSONDecoder().decode(APIError.self, from: data)
            closure(.errored(ResponseError.apiError(error: value, statusCode: response.statusCode)))
        } catch {
            closure(.errored(error))
        }
    }
}

// MARK: - Utils

extension Array where Element == NetworkResponseDecision {
    func removing(_ item: NetworkResponseDecision) -> Array {
        // TODO: Implement it
        print("Not implemented yet.")
        return self
    }

    func replacing(_ item: NetworkResponseDecision, with: NetworkResponseDecision?) -> Array {
        // TODO: Implement it
        print("Not implemented yet.")
        return self
    }
}
