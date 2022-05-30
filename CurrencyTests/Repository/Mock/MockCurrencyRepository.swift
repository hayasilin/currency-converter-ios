//
//  MockCurrencyRepository.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/29.
//

import Foundation
@testable import Currency

final class MockCurrencyRepository: CurrencyRepositoryProtocol {
    static let shared = MockCurrencyRepository()

    let persistence = MockCurrencyPersistence.shared

    func saveCurrencyList(_ response: CurrencyListResponse, _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

    func saveCurrencyInfo(_ response: CurrencyLiveInfoResponse, _ completion: @escaping (Error?) -> Void) {
        completion(nil)
    }

    func fetchCurrencyListForDisplay(_ completion: @escaping (ManagedCurrencyList?) -> Void) {
        let managedCurrencyList = ManagedCurrencyList(context: persistence.viewContext)
        managedCurrencyList.currencies = [
            "TWD": "New Taiwan Dollar",
            "JPY": "Japanese Yen",
            "KRW": "South Korean Won"
        ]
        completion(managedCurrencyList)
    }

    func fetchCurrencyInfoForDisplay(with source: String, _ completion: @escaping (ManagedCurrencyLiveInfo?) -> Void) {
        let managedCurrencyInfo = ManagedCurrencyLiveInfo(context: persistence.viewContext)
        managedCurrencyInfo.source = "TWD"
        managedCurrencyInfo.time = Date(timeIntervalSince1970: 1653466323)
        managedCurrencyInfo.quotes = [
            "USDTWD": 29.533499,
            "USDJPY": 127.047034,
            "USDKRW": 1264.370525
        ]
        completion(managedCurrencyInfo)
    }
}
