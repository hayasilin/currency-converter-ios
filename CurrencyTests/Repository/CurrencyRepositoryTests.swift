//
//  CurrencyRepositoryTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import Foundation
import CoreData
import XCTest
@testable import Currency

class CurrencyRepositoryTests: XCTestCase {
    var persistence: MockCurrencyPersistence!
    var sut: CurrencyRepository!

    override func setUp() {
        super.setUp()
        persistence = MockCurrencyPersistence.shared
        sut = CurrencyRepository(persistence: persistence)

        do {
            try insertSampleManagedCurrencyLiveInfo()
            try insertSampleManagedCurrencyList()
        }
        catch {
            XCTFail()
        }
    }

    override func tearDown() {
        do {
            try persistence.clearManagedCurrencyList()
            try persistence.clearManagedCurrencyInfo()
        } catch {
            XCTFail()
        }
        super.tearDown()
    }

    func testSaveCurrencyList() {
        let data = (try! APITests.testDataFromJSON(fileName: "CurrencyListResponseSuccess"))!
        let response = try! JSONDecoder().decode(CurrencyListResponse.self, from: data)

        let expectation = XCTestExpectation(description: #function)

        sut.saveCurrencyList(response) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSaveCurrencyInfo() {
        let data = (try! APITests.testDataFromJSON(fileName: "CurrencyLiveInfoResponseSuccess"))!
        let response = try! JSONDecoder().decode(CurrencyLiveInfoResponse.self, from: data)

        let expectation = XCTestExpectation(description: #function)

        sut.saveCurrencyInfo(response) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFetchCurrencyListForDisplay() {
        let expectation = XCTestExpectation(description: #function)

        sut.fetchCurrencyListForDisplay { managedCurrencyList in
            XCTAssertNotNil(managedCurrencyList)
            XCTAssertEqual(3, managedCurrencyList?.currencies?.count)
            XCTAssertEqual("New Taiwan Dollar", managedCurrencyList?.currencies?["TWD"])

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFetchCurrencyInfoForDisplay() {
        let expectation = XCTestExpectation(description: #function)

        sut.fetchCurrencyInfoForDisplay(with: Config.defaultCurrency) { managedCurrencyInfo in
            XCTAssertNotNil(managedCurrencyInfo)
            XCTAssertEqual("USD", managedCurrencyInfo?.source)
            XCTAssertEqual(1653466323, managedCurrencyInfo?.time?.timeIntervalSince1970)
            XCTAssertEqual(3, managedCurrencyInfo?.quotes?.count)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}

extension CurrencyRepositoryTests {
    private func insertSampleManagedCurrencyList() throws {
        do {
            let managedCurrencyList = ManagedCurrencyList(context: persistence.viewContext)
            managedCurrencyList.currencies = ManagedCurrencyListSample.currencies
            try persistence.viewContext.save()
        } catch {
            XCTFail()
        }
    }

    private func insertSampleManagedCurrencyLiveInfo() throws {
        do {
            let managedCurrencyInfo = ManagedCurrencyLiveInfo(context: persistence.viewContext)
            managedCurrencyInfo.source = ManagedCurrencyLiveInfoSample.USDLiveInfo.source
            managedCurrencyInfo.time = ManagedCurrencyLiveInfoSample.USDLiveInfo.time
            managedCurrencyInfo.quotes = ManagedCurrencyLiveInfoSample.USDLiveInfo.quotes
            try persistence.viewContext.save()
        } catch {
            XCTFail()
        }
    }
}
