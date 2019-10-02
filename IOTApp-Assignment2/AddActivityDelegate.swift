//
//  AddActivityDelegate.swift
//  IOTApp-Assignment2
//
//  Created by Julian A De La Roche on 2/10/19.
//  Copyright © 2019 Julian A De La Roche. All rights reserved.
//

import Foundation
protocol AddActivityDelegate: AnyObject {
    func addActivityToList(newActivity: Whether_Recommendation) -> Bool
}
