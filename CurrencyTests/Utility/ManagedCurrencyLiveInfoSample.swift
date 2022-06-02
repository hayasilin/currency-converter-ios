//
//  ManagedCurrencyLiveInfoSample.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/6/2.
//

import Foundation
@testable import Currency

struct ManagedCurrencyLiveInfoSample {
    struct USDLiveInfo {
        static let source = "USD"
        static let time = Date(timeIntervalSince1970: 1653466323)
        static let quotes = [
            "USDTWD": 29.533499,
            "USDJPY": 127.047034,
            "USDKRW": 1264.370525
        ]
    }
}
