//
//  ManagedCurrencyList+CoreDataProperties.swift
//  Currency
//
//  Created by kuanwei on 2022/5/25.
//
//

import Foundation
import CoreData

extension ManagedCurrencyList {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCurrencyList> {
        return NSFetchRequest<ManagedCurrencyList>(entityName: "ManagedCurrencyList")
    }

    @NSManaged public var currencies: [String: String]?
}

extension ManagedCurrencyList : Identifiable {}
