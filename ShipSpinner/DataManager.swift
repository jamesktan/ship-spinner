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
    
    
    func downloadFileExists() -> Bool{
        return NSFileManager.defaultManager().fileExistsAtPath(Util.getDownloadPath() as String) ? true : false
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
        var list : NSDictionary = getDefault("wallList") as! NSDictionary
        return list.allKeys
    }
    
    func getLightPosition(bgName:NSString) -> NSArray {
        var list = defaultDictionary.objectForKey("wallList") as! NSDictionary
        var object = list.objectForKey(bgName) as! NSArray
        var values = Util.splitByComma(object.lastObject as! NSString)
        return values
    }
    
    func getAmbientColor(bgName:NSString) -> NSArray {
        var list = defaultDictionary.objectForKey("wallList") as! NSDictionary
        var object = list.objectForKey(bgName) as! NSArray
        return Util.splitByComma(object.firstObject as! NSString)
    }
    
    func getDefault(key : NSString) -> AnyObject? {
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey(key as String) == nil { //if - No Defaults Saved
            defaults.setValue(defaultDictionary.objectForKey(key), forKey: key as String)
            defaults.synchronize()
        } 
        return defaults.objectForKey(key as String)
    }
    
    func saveDefault(key : NSString, value: AnyObject?) {
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(value, forKey: key as String)
        defaults.synchronize()
    }
    
    func download() {
        var base : NSString = getDefault("downloadURL") as! NSString
        var assetOnline : NSString = (base as String) + (assetFile as String) + "Online.plist"
        var detailOnline : NSString = (base as String) + (detailFile as String) + "Online.plist"
        
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
        NSNotificationCenter.defaultCenter().postNotificationName("progress+start", object: nil, userInfo:userInfo as [NSObject : AnyObject])
        
        for link in downloadLinks {
            var newPath : NSString = Util.downloadModelAndUnzipAtPath(link as! NSString) as NSString //download the file
            
            // Compose the New Key
            var index = downloadLinks.indexOfObject(link)
            var key : NSString = fileLinks.objectAtIndex(index) as! NSString
            var newValue = newPath.lastPathComponent.stringByAppendingPathComponent(key as String) // compose path to the dae file
            NSLog("new path var: %@", newValue)

            // Set the AssetDictionary
            assetDictionary.removeObjectForKey(key)
            assetDictionary.setValue(newValue, forKey: key as String)
            
            // Let progress be known!
            NSNotificationCenter.defaultCenter().postNotificationName("progress+1", object: nil)
        }
        
        // Save the new assetFile
        let pathDownloads = Util.getDownloadPath()
        var asset = pathDownloads.stringByAppendingPathComponent((assetFile as String)+".plist")
        assetDictionary.writeToFile(asset as String, atomically: true)
        NSNotificationCenter.defaultCenter().postNotificationName("progress+end", object: nil)
        reloadAssetFile()
        
    }
    
    func shipDownloaded(id: NSString) -> Bool {
        var folderName = id.stringByReplacingOccurrencesOfString(".dae", withString: ".scnassets")
        return Util.folderExists(folderName)
    }
    
    // @jtan todo: work on these

    func downloadShip(id:NSString) {
        var shipURL : NSString = assetDictionary.objectForKey(id) as! NSString
        var shipPath : NSString = Util.downloadModelAndUnzipAtPath(shipURL)
        var daePath : NSString = shipPath.lastPathComponent.stringByAppendingPathComponent(id as String)
        saveShipAssetKeyValue(assetDictionary, shipID: id, folderName: daePath)
        reloadAssetFile()
    }
    
    func saveShipAssetKeyValue(dict: NSDictionary, shipID: NSString, folderName: NSString ) {
        
        // Set the Values
        var mDict : NSMutableDictionary = NSMutableDictionary(dictionary: dict)
        mDict.removeObjectForKey(shipID)
        mDict.setValue(folderName, forKey: shipID as String)
        
        // Compose the Path
        let pathDownloads = Util.getDownloadPath()
        var asset = pathDownloads.stringByAppendingPathComponent((assetFile as String)+".plist")
        
        // Write to File
        mDict.writeToFile(asset as String, atomically: true)
    }
    
    func reloadAssetFile() {
        let pathDownloads = Util.getDownloadPath()
        var asset = pathDownloads.stringByAppendingPathComponent((assetFile as String)+".plist")
        assetDictionary = NSDictionary(contentsOfFile: asset as String)!
    }
    
    func load() {
        // First Load Only
        loadDefaults()
        downloadManifest()
        
        loadAssets()
        loadDetails()
        loadShipFirstRun()
    }
    func loadShipFirstRun() {
        // Check if the file exists
        let pathDownloads = Util.getDownloadPath()
        var asset = pathDownloads.stringByAppendingPathComponent((assetFile as String)+".plist")
        if (!Util.fileExistsAtPath(asset)) { // file does not exist, download the ship
            self.downloadShip(getDefault("currentShip") as! String)
        }
    }
    func downloadManifest() {
        var base : NSString = getDefault("downloadURL") as! NSString
        var assetOnline : NSString = (base as String) + (assetFile as String) + "Online.plist"
        var detailOnline : NSString = (base as String) + (detailFile as String) + "Online.plist"
        
        // Download the plist
        var assetFilePath = Util.downloadFileAtPath(assetOnline)
        var detailFilePath = Util.downloadFileAtPath(detailOnline)
    }
    func loadAssets() {
        var asset = (assetFile as String)+".plist"
        var assetOnline = (assetFile as String)+"Online.plist"
        var use = (Util.folderExists(asset)) ? asset : assetOnline
        use = Util.getDownloadPath().stringByAppendingPathComponent(use)
        assetDictionary = NSDictionary(contentsOfFile:use)!
    }
    func loadDetails() {
        var detail = (detailFile as String)+".plist"
        var detailOnline = (detailFile as String)+"Online.plist"
        var use = (Util.folderExists(detail)) ? detail : detailOnline
        use = Util.getDownloadPath().stringByAppendingPathComponent(use)
        detailsDictionary = NSDictionary(contentsOfFile:use)!

    }
    func loadDefaults() {
        let pathDownloads = Util.getDownloadPath()
        defaultDictionary = NSDictionary(contentsOfFile: Util.getPath(defaultsFile) as String)!
    }
    

    
}
