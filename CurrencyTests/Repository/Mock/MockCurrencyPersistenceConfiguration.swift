//
//  MockCurrencyPersistenceConfiguration.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/27.
//

import Foundation
import CoreData
@testable import Currency

private let coreDataModel = (name: "Currency", extension: "momd")

final class MockCurrencyPersistenceConfiguration: CurrencyPersistenceConfigurationProtocol {
    static let shared = MockCurrencyPersistenceConfiguration()

    let persistentContainer: NSPersistentContainer = {
        // URL with path "/dev/null" will create in-memory stores for testing
        // You can refer this by watching WWDC 2018 and 2019 Core Data sessions
        let description = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))

        guard let managedObjectModel = createManagedObjectModel() else {
            fatalError("Failed to create a NSManagedObjectModel for Currency")
        }

        let container = NSPersistentContainer(name: coreDataModel.name, managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                assertionFailure("Unresolved error: \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    private static func createManagedObjectModel() -> NSManagedObjectModel? {
        let bundle = Bundle.main
        let url = bundle.url(forResource: coreDataModel.name, withExtension: coreDataModel.extension)
        return url.flatMap(NSManagedObjectModel.init)
    }
}
