//
//  FIRFirestoreSevice.swift
//  b24-reports
//
//  Created by leomac on 13.04.2021.
//

import Foundation
import Firebase

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    let db = Firestore.firestore()
    
    func addUpdateDocument(collection: String, idDocement: String, data: [String:Any]) {
        
        db.collection(collection).document(idDocement).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err.localizedDescription)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteCollection(typeCollection: String, docID: String) {
        
        db.collection("task").document(docID).delete() { err in
            if let err = err {
                print("Error removing document: \(err.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    //func loadDocuments(_ collectionPath:String) -> [[String:Any]] {
    //
    //    var collection = [[String:Any]]()
    //
    //    db.collection(collectionPath).getDocuments() { (querySnapshot, err) in
    //        if let err = err {
    //            print("Error getting documents: \(err)")
    //        } else {
    //            for document in querySnapshot!.documents {
    //                //print("\(document.documentID) => \(document.data())")
    //                collection.append(document.data())
    //            }
    //        }
    //    }
    //    return collection
    //}
}
