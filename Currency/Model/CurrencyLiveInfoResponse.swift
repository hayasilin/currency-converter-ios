//
//  CurrencylayerResponse.swift
//  Currency
//
//  Created by kuanwei on 2022/5/10.
//

import Foundation

struct CurrencyLiveInfoResponse: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let timestamp: Int64
    let source: String
    let quotes: [String: Double]
}

struct CurrencyExchangeRate {
    let name: String
    let rate: Double
}
