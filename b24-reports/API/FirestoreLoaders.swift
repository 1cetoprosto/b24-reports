//
//  FirestoreLoaders.swift
//  b24-reports
//
//  Created by leomac on 04.05.2021.
//

import Foundation
import FirebaseFirestore

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
