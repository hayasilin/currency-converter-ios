//
//  ManagedCurrencyList+Fetch.swift
//  Currency
//
//  Created by kuanwei on 2022/5/25.
//

import Foundation
import CoreData

extension ManagedCurrencyList {
    public static let entityName = "ManagedCurrencyList"

    public static func count(
        in context: NSManagedObjectContext
    ) throws -> Int {
        try context.count(for: ManagedCurrencyList.fetchRequest())
    }

    public static func fetch(
        in context: NSManagedObjectContext
    ) throws -> [ManagedCurrencyList] {
        try context.fetch(ManagedCurrencyList.fetchRequest())
    }

    public static func save(
        transformedCurrencyList: [[String: Any]],
        in context: NSManagedObjectContext
    ) throws -> [AnyHashable: Any] {
        let insertRequest = NSBatchInsertRequest(
            entity: ManagedCurrencyList.entity(),
            objects: transformedCurrencyList
        )
        insertRequest.resultType = .objectIDs
        let result = try context.execute(insertRequest) as? NSBatchInsertResult
        return [NSInsertedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
    }

    public static func clear(in context: NSManagedObjectContext) throws -> [AnyHashable: Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        return try execute(with: deleteRequest, in: context)
    }

    private static func execute(
        with deleteRequest: NSBatchDeleteRequest,
        in context: NSManagedObjectContext
    ) throws -> [AnyHashable: Any] {
        deleteRequest.resultType = .resultTypeObjectIDs
        let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
        return [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
    }
}
