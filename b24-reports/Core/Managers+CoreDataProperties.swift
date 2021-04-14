//
//  Managers+CoreDataProperties.swift
//  
//
//  Created by leomac on 12.04.2021.
//
//

import Foundation
import CoreData


extension Managers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Managers> {
        return NSFetchRequest<Managers>(entityName: "Managers")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var managerID: String
    @NSManaged public var toCalls: NSSet?

}

// MARK: Generated accessors for toCalls
extension Managers {

    @objc(addToCallsObject:)
    @NSManaged public func addToToCalls(_ value: Calls)

    @objc(removeToCallsObject:)
    @NSManaged public func removeFromToCalls(_ value: Calls)

    @objc(addToCalls:)
    @NSManaged public func addToToCalls(_ values: NSSet)

    @objc(removeToCalls:)
    @NSManaged public func removeFromToCalls(_ values: NSSet)

}
