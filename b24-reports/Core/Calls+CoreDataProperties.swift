//
//  Calls+CoreDataProperties.swift
//  
//
//  Created by leomac on 12.04.2021.
//
//

import Foundation
import CoreData


extension Calls {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calls> {
        return NSFetchRequest<Calls>(entityName: "Calls")
    }

    @NSManaged public var callID: String
    @NSManaged public var date: Date
    @NSManaged public var managerID: String
    @NSManaged public var qtyIncomingCalls: Int32
    @NSManaged public var qtyOutgoingCalls: Int32
    @NSManaged public var timeOfIncoming: Double
    @NSManaged public var timeOfOutgoing: Double
    @NSManaged public var toManagers: Managers

}
