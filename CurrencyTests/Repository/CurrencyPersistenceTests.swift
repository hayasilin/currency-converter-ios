//
//  CurrencyPersistenceTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import XCTest
@testable import Currency
import CoreData

class CurrencyPersistenceTests: XCTestCase {
    var sut: CurrencyPersistence!

    override func setUp() {
        super.setUp()
        sut = CurrencyPersistence(persistenceConfiguration: MockCurrencyPersistenceConfiguration())

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
            let currencyInfos = try sut.viewContext.fetch(fetchRequest)

            for currencyInfo in currencyInfos {
                sut.viewContext.delete(currencyInfo)
            }
            try sut.viewContext.save()
        }
        catch {
            XCTFail()
        }
        super.tearDown()
    }

    func testBackgroundContextPerform() throws {
        let expectation = XCTestExpectation(description: #function)

        sut.backgroundContextPerform { context in
            XCTAssertNotNil(context)
            XCTAssertEqual(self.sut.backgroundContext, context)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testBackgroundContextPerformAndWait() {
        let expectation = XCTestExpectation(description: #function)
        
        let backgroundExpectation = XCTestExpectation()
        DispatchQueue.global(qos: .background).async {
            var count = 0
            self.sut.backgroundContextPerformAndWait { context in
                count += 1
                // perfromAndWait will block current thread, so the value is 1
                XCTAssertEqual(1, count)

                XCTAssertNotNil(context)
                XCTAssertEqual(self.sut.backgroundContext, context)
                expectation.fulfill()
            }
            count += 1
            XCTAssertEqual(2, count)
            backgroundExpectation.fulfill()
        }
        wait(for: [
            expectation,
            backgroundExpectation,
        ], timeout: 1)
    }

    func testViewContextPerform() {
        let expectation = XCTestExpectation(description: #function)

        sut.viewContextPerform { context in
            XCTAssertNotNil(context)
            XCTAssertEqual(self.sut.viewContext, context)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testViewContextPerformAndWait() {
        let expectation = XCTestExpectation(description: #function)
        var count = 0
        sut.viewContextPerformAndWait { context in
            count += 1
            // perfromAndWait will block current thread, so the value is 1
            XCTAssertEqual(1, count)

            XCTAssertNotNil(context)
            XCTAssertEqual(self.sut.viewContext, context)
            expectation.fulfill()
        }
        count += 1
        XCTAssertEqual(2, count)

        wait(for: [expectation], timeout: 1)
    }

    func testFetchManagedCurrencyInfoWithBackgroundContextPerform() {
        let expectation = XCTestExpectation(description: #function)

        sut.backgroundContextPerform { context in
            do {
                let currencyInfo = try context.fetch(ManagedCurrencyLiveInfo.fetchRequest())
                XCTAssertEqual(1, currencyInfo.count)
                XCTAssertEqual("USD", currencyInfo.first?.source)
            }
            catch {
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFetchManagedCurrencyInfoWithViewContextPerform() {
        let expectation = XCTestExpectation(description: #function)

        sut.viewContextPerform { context in
            do {
                let currencyInfo = try context.fetch(ManagedCurrencyLiveInfo.fetchRequest())
                XCTAssertEqual(1, currencyInfo.count)
                XCTAssertEqual("USD", currencyInfo.first?.source)
            }
            catch {
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSaveBackgroundContext() {
        let expectation = XCTestExpectation(description: #function)

        sut.backgroundContextPerform { context in
            do {
                let currencyInfo = ManagedCurrencyLiveInfo(context: context)
                currencyInfo.source = "TWD"
                currencyInfo.time = Date(timeIntervalSince1970: 1653466323)

                try context.save()

                let output = try ManagedCurrencyLiveInfo.fetch(source: "TWD", in: context)
                XCTAssertNotNil(output)
                XCTAssertEqual("TWD", output?.source)
                XCTAssertEqual(1653466323, output?.time?.timeIntervalSince1970)
                XCTAssertNil(output?.quotes)
            }
            catch {
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSaveViewContext() {
        let expectation = XCTestExpectation(description: #function)

        sut.viewContextPerform { context in
            do {
                let currencyInfo = ManagedCurrencyLiveInfo(context: context)
                currencyInfo.source = "TWD"
                currencyInfo.time = Date(timeIntervalSince1970: 1653466323)

                try context.save()

                let output = try ManagedCurrencyLiveInfo.fetch(source: "TWD", in: context)
                XCTAssertNotNil(output)
                XCTAssertEqual("TWD", output?.source)
                XCTAssertEqual(1653466323, output?.time?.timeIntervalSince1970)
                XCTAssertNil(output?.quotes)
            }
            catch {
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}

extension CurrencyPersistenceTests {
    private func saveSampleManagedCurrencyInfo() throws {
        let managedCurrencyInfo = ManagedCurrencyLiveInfo(context: sut.viewContext)
        managedCurrencyInfo.source = "USD"
        managedCurrencyInfo.time = Date(timeIntervalSince1970: 1653466323)
        managedCurrencyInfo.quotes = [
            "USDTWD": 29.533499,
            "USDJPY": 127.047034,
            "USDKRW": 1264.370525
        ]

        sut.saveViewContext()
    }
}
