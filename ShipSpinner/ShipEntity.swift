//
//  ShipEntity.swift
//  ShipSpinner
//
//  Created by James Tan on 4/1/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit

class ShipEntity: NSObject {
    
    var shipName : NSString? = ""
    var shipClass : NSString? = ""
    var shipRole : NSString? = ""
    var shipDescription : NSString? = ""
    var shipAssetPath : NSString? = ""
    var shipEntryNode : NSString? = ""
    var shipLength : NSString? = ""
    var shipMass : NSString? = ""
    var shipSpeed : NSString? = ""
    
    func loadShipFromFile(d : (NSDictionary, NSDictionary), id_ship : NSString) {
        var assetDictionary = d.0 as NSDictionary
        var detailsDictionary = d.1 as NSDictionary
        
        Util.getDownloadPath().stringByAppendingPathComponent(assetDictionary.objectForKey(id_ship) as! String)

        shipAssetPath = (Util.downloadPathExists()) ?
            Util.getDownloadPath().stringByAppendingPathComponent(assetDictionary.objectForKey(id_ship) as! String)
            :
            assetDictionary.objectForKey(id_ship) as? NSString
        
        var shipArray = detailsDictionary.objectForKey(id_ship) as! NSArray
        shipName = shipArray.objectAtIndex(0) as? NSString
        shipClass = shipArray.objectAtIndex(1) as? NSString
        shipRole = shipArray.objectAtIndex(2) as? NSString
        shipDescription = shipArray.objectAtIndex(3) as? NSString
        shipEntryNode = shipArray.objectAtIndex(4) as? NSString
        shipLength = shipArray.objectAtIndex(5) as? NSString
        shipMass = shipArray.objectAtIndex(6) as? NSString
        shipSpeed = shipArray.objectAtIndex(7) as? NSString
        
    }
    
    func deconstruct() {
        shipName = nil
        shipClass = nil
        shipRole = nil
        shipDescription = nil
        shipAssetPath = nil
    }
}
