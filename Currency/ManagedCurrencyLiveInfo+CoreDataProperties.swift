//
//  ManagedCurrencyLiveInfo+CoreDataProperties.swift
//  Currency
//
//  Created by kuanwei on 2022/5/30.
//
//

import Foundation
import CoreData

extension ManagedCurrencyLiveInfo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedCurrencyLiveInfo> {
        return NSFetchRequest<ManagedCurrencyLiveInfo>(entityName: "ManagedCurrencyLiveInfo")
    }

    @NSManaged public var quotes: [String: Double]?
    @NSManaged public var source: String?
    @NSManaged public var time: Date?
}

extension ManagedCurrencyLiveInfo : Identifiable {

}
