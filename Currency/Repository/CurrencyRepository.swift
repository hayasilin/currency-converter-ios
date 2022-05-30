//
//  CurrencyRepository.swift
//  Currency
//
//  Created by kuanwei on 2022/5/24.
//

import Foundation
import CoreData

protocol CurrencyRepositoryProtocol {
    static var shared: Self { get }

    func saveCurrencyList(_ response: CurrencyListResponse, _ completion: @escaping (Error?) -> Void)
    func saveCurrencyInfo(_ response: CurrencyLiveInfoResponse, _ completion: @escaping (Error?) -> Void)
    func fetchCurrencyListForDisplay(_ completion: @escaping (ManagedCurrencyList?) -> Void)
    func fetchCurrencyInfoForDisplay(with source: String, _ completion: @escaping (ManagedCurrencyLiveInfo?) -> Void)
}

final class CurrencyRepository: CurrencyRepositoryProtocol {
    static let shared = CurrencyRepository(persistence: CurrencyPersistence.shared)

    let persistence: CurrencyPersistenceProtocol

    init(
        persistence: CurrencyPersistenceProtocol = CurrencyPersistence.shared
    ) {
        self.persistence = persistence
    }

    func saveCurrencyList(_ response: CurrencyListResponse, _ completion: @escaping (Error?) -> Void) {
        let transformedCurrencyList = transformCurrencyListResponseForBatchInsert(response)

        guard !transformedCurrencyList.isEmpty else {
            completion(nil)
            return
        }

        persistence.backgroundContextPerform { context in
            do {
                var operationChanges = [[AnyHashable: Any]]()

                let clearChanges = try ManagedCurrencyList.clear(in: context)
                operationChanges.append(clearChanges)

                let saveChanges = try ManagedCurrencyList.save(
                    transformedCurrencyList: transformedCurrencyList,
                    in: context
                )
                operationChanges.append(saveChanges)

                let changes = operationChanges.reduce(into: [AnyHashable: Any]()) { partialResult, opChanges in
                    partialResult.merge(opChanges) { value1, value2 in
                        guard
                            let managedObjectIDArray1 = value1 as? [NSManagedObjectID],
                            let managedObjectIDArray2 = value2 as? [NSManagedObjectID]
                        else {
                            return []
                        }
                        // combine changed managed object IDs for same key such as NSDeletedObjectsKey
                        return managedObjectIDArray1 + managedObjectIDArray2
                    }
                }

                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [context, self.persistence.viewContext]
                )
                completion(nil)
            }
            catch {
                print("failed to \(#function)")
                completion(error)
            }
        }
    }

    func saveCurrencyInfo(_ response: CurrencyLiveInfoResponse, _ completion: @escaping (Error?) -> Void) {
        var responses = [response]

        response.quotes.forEach { (key: String, value: Double) in
            let currencyName = key.replacingOccurrences(of: response.source, with: "")
            let currencyRate = 1 / value

            let currencyLiveInfoResponse = CurrencyLiveInfoResponse(
                success: response.success,
                terms: response.terms,
                privacy: response.privacy,
                timestamp: response.timestamp,
                source: currencyName,
                quotes: ["\(currencyName + response.source)": currencyRate]
            )
            responses.append(currencyLiveInfoResponse)
        }

        let transformedCurrencyInfos = transformCurrencyLiveInfoResponseForBatchInsert(responses)

        guard !transformedCurrencyInfos.isEmpty else {
            completion(nil)
            return
        }

        persistence.backgroundContextPerform { context in
            do {
                let changes = try ManagedCurrencyLiveInfo.save(
                    transformedCurrencyInfos: transformedCurrencyInfos,
                    in: context
                )
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: changes,
                    into: [context, self.persistence.viewContext]
                )
                completion(nil)
            }
            catch {
                print("failed to \(#function)")
                completion(error)
            }
        }
    }

    func fetchCurrencyListForDisplay(_ completion: @escaping (ManagedCurrencyList?) -> Void) {
        persistence.viewContextPerform { context in
            do {
                let fetchRequest = ManagedCurrencyList.fetchRequest()
                fetchRequest.fetchLimit = 1
                let currencyList = try context.fetch(fetchRequest).first
                completion(currencyList)
            }
            catch {
                print("failed to \(#function)")
                completion(nil)
            }
        }
    }

    func fetchCurrencyInfoForDisplay(with source: String, _ completion: @escaping (ManagedCurrencyLiveInfo?) -> Void) {
        persistence.viewContextPerform { context in
            do {
                let fetchRequest = ManagedCurrencyLiveInfo.fetchRequest()
                let predicate = ManagedCurrencyLiveInfo.predicate(source: source)
                fetchRequest.predicate = predicate
                fetchRequest.fetchLimit = 1

                let currencyInfo = try context.fetch(fetchRequest).first
                completion(currencyInfo)
            }
            catch {
                print("failed to \(#function)")
                completion(nil)
            }
        }
    }

    private func transformCurrencyLiveInfoResponseForBatchInsert(
        _ response: [CurrencyLiveInfoResponse]
    ) -> [[String: Any]] {
        response.compactMap { response in
            return [
                #keyPath(ManagedCurrencyLiveInfo.source): response.source,
                #keyPath(ManagedCurrencyLiveInfo.time): Date(timeIntervalSince1970: TimeInterval(response.timestamp)),
                #keyPath(ManagedCurrencyLiveInfo.quotes): response.quotes
            ]
        }
    }

    private func transformCurrencyListResponseForBatchInsert(
        _ response: CurrencyListResponse
    ) -> [[String: Any]] {
        return [[
            #keyPath(ManagedCurrencyList.currencies): response.currencies
        ]]
    }
}
