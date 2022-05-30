//
//  Config.swift
//  Currency
//
//  Created by kuanwei on 2022/5/25.
//

import Foundation

// "http://api.currencylayer.com/live?access_key=db75a8da48473c50dfad89ba872a886e"
struct Config {
    static let domain = "http://api.currencylayer.com/"
    static let defaultCurrency = "USD"

    static var apiAccessKey: String {
        return Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    }

    static let currencyLayerParameters = [
        "access_key": apiAccessKey
    ]

    enum EndPoint: String {
        case list
        case live

        func url() -> URL? {
            let format = self.format()
            return URL(string: String(format: format))
        }

        private func format() -> String {
            domain + self.rawValue
        }
    }
}
