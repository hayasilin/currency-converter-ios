//
//  CurrencySelectionUserNetworkUseCase.swift
//  Currency
//
//  Created by kuanwei on 2022/5/29.
//

import Foundation

struct CurrencySelectionNetworkUseCase {
    let networkClient: NetworkClient

    init(_ networkClient: NetworkClient = NetworkClient()
    ) {
        self.networkClient = networkClient
    }

    func requestCurrencyLiveInfo(completion: ((Result<CurrencyLiveInfoResponse, Error>) -> Void)?) {
        let request = CurrencyLiveInfoRequest()
        networkClient.send(request) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))

            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func requestCurrencyList(completion: ((Result<CurrencyListResponse, Error>) -> Void)?) {
        let request = CurrencyListRequest()
        networkClient.send(request) { result in
            switch result {
            case .success(let response):
                completion?(.success(response))

            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
