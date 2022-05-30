//
//  ManagedCurrencyInfoTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import Foundation
import XCTest
@testable import Currency

class ManagedCurrencyLiveInfoTests: XCTestCase {
    var persistence: MockCurrencyPersistence!
    
    override func setUp() {
        super.setUp()
        persistence = MockCurrencyPersistence.shared

        do {
            try saveSampleManagedCurrencyInfo()
        }
        catch {
            XCTFail()
        }
    }

    override func tearDown() {
        do {
            let fetchRequest = ManagedCurrencyLiveInfo.fetchRequest()
            let currencyInfos = try persistence.viewContext.fetch(fetchRequest)

            for currencyInfo in currencyInfos {
                persistence.viewContext.delete(currencyInfo)
            }
            try persistence.viewContext.save()
        }
        catch {
            XCTFail()
        }
        super.tearDown()
    }

    func testCount() {
        do {
            let count = try ManagedCurrencyLiveInfo.count(in: persistence.viewContext)
            XCTAssertEqual(1, count)
        }
        catch {
            XCTFail()
        }
    }

    func testFetch() {
        do {
            let result = try ManagedCurrencyLiveInfo.fetch(in: persistence.viewContext)
            XCTAssertEqual(1, result.count)
        }
        catch {
            XCTFail()
        }
    }

    func testDelete() {
        do {
            let changes = try ManagedCurrencyLiveInfo.delete(source: "USD", in: persistence.viewContext)
            XCTAssertNotNil(changes)
        }
        catch {
            XCTFail()
        }
    }

    func testClear() {
        do {
            let changes = try ManagedCurrencyLiveInfo.clear(in: persistence.viewContext)
            XCTAssertNotNil(changes)
        }
        catch {
            XCTFail()
        }
    }

    private func saveSampleManagedCurrencyInfo() throws {
        do {
            let managedCurrencyInfo = ManagedCurrencyLiveInfo(context: persistence.viewContext)
            managedCurrencyInfo.source = "USD"
            managedCurrencyInfo.time = Date(timeIntervalSince1970: 1653466323)
            managedCurrencyInfo.quotes = [
                "USDTWD": 29.533499,
                "USDJPY": 127.047034,
                "USDKRW": 1264.370525
            ]

            try persistence.viewContext.save()
        } catch {
            XCTFail()
        }
    }
}
