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
        // Configure method to establish a connection with Firebase
        FirebaseApp.configure()
        // Calling the autController to access Firebase collections
        authController = Auth.auth()
        database = Firestore.firestore()
        tempList = [Temperature]() // List of temperatures
        rgbList = [RGB]() // List of RGB
        whetherRecList = [Whether_Recommendation]() // List of whether recommendations or activities.
        
        super.init()
        
        // This will START THE PROCESS of signing in with an anonymous account
        // The closure will not execute until its recieved a message back which can be any time later
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            // Attaching the listeners to the firebase firestore
            self.setUpListeners()
        }
    }
    
    //This method setting up the listeners of Temperature, RGB and Whether_Recommendation
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
    
    //This method add all the temperatures from Firebase to a list called tempList
    func parseTemperaturesSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { change in
        if (change.document.data()["date"] != nil) {
            let documentRef = change.document.documentID
            let date = change.document.data()["date"] as! String
            let tempDegrees = change.document.data()["tempDegrees"] as! Int
            if change.type == .added {
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
    
    //This method add all the RGB from Firebase to a list called rgbList
    func parseRGBSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { change in
            
            if (change.document.data()["date"] != nil) {
                let documentRef = change.document.documentID
                let date = change.document.data()["date"] as! String
                let red = change.document.data()["red"] as! Int
                let green = change.document.data()["green"] as! Int
                let blue = change.document.data()["blue"] as! Int
                //print(documentRef)
         
                if change.type == .added || change.type == .modified {
                    //print("New RGB: \(change.document.data())")
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
    
    //This method add, update and removes all the Whether_Recommendations or activities from Firebase to a list called whetherRecList
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
                let user = change.document.data()["user"] as! String
         
                if change.type == .added {
                    let newWhetherRec = Whether_Recommendation()
                    newWhetherRec.id = documentRef
                    newWhetherRec.category = category
                    newWhetherRec.activity = activity
                    newWhetherRec.light_min = light_min
                    newWhetherRec.light_max = light_max
                    newWhetherRec.temperature_min = temperature_min
                    newWhetherRec.temperature_max = temperature_max
                    newWhetherRec.user = user
                    whetherRecList.append(newWhetherRec)
                }
                
                if change.type == .modified {

                    let index = getActivityIndexByID(reference: documentRef)!
                    whetherRecList[index].category = category
                    whetherRecList[index].activity = activity
                    whetherRecList[index].light_min = light_min
                    whetherRecList[index].light_max = light_max
                    whetherRecList[index].temperature_min = temperature_min
                    whetherRecList[index].temperature_max = temperature_max
                }
                if change.type == .removed {
                    if let index = getActivityIndexByID(reference: documentRef) {
                        whetherRecList.remove(at: index)
                    }
                }
                
            }
        }
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.whetherRecs || listener.listenerType == ListenerType.all {
                listener.onWhetherRecChange(change: .update, whetherRecs: whetherRecList)
            }
        }
        
    }
    
    //This method add all the listeners which control any updates into the three different collections.
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
    
    //This method allows to add a personalised whether_recommendation or activity into Firebase.
    func addPersonalisedActivity(whether_recommentation: Whether_Recommendation) -> Whether_Recommendation {
        let id = whetherRecRef?.addDocument(data: ["category" : whether_recommentation.category, "activity" : whether_recommentation.activity, "light_min" : whether_recommentation.light_min, "light_max" : whether_recommentation.light_max, "temperature_min" : whether_recommentation.temperature_min, "temperature_max" : whether_recommentation.temperature_max, "user" : whether_recommentation.user])
        whether_recommentation.id = id!.documentID
        return whether_recommentation
    }
    
    //This method allows to get Index of the references to be updated or deleted.
    func getActivityIndexByID(reference: String) -> Int? {
        for activity in whetherRecList {
            if(activity.id == reference) {
                return whetherRecList.firstIndex(of: activity)
            }
        }
        return nil
    }

    //This method allows to remove the delegates in those classes when the listeners are calling.
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    //This method allows to remove a personalised whether_recommendation or activity from Firebase
    func deleteActitivy(whether_recommentation: Whether_Recommendation) {
        whetherRecRef?.document(whether_recommentation.id).delete()
    }
    
    //This method allows to update a personalised whether_recommendation or activity from Firebase
    func updateActivity(whether_recommentation: Whether_Recommendation) {
        whetherRecRef?.document(whether_recommentation.id).updateData(["category" : whether_recommentation.category, "activity" : whether_recommentation.activity, "light_min" : whether_recommentation.light_min, "light_max" : whether_recommentation.light_max, "temperature_min" : whether_recommentation.temperature_min, "temperature_max" : whether_recommentation.temperature_max])
    }
}
