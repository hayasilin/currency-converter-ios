//
//  CurrencyRepository.swift
//  Currency
//
//  Created by kuanwei on 2022/5/24.
//

import Foundation
import CoreData

public protocol CurrencyPersistenceProtocol {
    static var shared: Self { get }

    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }

    func backgroundContextPerform(_ block: @escaping (NSManagedObjectContext) -> Void)
    func backgroundContextPerformAndWait(_ block: @escaping (NSManagedObjectContext) -> Void)
    func viewContextPerform(_ block: @escaping (NSManagedObjectContext) -> Void)
    func viewContextPerformAndWait(_ block: @escaping (NSManagedObjectContext) -> Void)

    func saveViewContext()
}

final class CurrencyPersistence: CurrencyPersistenceProtocol {
    static let shared = CurrencyPersistence(persistenceConfiguration: CurrencyPersistenceConfiguration.shared)

    let persistenceConfiguration: CurrencyPersistenceConfigurationProtocol

    init(
        persistenceConfiguration: CurrencyPersistenceConfigurationProtocol
    ) {
        self.persistenceConfiguration = persistenceConfiguration
    }

    public var viewContext: NSManagedObjectContext {
        return persistenceConfiguration.persistentContainer.viewContext
    }

    public lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = persistenceConfiguration.persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = false
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return backgroundContext
    }()

    /// Asynchronously executes a given block on the private queue of the background context.
    func backgroundContextPerform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = backgroundContext
        context.perform {
            block(context)
        }
    }

    /// Synchronously executes a given block on the private queue of the background context.
    func backgroundContextPerformAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        assert(!Thread.isMainThread, "Background context operation should not block main thread.")
        let context = backgroundContext
        context.performAndWait {
            block(context)
        }
    }

    /// Asynchronously executes a given block on the main queue of the view context.
    func viewContextPerform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = viewContext
        context.perform {
            block(context)
        }
    }

    /// Synchronously executes a given block on the main queue of the view context.
    func viewContextPerformAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = viewContext
        context.performAndWait {
            block(context)
        }
    }

    func saveViewContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
