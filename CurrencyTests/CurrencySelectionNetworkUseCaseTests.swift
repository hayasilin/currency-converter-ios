//
//  CurrencySelectionNetworkUseCaseTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/30.
//

import XCTest
@testable import Currency

class CurrencySelectionNetworkUseCaseTests: XCTestCase {
    var session: MockURLSession!
    var networkClient: NetworkClient!
    var sut: CurrencySelectionNetworkUseCase!

    func testRequestCurrencyLiveInfo() {
        let request = CurrencyLiveInfoRequest()
        let data = (try! APITests.testDataFromJSON(fileName: "CurrencyLiveInfoResponseSuccess"))!

        let response = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: [ContentType.json.rawValue : "Content-Type"])
        session = MockURLSession(data: data, urlResponse: response, error: nil)
        networkClient = NetworkClient(session)
        sut = CurrencySelectionNetworkUseCase(networkClient)

        sut.requestCurrencyLiveInfo { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual("USD", response.source)
                XCTAssertEqual(1653466323, response.timestamp)
                XCTAssertEqual(168, response.quotes.count)
                XCTAssertEqual(29.533499, response.quotes["USDTWD"])

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testRequestCurrencyList() {
        let request = CurrencyListRequest()
        let data = (try! APITests.testDataFromJSON(fileName: "CurrencyListResponseSuccess"))!

        let response = HTTPURLResponse(url: request.url, statusCode: 200, httpVersion: nil, headerFields: [ContentType.json.rawValue : "Content-Type"])
        session = MockURLSession(data: data, urlResponse: response, error: nil)
        networkClient = NetworkClient(session)
        sut = CurrencySelectionNetworkUseCase(networkClient)

        sut.requestCurrencyList { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual(168, response.currencies.count)
                XCTAssertEqual("United States Dollar", response.currencies["USD"])
                XCTAssertEqual("New Taiwan Dollar", response.currencies["TWD"])

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
