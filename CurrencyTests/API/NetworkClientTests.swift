//
//  NetworkClientTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/29.
//

import Foundation
import XCTest
@testable import Currency

class NetworkClientTests: XCTestCase {
    var session: MockURLSession!
    var sut: NetworkClient!

    func testSendSuccess() {
        let request = CurrencyListRequest()
        let data = (try! APITests.testDataFromJSON(fileName: "CurrencyListResponseSuccess"))!

        let response = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: [ContentType.json.rawValue : "Content-Type"])
        session = MockURLSession(data: data, urlResponse: response, error: nil)

        sut = NetworkClient(session)
        sut.send(request) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(168, response.currencies.count)
                XCTAssertEqual("United States Dollar", response.currencies["USD"])
                XCTAssertEqual("New Taiwan Dollar", response.currencies["TWD"])
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testSendFailure() {
        let request = CurrencyListRequest()
        let data = "foo".data(using: .utf8)

        let response = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: [ContentType.json.rawValue : ContentType.ContentTypeField.field.rawValue])
        session = MockURLSession(data: data, urlResponse: response, error: nil)

        sut = NetworkClient(session)
        sut.send(request) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }
}
