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
    
    // GET
    
    func isFileDownloaded() -> Bool {
        return dm!.downloadFileExists()
    }
    
    // getShipList - return list of all ship names
    func getShipList() -> NSArray {
        return dm!.findShipList()
    }
    
    // getShipListNice - return a nice named list of all ships
    func getShipListNice() -> NSArray {
        var niceList : NSMutableArray = []
        var shipList = dm!.findShipList()
        for ship in shipList {
            var shipEntity = getShip(ship as NSString)
            var niceName = shipEntity.shipName
            niceList.addObject(niceName!)
        }
        return niceList
    }
    
    func getShip(id_ship : NSString) -> ShipEntity {
        return dm!.findShip(id_ship)
    }
    
    func getShipDDProperties(id_ship: NSString)->(NSURL, String) {
        var ddURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
        var a = ddURL!.URLByAppendingPathComponent("/Downloads/kush_cloakedfighter.scnassets/kush_cloakedfighter.dae")
        var sceneIdentifier : String = "Kus_CloakedFighter1"
        //var b : NSArray = sceneSource.identifiersOfEntriesWithClass(SCNNode.self)!
        return (a, sceneIdentifier)
    }
    
    func idForLastWallpaper() -> NSString  {
        var bgList: NSArray = dm!.getDefault("currentWall") as NSArray
        return bgList.objectAtIndex(0) as NSString
    }
    
    func getWallpaper(id : NSString) -> (UIImage, UIViewContentMode) {
        var bgList: NSArray = dm!.getDefault("currentWall") as NSArray
        NSLog("%@", bgList.objectAtIndex(0) as NSString)
        NSLog("%@", bgList.objectAtIndex(1) as NSString)
        var image : UIImage = UIImage(named: bgList.objectAtIndex(0) as NSString)!
        
        var contentMode : UIViewContentMode? = nil
        contentMode = bgList.objectAtIndex(1).isEqualToString("center") ? UIViewContentMode.Center : UIViewContentMode.Right
        
        return (image, contentMode!)
    }
    
    func getNextWallpaper(id: NSString)->NSString {
        var wallpapers = dm!.getWallPaperList()
        var index = wallpapers.indexOfObject(id)
        var nextIndex = (index + 1 == wallpapers.count) ? 0 : index + 1
        return wallpapers.objectAtIndex(nextIndex) as NSString
    }
    
    func idForLastShip() -> NSString {
        return dm!.getDefault("currentShip") as NSString
    }
    
    func shouldRotate() -> NSNumber {
        return dm!.getDefault("shouldRotate") as NSNumber
    }
        
    // SET
    
    func setWallpaper(id : NSString, contentMode: UIViewContentMode) {
        var mode = (contentMode == UIViewContentMode.Center) ? "center" : "right"
        dm!.saveDefault("currentWall", value: [id,mode] )
    }
    
    func setShip(id : NSString) {
        dm!.saveDefault("currentShip", value: id)
    }
    
    func setRotateSpeed(v : NSNumber) {
        dm!.saveDefault("shouldRotate", value: v)
    }
    
    func download() {
        dm!.download()
        dm!.load()
    }
}
