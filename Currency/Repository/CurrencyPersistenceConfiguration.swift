//
//  CurrencyPersistenceConfiguration.swift
//  Currency
//
//  Created by kuanwei on 2022/5/27.
//

import Foundation
import CoreData

protocol CurrencyPersistenceConfigurationProtocol {
    static var shared: Self { get }

    var persistentContainer: NSPersistentContainer { get }
}

final class CurrencyPersistenceConfiguration: CurrencyPersistenceConfigurationProtocol {
    static let shared = CurrencyPersistenceConfiguration()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Currency")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return container
    }()
}
