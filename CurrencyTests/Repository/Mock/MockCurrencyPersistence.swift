//
//  MockCurrencyPersistence.swift
//  CurrencyTests
//
//  Created by kuanwei on 2022/5/26.
//

import Foundation
import CoreData
@testable import Currency

final class MockCurrencyPersistence: CurrencyPersistenceProtocol {
    static let shared = MockCurrencyPersistence(persistenceConfiguration: MockCurrencyPersistenceConfiguration.shared)

    let persistenceConfiguration: CurrencyPersistenceConfigurationProtocol
    var viewContext: NSManagedObjectContext
    var backgroundContext: NSManagedObjectContext

    private init(
        persistenceConfiguration: CurrencyPersistenceConfigurationProtocol
    ) {
        self.persistenceConfiguration = persistenceConfiguration
        viewContext = persistenceConfiguration.persistentContainer.viewContext
        backgroundContext = persistenceConfiguration.persistentContainer.newBackgroundContext()
    }

    func backgroundContextPerform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = backgroundContext
        context.perform {
            block(context)
        }
    }

    func backgroundContextPerformAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        assert(!Thread.isMainThread, "background context's performAndWait should not be called in main thread.")
        let context = backgroundContext
        context.performAndWait {
            block(context)
        }
    }

    func viewContextPerform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = viewContext
        context.perform {
            block(context)
        }
    }

    func viewContextPerformAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = viewContext
        context.performAndWait {
            block(context)
        }
    }

    func saveBackgroundContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func saveViewContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func clearManagedCurrencyInfo() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedCurrencyLiveInfo.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(deleteRequest)
    }

    func clearManagedCurrencyList() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedCurrencyList.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try viewContext.execute(deleteRequest)
    }
}
