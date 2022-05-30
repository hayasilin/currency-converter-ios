//
//  ManagedCurrencyLiveInfo+Fetch.swift
//  Currency
//
//  Created by kuanwei on 2022/5/30.
//

import Foundation
import CoreData

extension ManagedCurrencyLiveInfo {
    public static let entityName = "ManagedCurrencyLiveInfo"

    public static func count(
        in context: NSManagedObjectContext
    ) throws -> Int {
        try context.count(for: ManagedCurrencyLiveInfo.fetchRequest())
    }

    public static func fetch(
        in context: NSManagedObjectContext
    ) throws -> [ManagedCurrencyLiveInfo] {
        try context.fetch(ManagedCurrencyLiveInfo.fetchRequest())
    }

    public static func fetch(
        source: String,
        in context: NSManagedObjectContext
    ) throws -> ManagedCurrencyLiveInfo? {
        let fetchRequest = ManagedCurrencyLiveInfo.fetchRequest()
        fetchRequest.predicate = predicate(source: source)
        fetchRequest.fetchLimit = 1
        return try context.fetch(fetchRequest).first
    }

    public static func save(
        transformedCurrencyInfos: [[String: Any]],
        in context: NSManagedObjectContext
    ) throws -> [AnyHashable: Any] {
        let insertRequest = NSBatchInsertRequest(
            entity: ManagedCurrencyLiveInfo.entity(),
            objects: transformedCurrencyInfos
        )
        insertRequest.resultType = .objectIDs
        let result = try context.execute(insertRequest) as? NSBatchInsertResult
        return [NSInsertedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
    }

    public static func delete(
        source: String,
        in context: NSManagedObjectContext
    ) throws -> [AnyHashable: Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate(source: source)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        return try execute(with: deleteRequest, in: context)
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

// MARK: - Predicate for fetch

extension ManagedCurrencyLiveInfo {
    static func predicate(source: String) -> NSPredicate {
        NSPredicate(
            format: "%K == %@",
            #keyPath(ManagedCurrencyLiveInfo.source),
            source
        )
    }
}


