//
//  DatabaseProtocol.swift
//  2019S1 Lab 3
//
//  Created by Julian A De La Roche on 25/8/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case temperatures
    case rgbs
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    //func onTemperatureChange(change: DatabaseChange, temperatures: [Temperature])
    //func onRGBChange(change: DatabaseChange, rgbs: [RGB])
}
protocol DatabaseProtocol: AnyObject {

}
