//
//  ManagedCurrencyListTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import Foundation
import XCTest
@testable import Currency

class ManagedCurrencyListTests: XCTestCase {
    var persistence: MockCurrencyPersistence!

    override func setUp() {
        super.setUp()
        persistence = MockCurrencyPersistence.shared

        do {
            try saveSampleManagedCurrencyList()
        }
        catch {
            XCTFail()
        }
    }

    override func tearDown() {
        do {
            let fetchRequest = ManagedCurrencyList.fetchRequest()
            let currencyLists = try persistence.viewContext.fetch(fetchRequest)

            for currencyList in currencyLists {
                persistence.viewContext.delete(currencyList)
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
            let count = try ManagedCurrencyList.count(in: persistence.viewContext)
            XCTAssertEqual(1, count)
        }
        catch {
            XCTFail()
        }
    }

    func testFetch() {
        do {
            let result = try ManagedCurrencyList.fetch(in: persistence.viewContext)
            XCTAssertEqual(1, result.count)
        }
        catch {
            XCTFail()
        }
    }

    private func saveSampleManagedCurrencyList() throws {
        do {
            let currencyList = ManagedCurrencyList(context: persistence.viewContext)
            currencyList.currencies = [
                "TWD": "New Taiwan Dollar",
                "JPY": "Japanese Yen",
                "KRW": "South Korean Won"
            ]

            try persistence.viewContext.save()
        } catch {
            XCTFail()
        }
    }
}
