//
//  Managers+CoreDataClass.swift
//  
//
//  Created by leomac on 12.04.2021.
//
//

import Foundation
import CoreData
import UIKit

@objc(Managers)
public class Managers: NSManagedObject {

    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveContex(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func addRecords(manager: Manager) {
        //let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Managers", in: context) else {return}
        //let taskObject = (NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context) as! Tasks)
        let managersObject = Managers(entity: entity, insertInto: context)
        
        managersObject.firstName = manager.firstName
        managersObject.lastName  = manager.lastName
        managersObject.managerID = manager.managerID
        
        saveContex(context: context)
        
    }
    
    
    func getRecords() -> [Managers] {
        
        //let context = getContext()
        
        let fetchRequest: NSFetchRequest<Managers> = Managers.fetchRequest()
        
        do {
            let array = try context.fetch(fetchRequest)
            return array
        } catch let error as NSError  {
            print("Could not read \(error), \(error.userInfo)")
        }
        return[]
    }
    
    
    func getRecords(at ID: String? = nil) -> [Managers] {
        //let context = getContext()
        
        let fetchRequest: NSFetchRequest<Managers> = Managers.fetchRequest()
        if let managerId = ID {
            fetchRequest.predicate = NSPredicate(format: "managerID==%@", managerId as CVarArg)
        }
//        if !(ID == nil) {
//            fetchRequest.predicate = NSPredicate(format: "taskID==%d", ID as CVarArg)
//        }
        
        do {
            let array = try context.fetch(fetchRequest)
            return array
        } catch let error as NSError  {
            print("Could not read \(error), \(error.userInfo)")
        }
        return[]
    }
    
    func deleteRecords(manager: Manager) {
        //let context = getContext()
        
        let objects =  getRecords(at: manager.managerID)
        for object in objects {
            context.delete(object)
        }
        
        saveContex(context: context)
    }
    
    /*
    func updateRecords(call: Call) {
        //let context = getContext()
        
        let objects =  getRecords(at: call.callID)
        for object in objects {
            object.date = call.date
            object.manager = call.manager
            object.qtyIncomingCalls = call.qtyIncomingCalls
            object.qtyOutgoingCalls = call.qtyOutgoingCalls
            object.timeOfIncoming = call.timeOfIncoming
            object.timeOfOutgoing = call.timeOfOutgoing
            object.callId = call.callId
        }
        
        saveContex(context: context)
    }
    */
    
    func deleteAllRecords() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Managers.fetchRequest()
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do { try context.execute(DelAllReqVar)
            saveContex(context: context)
        }
        catch { print(error) }
    }
}
