//
//  UserDefaultController.swift
//  Assginment2.swift4.firebase
//
//  Created by Nikhil Gholap on 30/9/19.
//  Copyright © 2019 Nikhil Gholap. All rights reserved.
//

import UIKit

//implements the UserDefaultsProtocol
class UserDefaultController: NSObject, UserDefaultsProtocol {
    
       //variable for storing the user defaults
    let defaults = UserDefaults.standard
    
    //generates the random string of the length that is passed to it
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override init() {
        super.init()
        //if the userId is not generated so far it'll call the method that'll generate it
        if retrieveUserId().isEmpty {
            generateUniqueUserId()
        }
    }
    
    //gererates the random unique string that'll be used as a userId
    func generateUniqueUserId() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yy-MM-dd-HH:mm:ss"
        let formattedDate = format.string(from: date)
        let random = randomString(length: 20)
        defaults.set((formattedDate+random), forKey: "userUniqueIdKey")
    }
    
    //Assigns the userNameKey value for user's name
    func assignName(name: String) {
        defaults.set(name, forKey: "userNameKey")
    }
    
     //Strores the gender of the user
    func assignGender(gender: String) {
        defaults.set(gender, forKey: "userGenderKey")
    }
    
    //Stores the weight of user
    func assignWeight(weight: Int) {
        defaults.set(weight, forKey: "userWeightKey")
    }
    
    // Stores the age of user
    func assignAge(age: Int) {
        defaults.set(age, forKey: "userAgeKey")
    }
    
    //returns the userId from userDefaults
    func retrieveUserId() -> String {
        var id: String = ""
        if let tempId = defaults.string(forKey: "userUniqueIdKey") {
            id = tempId
        }
        return id
    }
    
    //returns the user name from userDefaults
    func retrieveName() -> String {
        var name: String = ""
        if let tempName = defaults.string(forKey: "userNameKey") {
            
            name = tempName
        }
        return name
    }
    
    //returns the gender of the user
    func retrieveGender() -> String {
        var gender: String = ""
        if let tempgender = defaults.string(forKey: "userGenderKey") {
            print(gender)
            gender = tempgender
        }
        return gender
    }
    
    //returns the weight of the user
    func retrieveWeight() -> Int {
        return defaults.integer(forKey: "userWeightKey")
        
    }
    
    //returns the age of the user from userDefaults
    func retrieveAge() -> Int {
        return defaults.integer(forKey: "userAgeKey")
        
    }
}
