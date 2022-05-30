//
//  ConfigTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import XCTest
@testable import Currency

class ConfigTests: XCTestCase {
    func testConfig() {
        XCTAssertEqual("http://api.currencylayer.com/", Config.domain)
        XCTAssertEqual("USD", Config.defaultCurrency)
    }

    func testEndPoint() {
        let listURL = URL(string: "http://api.currencylayer.com/list")!
        XCTAssertEqual(listURL, Config.EndPoint.list.url())

        let liveURL = URL(string: "http://api.currencylayer.com/live")!
        XCTAssertEqual(liveURL, Config.EndPoint.live.url())
    }
}
