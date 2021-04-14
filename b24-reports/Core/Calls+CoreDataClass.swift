//
//  Calls+CoreDataClass.swift
//  
//
//  Created by leomac on 12.04.2021.
//
//

import Foundation
import CoreData
import UIKit

@objc(Calls)
public class Calls: NSManagedObject {

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
    
    func addRecords(call: Call) {
        //let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Calls", in: context) else {return}
        //let taskObject = (NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context) as! Tasks)
        let callsObject = Calls(entity: entity, insertInto: context)
        
       callsObject.date             = call.date
       callsObject.managerID        = call.managerID
       callsObject.qtyIncomingCalls = Int32(call.qtyIncomingCalls)
       callsObject.qtyOutgoingCalls = Int32(call.qtyOutgoingCalls)
       callsObject.timeOfIncoming   = call.timeOfIncoming
       callsObject.timeOfOutgoing   = call.timeOfOutgoing
       //callsObject.taskID              = call.callId
        
        saveContex(context: context)
        
    }
    
    
    func getRecords() -> [Calls] {
        
        //let context = getContext()
        
        let fetchRequest: NSFetchRequest<Calls> = Calls.fetchRequest()
        
        do {
            let array = try context.fetch(fetchRequest)
            return array
        } catch let error as NSError  {
            print("Could not read \(error), \(error.userInfo)")
        }
        return[]
    }
    
    
    func getRecords(at ID: String? = nil) -> [Calls] {
        //let context = getContext()
        
        let fetchRequest: NSFetchRequest<Calls> = Calls.fetchRequest()
        if let callId = ID {
            fetchRequest.predicate = NSPredicate(format: "callID==%@", callId as CVarArg)
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
    
    func deleteRecords(call: Call) {
        //let context = getContext()
        
        let objects =  getRecords(at: call.callID)
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
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Calls.fetchRequest()
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do { try context.execute(DelAllReqVar)
            saveContex(context: context)
        }
        catch { print(error) }
    }
    
}
