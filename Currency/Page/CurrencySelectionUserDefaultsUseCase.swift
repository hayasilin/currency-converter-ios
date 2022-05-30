//
//  CurrencySelectionLastViewedUseCase.swift
//  Currency
//
//  Created by kuanwei on 2022/5/28.
//

import Foundation

class CurrencySelectionUserDefaultsUseCase {
    var userDefaults: UserDefaults

    var lastViewedCurrencyName: String? {
        userDefaults.lastViewedCurrencyName
    }

    init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func setLastViewedCurrencyName(_ currencyName: String) {
        userDefaults.lastViewedCurrencyName = currencyName
    }

    func setCurrencyLiveInfoUpdateDate(_ date: Date = Date()) {
        self.userDefaults.lastCachedCurrencyLiveInfoDate = date
    }

    func setCurrencyListUpdateDate(_ date: Date = Date()) {
        self.userDefaults.lastCachedCurrencyListDate = date
    }

    func isCachedCurrencyInfoValid(type: Config.EndPoint) -> Bool {
        var date: Date
        switch type {
        case .list:
            date = userDefaults.lastCachedCurrencyListDate
        case .live:
            date = userDefaults.lastCachedCurrencyLiveInfoDate
        }

        if let hoursSinceLastSave = Calendar.current.dateComponents(
            [.hour],
            from: date,
            to: Date()
        ).hour {
            // Cached news is valide for 1 hours
            return hoursSinceLastSave < 1
        }
        else {
            return false
        }
    }
}
