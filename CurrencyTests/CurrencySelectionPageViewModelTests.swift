//
//  CurrencySelectionPageViewModelTests.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import XCTest
@testable import Currency

class CurrencySelectionPageViewModelTests: XCTestCase {
    var persistence: MockCurrencyPersistence!
    var repository: MockCurrencyRepository!
    var networkUseCase: CurrencySelectionNetworkUseCase!
    var userDefaultsUseCase: CurrencySelectionUserDefaultsUseCase!
    var userDefaults: UserDefaults!
    var sut: CurrencySelectionPageViewModel!

    override func setUp() {
        super.setUp()
        persistence = MockCurrencyPersistence.shared
        repository = MockCurrencyRepository.shared
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        let networkClient = NetworkClient(mockURLSession)
        networkUseCase = CurrencySelectionNetworkUseCase(networkClient)
        userDefaults = UserDefaults(suiteName: "MockUserDefaults")!
        userDefaultsUseCase = CurrencySelectionUserDefaultsUseCase(userDefaults)

        sut = CurrencySelectionPageViewModel(repository, networkUseCase, userDefaultsUseCase)
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

    func testFetchCurrencyInfoFromCoreData() {
        userDefaults.lastCachedCurrencyListDate = Date()
        userDefaults.lastCachedCurrencyLiveInfoDate = Date()

        let expectation = XCTestExpectation(description: #function)
        expectation.expectedFulfillmentCount = 3

        sut.fetchCurrencyInfo(with: "USD") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        sut.currencyExchangeRates.observe = { currencyExchangeRates in
            XCTAssertEqual(3, currencyExchangeRates.count)
            expectation.fulfill()
        }

        sut.currencyList.observe = { currencyList in
            XCTAssertEqual(3, currencyList.count)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
