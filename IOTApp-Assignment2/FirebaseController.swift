//
//  FirebaseController.swift
//  2019S1 Lab 3
//
//  Created by Julian A De La Roche on 28/9/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirebaseController: NSObject, DatabaseProtocol {
      
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var tempRef: CollectionReference?
    var rgbRef: CollectionReference?
    var tempList: [Temperature]
    var rgbList: [RGB]
    
    var whetherRecRef: CollectionReference?
    var whetherRecList: [Whether_Recommendation]
    
    override init() {
        // To use Firebase in our application we first must run the FirebaseApp configure method
        FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        tempList = [Temperature]()
        rgbList = [RGB]()
        whetherRecList = [Whether_Recommendation]()
        
        super.init()
        
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its recieved a message back which can be any time later
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            // Once we have authenticated we can attach our listeners to the firebase firestore
            self.setUpListeners()
        }
    }
    
    func setUpListeners() {
        tempRef = database.collection("Temperature")
        tempRef?.order(by: "dateTime").limit(to:1)
        tempRef?.addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseTemperaturesSnapshot(snapshot: querySnapshot!)
        }
        
        rgbRef = database.collection("RGB")
        rgbRef?.order(by: "dateTime").limit(to:1)
        rgbRef?.addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseRGBSnapshot(snapshot: querySnapshot!)
        }
        
        whetherRecRef = database.collection("Whether_Recommendations")
        whetherRecRef?.addSnapshotListener { querySnapshot, error in
            guard (querySnapshot?.documents) != nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseWhetherRecSnapshot(snapshot: querySnapshot!)
        }
        
        
        
    }
    
    
    func parseTemperaturesSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { change in
        if (change.document.data()["date"] != nil) {
            let documentRef = change.document.documentID
            let date = change.document.data()["date"] as! String
            let tempDegrees = change.document.data()["tempDegrees"] as! Int
       
            print(documentRef, date, tempDegrees)
        
            if change.type == .added || change.type == .modified{
                print("New Temp: \(change.document.data())")
                let newTemp = Temperature()
                newTemp.id = documentRef
                newTemp.date = date
                newTemp.tempDegrees = tempDegrees
                tempList.append(newTemp)
                }
            }
            
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.temperatures || listener.listenerType == ListenerType.all {
                listener.onTemperatureChange(change: .update, temperatures: tempList)
            }
        }
    }
    
    func parseRGBSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { change in
            
            if (change.document.data()["date"] != nil) {
                let documentRef = change.document.documentID
                let date = change.document.data()["date"] as! String
                let red = change.document.data()["red"] as! Int
                let green = change.document.data()["green"] as! Int
                let blue = change.document.data()["blue"] as! Int
                print(documentRef)
         
                if change.type == .added || change.type == .modified {
                    print("New RGB: \(change.document.data())")
                    let newRGB = RGB()
                    newRGB.id = documentRef
                    newRGB.date = date
                    newRGB.red = red
                    newRGB.green = green
                    newRGB.blue = blue
                    rgbList.append(newRGB)
                }
                
            }
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.rgbs || listener.listenerType == ListenerType.all {
                listener.onRGBChange(change: .update, rgbs: rgbList)
            }
        }
        
    }
    
    func parseWhetherRecSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { change in
            
            if (change.document.data()["category"] != nil) {
                let documentRef = change.document.documentID
                let category = change.document.data()["category"] as! String
                let activity = change.document.data()["activity"] as! String
                let light_min = change.document.data()["light_min"] as! Int
                let light_max = change.document.data()["light_max"] as! Int
                let temperature_min = change.document.data()["temperature_min"] as! Int
                let temperature_max = change.document.data()["temperature_max"] as! Int
                print(documentRef)
         
                if change.type == .added {
                    print("New Whether Rec: \(change.document.data())")
                    let newWhetherRec = Whether_Recommendation()
                    newWhetherRec .id = documentRef
                    newWhetherRec.category = category
                    newWhetherRec.activity = activity
                    newWhetherRec.light_min = light_min
                    newWhetherRec.light_max = light_max
                    newWhetherRec.temperature_min = temperature_min
                    newWhetherRec.temperature_max = temperature_max
                    whetherRecList.append(newWhetherRec)
                }
                
            }
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.whetherRecs || listener.listenerType == ListenerType.all {
                listener.onWhetherRecChange(change: .update, whetherRecs: whetherRecList)
            }
        }
        
    }
    

    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == ListenerType.temperatures || listener.listenerType == ListenerType.all {
            listener.onTemperatureChange(change: .update, temperatures: tempList)
        }
        if listener.listenerType == ListenerType.rgbs || listener.listenerType == ListenerType.all {
            listener.onRGBChange(change: .update, rgbs: rgbList)
        }
        if listener.listenerType == ListenerType.whetherRecs || listener.listenerType == ListenerType.all {
            listener.onWhetherRecChange(change: .update, whetherRecs: whetherRecList)
        }
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

}
