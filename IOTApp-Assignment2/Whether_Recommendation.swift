//
//  Whether_Recommendation.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 29/9/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import UIKit

class Whether_Recommendation: NSObject {
    var id: String
    var category: String
    var activity: String
    var light_min: Int
    var light_max: Int
    var temperature_min: Int
    var temperature_max: Int
    var user: String
    
    override init(){
        self.id = ""
        self.category = ""
        self.activity = ""
        self.light_max = 0
        self.light_min = 0
        self.temperature_min = 0
        self.temperature_max = 0
        self.user=""
    }
}
