//
//  Temperature.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

//This class creates a new Temperature Object.
class Temperature: NSObject {

    var id: String
    var date: String
    var tempDegrees: Int
    
    override init(){
        self.id = ""
        self.date = ""
        self.tempDegrees = 0
    }
}
