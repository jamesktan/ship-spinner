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
    var shipDescription : NSString? = ""
    var shipRace : NSString? = ""
    var shipAssetPath : NSString? = ""
    
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
        shipDescription = shipArray.objectAtIndex(1) as? NSString
        shipRace = shipArray.objectAtIndex(2) as? NSString

    }
    
    func deconstruct() {
        shipDescription = nil
        shipAssetPath = nil
        shipRace = nil
    }
}
