//
//  Model.swift
//  b24-reports
//
//  Created by leomac on 11.04.2021.
//

import Foundation
import FirebaseFirestore

struct Manager {
    var firstName: String
    var lastName: String
    var managerID: String
    
    init(at managers: Managers) {
        self.firstName = managers.firstName ?? ""
        self.lastName = managers.lastName ?? ""
        self.managerID = managers.managerID
    }
    
    init?(dictionary: [String:Any]) {
        guard let managerID = dictionary["managerID"] as? String,
              let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String
        else { return nil }
        self.managerID = managerID
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct Call {
    var callID: String
    var date: Date
    var dateFormated: String
    var managerID: String
    var qtyIncomingCalls: Int
    var qtyOutgoingCalls: Int
    var timeOfIncoming: Double
    var timeOfOutgoing: Double
    
    var dictionary: [String:Any] {
        return [
            "callID": callID,
            "date": date,
            "managerID": managerID,
            "qtyIncomingCalls": qtyIncomingCalls,
            "qtyOutgoingCalls": qtyOutgoingCalls,
            "timeOfIncoming": timeOfIncoming,
            "timeOfOutgoing": timeOfOutgoing,
        ]
    }
    var manager: Manager? {
        let arrayManagers = Managers().getRecords(at: managerID)
        if arrayManagers.count > 0 {
            let managers = arrayManagers[0]
            let manager = Manager(at: managers)
            return manager
        } else {
            return nil
        }
    }
    
    
    init(at calls: Calls) {
        self.callID = calls.callID
        self.date = calls.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        let dateFormated = formatter.string(from: calls.date)//.date(from: calls.date.description)
        
        self.dateFormated = dateFormated
        
        self.managerID = calls.managerID
        self.qtyIncomingCalls = Int(calls.qtyIncomingCalls)
        self.qtyOutgoingCalls = Int(calls.qtyOutgoingCalls)
        self.timeOfIncoming = calls.timeOfIncoming
        self.timeOfOutgoing = calls.timeOfOutgoing
    }
    
    
    init?(dictionary: [String:Any]) {
        guard let callID = dictionary["callID"] as? String,
              let date = dictionary["date"] as? Timestamp,
              let managerID = dictionary["managerID"] as? String,
              let qtyIncomingCalls = dictionary["qtyIncomingCalls"] as? Int,
              let qtyOutgoingCalls = dictionary["qtyOutgoingCalls"] as? Int,
              let timeOfIncoming = dictionary["timeOfIncoming"] as? Double,
              let timeOfOutgoing = dictionary["timeOfOutgoing"] as? Double
        else { return nil }
        self.callID = callID
        self.date = date.dateValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        let dateFormated = formatter.string(from: date.dateValue())
        
        self.dateFormated = dateFormated
        
        self.managerID = managerID
        self.qtyIncomingCalls = qtyIncomingCalls
        self.qtyOutgoingCalls = qtyOutgoingCalls
        self.timeOfIncoming = timeOfIncoming
        self.timeOfOutgoing = timeOfOutgoing
    }
}

var callItems: [Call] {
    
    let array = Calls.init().getRecords()
    
    var callArray = [Call]()
    
    for calls in array {
        let call = Call(at: calls)
        callArray.append(call)
    }
    return callArray
}

var events: [[Call]] = []

/*
var events: [[Call]] {
    
    var firstMount: Int!
    var tmpItems: [Call]!
    var tmpEvents: [[Call]]
    
    tmpEvents = callItems.map { item in
    
        let month = NSCalendar.current.dateComponents([.month], from: item.date).month
    
        if firstMount == nil || firstMount != month {
            firstMount = month
            tmpItems = [item]
        } else {
            tmpItems.append(item)
        }
        return tmpItems
    }
    return tmpEvents
}
*/

let sections = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]

var item: Call!

var filteredCallItems = [Call]()

func sortCall(items: [Call]) {
    
    let sortedItems = items
        .sorted { $0.date < $1.date }
    //.map {$0.dateFormated}
    //print(newArray)
    
    var firstMount: Int!
    var tmpItems: [Call] = []
    
    for item in sortedItems {
        let month = NSCalendar.current.dateComponents([.month], from: item.date).month
        if firstMount == nil || firstMount != month {
            if tmpItems.count > 0 {
                events.append(tmpItems)
            }
            firstMount = month
            tmpItems = [item]
        } else {
            tmpItems.append(item)
        }
    }
    if tmpItems.count > 0 {
        events.append(tmpItems)
    }
}

func loadManagersFromCloud() {
    
    let managers = Managers()
    
    // erase CoreData
    managers.deleteAllRecords()
    
    // writing call to CoreData
    FIRFirestoreService.shared.db.collection("managers").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                if let manager = Manager(dictionary: document.data()) {
                    managers.addRecords(manager: manager)
                }
            }
        }
    }
}

func loadCallsFromCloud() {
    
    let calls = Calls()
    
    // erase CoreData
    calls.deleteAllRecords()
    
    // writing call to CoreData
    FIRFirestoreService.shared.db.collection("calls").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                if let call = Call(dictionary: document.data()) {
                    calls.addRecords(call: call)
                } 
            }
        }
    }
}

/*
 func addItems(task: Task) {
 // writing to CoreData
 let tasks = Tasks()
 tasks.addRecords(task: task)
 
 // writing to Firebase
 FIRFirestoreService.shared.addUpdateDocument(collection: "task", idDocement: task.taskID, data: task.dictionary)
 }
 
 func deleteItem(at Index: Int) {
 
 // delete in CoreData
 Tasks.init().deleteRecords(task: toDoItems[Index])
 
 // delete in Firebase
 FIRFirestoreService.shared.deleteDocument(task: toDoItems[Index])
 }
 
 func updateItems(task: Task) {
 // writing to CoreData
 let tasks = Tasks()
 tasks.updateRecords(task: task)
 
 // writing to Firebase
 FIRFirestoreService.shared.addUpdateDocument(collection: "task", idDocement: task.taskID, data: task.dictionary)
 }
 */

