//
//  UserDefaults+Extension.swift
//  Currency
//
//  Created by kuanwei on 2022/5/26.
//

import Foundation

extension UserDefaults {
    static var lastCachedCurrencyLiveInfoDateKey = "lastCachedCurrencyLiveInfoDateKey"

    var lastCachedCurrencyLiveInfoDate: Date {
        get {
            Date(timeIntervalSinceReferenceDate: double(forKey: UserDefaults.lastCachedCurrencyLiveInfoDateKey))
        }
        set {
            set(newValue.timeIntervalSinceReferenceDate, forKey: UserDefaults.lastCachedCurrencyLiveInfoDateKey)
        }
    }

    static var lastCachedCurrencyListDateKey = "lastCachedCurrencyListDateKey"

    var lastCachedCurrencyListDate: Date {
        get {
            Date(timeIntervalSinceReferenceDate: double(forKey: UserDefaults.lastCachedCurrencyListDateKey))
        }
        set {
            set(newValue.timeIntervalSinceReferenceDate, forKey: UserDefaults.lastCachedCurrencyListDateKey)
        }
    }

    static var lastViewedCurrencyNameKey = "lastViewedCurrencyNameKey"

    var lastViewedCurrencyName: String? {
        get {
            string(forKey: UserDefaults.lastViewedCurrencyNameKey)
        }
        set {
            set(newValue, forKey: UserDefaults.lastViewedCurrencyNameKey)
        }
    }
}
