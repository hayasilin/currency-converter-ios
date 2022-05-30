//
//  CurrencySelectionUserDefaultsUseCaseTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/28.
//

import XCTest
@testable import Currency

class CurrencySelectionUserDefaultsUseCaseTests: XCTestCase {
    var userDefaults: UserDefaults!
    var sut: CurrencySelectionUserDefaultsUseCase!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "MockUserDefaults")!

        sut = CurrencySelectionUserDefaultsUseCase(userDefaults)
    }

    func testSetLastViewedCurrencyName() {
        let expected = "TWDUSD"
        sut.setLastViewedCurrencyName(expected)

        XCTAssertEqual(expected, sut.lastViewedCurrencyName)
    }

    func testSetCurrencyLiveInfoUpdateDate() {
        let date = Date()
        sut.setCurrencyLiveInfoUpdateDate(date)

        XCTAssertEqual(date.timeIntervalSince1970, userDefaults.lastCachedCurrencyLiveInfoDate.timeIntervalSince1970, accuracy: 000000.1)
    }

    func testSetCurrencyListUpdateDate() {
        let date = Date()
        sut.setCurrencyListUpdateDate(date)

        XCTAssertEqual(date.timeIntervalSince1970, userDefaults.lastCachedCurrencyListDate.timeIntervalSince1970, accuracy: 0.1)
    }
}
