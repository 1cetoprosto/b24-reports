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
    var manager: Manager {
        let managers = Managers().getRecords(at: managerID)[0]
        let manager = Manager(at: managers)
        return manager
    }
    
    
    init(at calls: Calls) {
        self.callID = calls.callID
        self.date = calls.date
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

var filteredCallItems = [Call]()


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


