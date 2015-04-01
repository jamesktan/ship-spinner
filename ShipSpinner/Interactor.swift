//
//  SSInteractior.swift
//  ShipSpinner
//
//  Created by James Tan on 4/1/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit

class Interactor: NSObject {
    
    var presenter : Presenter? = nil
    var dm : DataManager? = nil
    
    func getShipList() -> NSArray {
        return dm!.findShipList()
    }
    
    func getShip(id_ship : NSString) -> ShipEntity {
        return dm!.findShip(id_ship)
    }
 
    func getHello() {
        NSLog("Hello!!!")
        dm?.getHello()
    }
}
