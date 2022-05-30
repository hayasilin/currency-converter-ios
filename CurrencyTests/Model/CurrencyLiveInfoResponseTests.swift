//
//  CurrencyLiveInfoResponseTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import XCTest
@testable import Currency

class CurrencyLiveInfoResponseTests: XCTestCase {
    func testCurrencyListResponseDecodeSuccess() throws {
        let data = (try APITests.testDataFromJSON(fileName: "CurrencyListResponseSuccess"))!
        let response = try JSONDecoder().decode(CurrencyListResponse.self, from: data)

        XCTAssertEqual(168, response.currencies.count)
        XCTAssertEqual("United States Dollar", response.currencies["USD"])
        XCTAssertEqual("New Taiwan Dollar", response.currencies["TWD"])
    }

    func testCurrencyLiveInfoResponseDecodeSuccess() throws {
        let data = (try APITests.testDataFromJSON(fileName: "CurrencyLiveInfoResponseSuccess"))!
        let response = try JSONDecoder().decode(CurrencyLiveInfoResponse.self, from: data)

        XCTAssertEqual("USD", response.source)
        XCTAssertEqual(1653466323, response.timestamp)
        XCTAssertEqual(168, response.quotes.count)
        XCTAssertEqual(29.533499, response.quotes["USDTWD"])
    }
}
