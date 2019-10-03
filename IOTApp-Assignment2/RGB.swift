//
//  RGB.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

//This class creates RGB objects
class RGB: NSObject {
    var id: String
    var date: String
    var red: Int
    var green: Int
    var blue: Int
    
    override init(){
        self.id = ""
        self.date = ""
        self.red = 0
        self.green = 0
        self.blue = 0
    }
}
