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
    
    var assetFile : NSString = "asset" //default
    var detailFile : NSString = "detail" //default
    var defaultsFile : NSString = "defaults" //default vals
    
    var assetDictionary : NSDictionary = NSDictionary() //load locally first, then load from file
    var detailsDictionary : NSDictionary = NSDictionary() //load locally first, then load from file
    var defaultDictionary : NSDictionary = NSDictionary() //load locally
    
    func load() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let pathDownloads = paths.stringByAppendingPathComponent("Downloads") as NSString

        defaultDictionary = NSDictionary(contentsOfFile: getPath(defaultsFile))!

        if NSFileManager.defaultManager().fileExistsAtPath(pathDownloads) {
            // download file exists
            var assetDownload = pathDownloads.stringByAppendingPathComponent(assetFile)
            var detailsDownload = pathDownloads.stringByAppendingPathComponent(detailFile)
            assetDictionary = NSDictionary(contentsOfFile: assetDownload)!
            detailsDictionary = NSDictionary(contentsOfFile: detailsDownload)!
        } else {
            // no downloads exist, use the bundled local ones
            assetDictionary = NSDictionary(contentsOfFile: getPath(assetFile))!
            detailsDictionary = NSDictionary(contentsOfFile: getPath(detailFile))!
        }
    }
    
    func findShip(id_ship : NSString) -> ShipEntity {
        var ship = ShipEntity()
        ship.loadShipFromFile((assetDictionary, detailsDictionary), id_ship: id_ship)
        return ship
    }
    
    func findShipList() -> NSArray {
        return assetDictionary.allKeys
    }
    
    func getWallPaperList() -> NSArray {
        return ["bg1.jpg", "bg2.jpg", "bg3.jpg", "bg4.jpg", "bg5.jpg", "bg6.jpg", "bg7.jpg"]
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
    
    func getPath( fileName: NSString) -> NSString {
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")!
    }
    func getPathJPG(fileName: NSString)->NSString {
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "jpg")!
    }
}
