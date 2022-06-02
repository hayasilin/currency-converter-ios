//
//  CurrencySelectionPageViewModel.swift
//  Currency
//
//  Created by kuanwei on 2022/5/11.
//

import Foundation

struct CurrencySelectionPageViewModel {
    let repository: CurrencyRepositoryProtocol
    let networkUseCase: CurrencySelectionNetworkUseCase
    let userDefaultsUseCase: CurrencySelectionUserDefaultsUseCase

    let currencyExchangeRates = ObservableValue<[CurrencyExchangeRate]>(value: [])
    let currencyList = ObservableValue<[CurrencyDescription]>(value: [])

    var lastViewedCurrencyName: String? {
        userDefaultsUseCase.lastViewedCurrencyName
    }

    init(_ repository: CurrencyRepositoryProtocol = CurrencyRepository.shared,
         _ networkUseCase: CurrencySelectionNetworkUseCase = CurrencySelectionNetworkUseCase(),
         _ userDefaultsUseCase: CurrencySelectionUserDefaultsUseCase = CurrencySelectionUserDefaultsUseCase()
    ) {
        self.networkUseCase = networkUseCase
        self.repository = repository
        self.userDefaultsUseCase = userDefaultsUseCase
    }

    func fetchCurrencyLiveInfo(with source: String, completion: ((Error?) -> Void)?) {
        // TODO: Use Combine
        if userDefaultsUseCase.isCachedCurrencyInfoValid(type: .live) {
            fetchCurrencyLiveInfoForDisplay(with: source)
            fetchCurrencyList(completion: completion)
        } else {
            requestCurrencyLiveInfo { error in
                if let error = error {
                    completion?(error)
                } else {
                    fetchCurrencyLiveInfoForDisplay(with: source)
                    setCurrencyLiveInfoUpdateDate()
                    fetchCurrencyList(completion: completion)
                    completion?(nil)
                }
            }
        }
    }

    func fetchCurrencyLiveInfoForDisplay(with source: String) {
        repository.fetchCurrencyInfoForDisplay(with: source) { managedCurrencyInfo in
            guard let managedCurrencyInfo = managedCurrencyInfo, let quotes = managedCurrencyInfo.quotes else {
                return
            }

            let result = quotes.keys.map {
                CurrencyExchangeRate(name: $0, rate: quotes[$0] ?? 0.0)
            }.sorted { $0.name < $1.name }

            self.currencyExchangeRates.value = result
        }
    }

    func setLastViewedCurrencyName(_ currencyName: String) {
        userDefaultsUseCase.setLastViewedCurrencyName(currencyName)
    }

    // MARK: Private

    private func fetchCurrencyList(completion: ((Error?) -> Void)?) {
        if userDefaultsUseCase.isCachedCurrencyInfoValid(type: .list) {
            fetchCurrencyListForDisplay()
            completion?(nil)
        } else {
            // Avoid exceed `Rate Limits` for requesting currencylayer API in a row
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .seconds(2)) {
                requestCurrencyList { error in
                    if let error = error {
                        completion?(error)
                    } else {
                        fetchCurrencyListForDisplay()
                        setCurrencyListUpdateDate()
                        completion?(nil)
                    }
                }
            }
        }
    }

    private func fetchCurrencyListForDisplay() {
        repository.fetchCurrencyListForDisplay() { managedCurrencyList in
            guard let managedCurrencyList = managedCurrencyList, let currencies = managedCurrencyList.currencies else {
                return
            }

            let result = currencies.keys.map {
                CurrencyDescription(name: $0, detailDescription: currencies[$0] ?? "")
            }.sorted { $0.name < $1.name }

            self.currencyList.value = result
        }
    }

    private func requestCurrencyLiveInfo(completion: ((Error?) -> Void)?) {
        networkUseCase.requestCurrencyLiveInfo { result in
            switch result {
            case .success(let response):
                repository.saveCurrencyInfo(response) { error in
                    if let error = error {
                        completion?(error)
                    } else {
                        completion?(nil)
                    }
                }
            case .failure(let error):
                completion?(error)
            }
        }
    }

    private func requestCurrencyList(completion: ((Error?) -> Void)?) {
        networkUseCase.requestCurrencyList { result in
            switch result {
            case .success(let response):
                repository.saveCurrencyList(response) { error in
                    if let error = error {
                        completion?(error)
                    } else {
                        completion?(nil)
                    }
                }
            case .failure(let error):
                completion?(error)
            }
        }
    }

    private func setCurrencyLiveInfoUpdateDate() {
        userDefaultsUseCase.setCurrencyLiveInfoUpdateDate()
    }

    private func setCurrencyListUpdateDate() {
        userDefaultsUseCase.setCurrencyListUpdateDate()
    }
}
