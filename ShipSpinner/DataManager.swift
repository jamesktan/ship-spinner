//
//  DataManager.swift
//  ShipSpinner
//
//  Created by James Tan on 4/1/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    var interactor : Interactor? = nil
    
    var assetFile : NSString = "asset.plist"
    var detailFile : NSString = "detail.plit"
    
    var assetDictionary : NSDictionary = NSDictionary()
    var detailsDictionary : NSDictionary = NSDictionary()
    
    func load() {
        assetDictionary = NSDictionary(objectsAndKeys:assetFile)
        detailsDictionary = NSDictionary(objectsAndKeys:detailFile)
    }
    
    func findShip(id_ship : NSString) -> ShipEntity {
        var ship = ShipEntity()
        ship.loadShipFromFile((assetDictionary, detailsDictionary), id_ship: id_ship)
        return ship
    }
    
    func findShipList() -> NSArray {
        return ["Kushan Cloaked Fighter"]
    }
}
