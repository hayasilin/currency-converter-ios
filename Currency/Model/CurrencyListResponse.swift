//
//  CurrencyListResponse.swift
//  Currency
//
//  Created by kuanwei on 2022/5/28.
//

import Foundation

struct CurrencyListResponse: Codable {
    var currencies: [String: String]
}

struct CurrencyDescription {
    let name: String
    let detailDescription: String
}
