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
        if !arrayManagers.isEmpty {
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
    
    init(dateFormated: String, managerID: String, qtyIncomingCalls: Int, qtyOutgoingCalls: Int, timeOfIncoming: Double, timeOfOutgoing: Double) {
        self.callID = ""
        self.date = Date()
        self.dateFormated = dateFormated
        self.managerID = managerID
        self.qtyIncomingCalls = qtyIncomingCalls
        self.qtyOutgoingCalls = qtyOutgoingCalls
        self.timeOfIncoming = timeOfIncoming
        self.timeOfOutgoing = timeOfOutgoing
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

enum Periods {
    case day
    case week
    case month
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

var groupedCalls: [[Call]] = [[Call]]()
//var filteredCallItems = [Call]()


func groupedPeriod(at date: Date, period: Periods) -> String {
    let formatter = DateFormatter()
    var groupedPeriod: String = ""
    
    switch (period) {
    case .day:
        formatter.dateFormat = "d MMMM YYYY"
        groupedPeriod = formatter.string(from: date)
    case .week:
        formatter.dateFormat = "d MMMM YYYY"
        groupedPeriod = "\(formatter.string(from: date.startOfWeek)) - \(formatter.string(from: date.endOfWeek))"
    case .month:
        formatter.dateFormat = "MMMM YYYY"
        groupedPeriod = formatter.string(from: date)
    }
    
    return groupedPeriod
}

fileprivate func collapsCalls(at period: Periods) -> [[Call]] {
    //collaps calls by managerID
    var newCalls = [[Call]]()
    var dateFormated: String = ""
    
    for periodOfCall in groupedCalls {
        
        var sortedList = [Call]()
        var qtyIncomingCalls: Int = 0
        var qtyOutgoingCalls: Int = 0
        var timeOfIncoming: Double = 0
        var timeOfOutgoing: Double = 0
        var firstCall: String!
        
        let periodOfCall = periodOfCall.sorted { $0.managerID < $1.managerID }
        for i in periodOfCall {
            
            dateFormated = groupedPeriod(at: i.date, period: period)
            
            if firstCall == nil {
                firstCall = i.managerID
                qtyIncomingCalls = i.qtyIncomingCalls
                qtyOutgoingCalls = i.qtyOutgoingCalls
                timeOfIncoming = i.timeOfIncoming
                timeOfOutgoing = i.timeOfOutgoing
            } else {
                if firstCall != i.managerID {
                    sortedList.append(Call(dateFormated: dateFormated, managerID: firstCall, qtyIncomingCalls: qtyIncomingCalls, qtyOutgoingCalls: qtyOutgoingCalls, timeOfIncoming: timeOfIncoming, timeOfOutgoing: timeOfOutgoing))
                    firstCall = i.managerID
                    qtyIncomingCalls = i.qtyIncomingCalls
                    qtyOutgoingCalls = i.qtyOutgoingCalls
                    timeOfIncoming = i.timeOfIncoming
                    timeOfOutgoing = i.timeOfOutgoing
                } else {
                    // summing values
                    qtyIncomingCalls += i.qtyIncomingCalls
                    qtyOutgoingCalls += i.qtyOutgoingCalls
                    timeOfIncoming += i.timeOfIncoming
                    timeOfOutgoing += i.timeOfOutgoing
                }
            }
        }
        sortedList.append(Call(dateFormated: dateFormated, managerID: firstCall, qtyIncomingCalls: qtyIncomingCalls, qtyOutgoingCalls: qtyOutgoingCalls, timeOfIncoming: timeOfIncoming, timeOfOutgoing: timeOfOutgoing))
        newCalls.append(sortedList)
        //sortedList.removeAll()
        
        //        let sortedCalls = periodOfCall
        //            .sorted { $0.qtyIncomingCalls < $1.qtyIncomingCalls }
    }
    return newCalls
}

func groupCall(items: [Call], at period: Periods) {
    
    if !items.isEmpty {
        groupedCalls.removeAll()
    }
    
    let sortedItems = items
        .sorted { $0.date < $1.date }
    //.map {$0.dateFormated}
    
    var firstItem: Int!
    var tmpItems: [Call] = []
    var groupingPeriod: Int?
    
    for item in sortedItems {
        switch period {
        case .day:
            groupingPeriod = NSCalendar.current.dateComponents([.day], from: item.date).day
        case .week:
            groupingPeriod = NSCalendar.current.dateComponents([.weekOfYear], from: item.date).weekOfYear
        case .month:
            groupingPeriod = NSCalendar.current.dateComponents([.month], from: item.date).month
        }
        
        if firstItem == nil || firstItem != groupingPeriod {
            if !tmpItems.isEmpty {
                groupedCalls.append(tmpItems)
            }
            firstItem = groupingPeriod
            tmpItems = [item]
        } else {
            tmpItems.append(item)
        }
    }
    if !tmpItems.isEmpty {
        groupedCalls.append(tmpItems)
    }
    
    groupedCalls = collapsCalls(at: period)
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

