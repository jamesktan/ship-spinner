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
        let pathDownloads = Util.getDownloadPath()
        defaultDictionary = NSDictionary(contentsOfFile: Util.getPath(defaultsFile))!

        if downloadFileExists() {
            // download file exists
            var assetDownload = pathDownloads.stringByAppendingPathComponent(assetFile+"Online.plist")
            var detailsDownload = pathDownloads.stringByAppendingPathComponent(detailFile+"Online.plist")
            assetDictionary = NSDictionary(contentsOfFile: assetDownload)!
            detailsDictionary = NSDictionary(contentsOfFile: detailsDownload)!
        } else {
            // no downloads exist, use the bundled local ones
            assetDictionary = NSDictionary(contentsOfFile: Util.getPath(assetFile))!
            detailsDictionary = NSDictionary(contentsOfFile: Util.getPath(detailFile))!
        }
    }
    
    func downloadFileExists() -> Bool{
        return NSFileManager.defaultManager().fileExistsAtPath(Util.getDownloadPath()) ? true : false
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
        var base : NSString = getDefault("downloadURL") as NSString
        var assetOnline : NSString = base + assetFile + "Online.plist"
        var detailOnline : NSString = base + detailFile + "Online.plist"
        
        // Download the plist
        var assetFilePath = Util.downloadFileAtPath(assetOnline)
        var detailFilePath = Util.downloadFileAtPath(detailOnline)
        
        // Open and Parse the plist for download links
        var assetDictionary : NSMutableDictionary = NSMutableDictionary(contentsOfFile: assetFilePath as String)!
        var fileLinks : NSArray = assetDictionary.allKeys as NSArray
        var downloadLinks : NSArray = assetDictionary.allValues as NSArray
        
        // Download each model, get the filepath, and store the last two in the asset dictionary, unpack it
        var count = NSNumber(integer: fileLinks.count)
        var userInfo : NSDictionary = ["count":count]
        NSNotificationCenter.defaultCenter().postNotificationName("progress+start", object: nil, userInfo:userInfo)
        
        for link in downloadLinks {
            var newPath : NSString = Util.downloadModelAndUnzipAtPath(link as NSString) as NSString //download the file
            
            // Compose the New Key
            var index = downloadLinks.indexOfObject(link)
            var key : NSString = fileLinks.objectAtIndex(index) as NSString
            //var newValue = newPath.lastPathComponent.stringByAppendingPathComponent(key) // compose path to the dae file
            var newValue = newPath.stringByAppendingPathComponent(key)
            NSLog("new path var: %@", newValue)

            // Set the AssetDictionary
            assetDictionary.removeObjectForKey(key)
            assetDictionary.setValue(newValue, forKey: key)
            
            // Let progress be known!
            NSNotificationCenter.defaultCenter().postNotificationName("progress+1", object: nil)
        }
        
        // Save the new assetFile
        assetDictionary.writeToFile(assetFilePath, atomically: true)
        NSNotificationCenter.defaultCenter().postNotificationName("progress+end", object: nil)
        
    }
    
}
