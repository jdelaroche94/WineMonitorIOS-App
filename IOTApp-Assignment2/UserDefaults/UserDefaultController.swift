//
//  UserDefaultController.swift
//  Assginment2.swift4.firebase
//
//  Created by Nikhil Gholap on 30/9/19.
//  Copyright © 2019 Nikhil Gholap. All rights reserved.
//

import UIKit

class UserDefaultController: NSObject, UserDefaultsProtocol {
    
    let defaults = UserDefaults.standard
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override init() {
        super.init()
        if retrieveUserId().isEmpty {
            generateUniqueUserId()
        }
    }
    
    func generateUniqueUserId() {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yy-MM-dd-HH:mm:ss"
        let formattedDate = format.string(from: date)
        let random = randomString(length: 20)
        defaults.set((formattedDate+random), forKey: "userUniqueIdKey")
    }
    
    func assignName(name: String) {
        defaults.set(name, forKey: "userNameKey")
    }
    
    func assignGender(gender: String) {
        defaults.set(gender, forKey: "userGenderKey")
    }
    
    func assignWeight(weight: Int) {
        defaults.set(weight, forKey: "userWeightKey")
    }
    
    func assignAge(age: Int) {
        defaults.set(age, forKey: "userAgeKey")
    }
    
    func retrieveUserId() -> String {
        var id: String = ""
        if let tempId = defaults.string(forKey: "userUniqueIdKey") {
            id = tempId
        }
        return id
    }
    
    func retrieveName() -> String {
        var name: String = ""
        if let tempName = defaults.string(forKey: "userNameKey") {
            
            name = tempName
        }
        return name
    }
    
    func retrieveGender() -> String {
        var gender: String = ""
        if let tempgender = defaults.string(forKey: "userGenderKey") {
            print(gender)
            gender = tempgender
        }
        return gender
    }
    
    func retrieveWeight() -> Int {
        return defaults.integer(forKey: "userWeightKey")
        
    }
    
    func retrieveAge() -> Int {
        return defaults.integer(forKey: "userAgeKey")
        
    }
}
