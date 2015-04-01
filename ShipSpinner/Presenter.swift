//
//  SSPresenter.swift
//  ShipSpinner
//
//  Created by James Tan on 4/1/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit

class Presenter: NSObject {
    
    var view : ViewController? = nil
    var interactor : Interactor? = nil
    
    func getShip(name_ship : NSString) -> (NSString, NSString, NSString, NSString, NSString) {
        var ship = interactor!.getShip(name_ship)
        return (ship.shipName!, ship.shipClass!, ship.shipRole!, ship.shipDescription!, ship.shipAssetPath!)
    }
    
    func getHello() {
        NSLog("HELLO")
    }
}
