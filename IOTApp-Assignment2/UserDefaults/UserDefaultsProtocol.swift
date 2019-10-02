//
//  UserDefaultsProtocol.swift
//  Assginment2.swift4.firebase
//
//  Created by Nikhil Gholap on 30/9/19.
//  Copyright © 2019 Nikhil Gholap. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol: AnyObject {
    func assignName(name: String)
    func assignGender(gender: String)
    func assignWeight(weight: Int)
    func assignAge(age: Int)
    func retrieveName() -> String
    func retrieveGender() -> String
    func retrieveWeight() -> Int
    func retrieveUserId() -> String
    func retrieveAge() -> Int
    
}
