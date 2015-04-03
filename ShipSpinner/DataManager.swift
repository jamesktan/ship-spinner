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
    var detailFile : NSString = "detail.plist"
    var defaultsFile : NSString = "defaults.plist"
    
    var assetDictionary : NSDictionary = NSDictionary()
    var detailsDictionary : NSDictionary = NSDictionary()
    var defaultDictionary : NSDictionary = NSDictionary()
    
    func load() {
        assetDictionary = NSDictionary(objectsAndKeys:assetFile)
        detailsDictionary = NSDictionary(objectsAndKeys:detailFile)
        defaultDictionary = NSDictionary(objectsAndKeys:defaultsFile)
    }
    
    func findShip(id_ship : NSString) -> ShipEntity {
        var ship = ShipEntity()
        ship.loadShipFromFile((assetDictionary, detailsDictionary), id_ship: id_ship)
        return ship
    }
    
    func findShipList() -> NSArray {
        return ["kushan_fighter.scnae"]
    }
    
    func getDefault(key : NSString) -> AnyObject? {
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(key) == nil { //if - No Defaults Saved
            defaults.setValue(defaultDictionary.objectForKey(key), forKey: key)
            defaults.synchronize()
        } 
        return defaults.objectForKey(key)
    }
    
    func saveDefault(key : NSString, value: AnyObject?) {
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    func download() {
    
    }
}
