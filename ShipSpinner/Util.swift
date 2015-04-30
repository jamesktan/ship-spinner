//
//  Util.swift
//  ShipSpinner
//
//  Created by James Tan on 4/6/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit
//import Alamofire

class Util: NSObject {
    
    class func folderExists(s:NSString) -> Bool {
        var path = Util.getDownloadPath() //Documents/Download/
        var complete = path.stringByAppendingPathComponent(s as String)
        return NSFileManager.defaultManager().fileExistsAtPath(complete)
    }
    class func splitByComma(s : NSString) -> NSArray {
        var values = s.componentsSeparatedByString(",")
        var valuesNum = values.map({($0).floatValue})
        return valuesNum
    }
    
    class func getDownloadPath() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        let pathDownloads = paths.stringByAppendingPathComponent("Downloads") as NSString
        return pathDownloads
    }
    class func downloadPathExists() -> Bool {
        var path = Util.getDownloadPath() //Documents/Download/
        return NSFileManager.defaultManager().fileExistsAtPath(path as String)
    }
    
    class func getPath( fileName: NSString) -> NSString {
        return NSBundle.mainBundle().pathForResource(fileName as String, ofType: "plist")!
    }
    class func getPathJPG(fileName: NSString)->NSString {
        return NSBundle.mainBundle().pathForResource(fileName as String, ofType: "jpg")!
    }
    
    class func loadOrCreatePath()-> NSString {
        // Get or Create the Path
        var path = Util.getDownloadPath() //Documents/Download/
        var exists = NSFileManager.defaultManager().fileExistsAtPath(path as String)
        if !exists {
            NSFileManager.defaultManager().createDirectoryAtPath(path as String, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        NSLog("path at: %@", path)
        return path as NSString

    }
    
    // Downloads the PLIST file
    class func downloadFileAtPath(url: NSString) -> NSString {
        
        //Check the path exists
        var path = loadOrCreatePath()
        
        var urlObj : NSURL = NSURL(string: url as String)!
        var urlData : NSData = NSData(contentsOfURL: urlObj)!
        var filePath = path.stringByAppendingPathComponent(url.lastPathComponent)
        urlData.writeToFile(filePath, atomically: true)
        return filePath
    }
    
    
    class func downloadModelAndUnzipAtPath(url: NSString) -> NSString {
        var filePath : NSString = ""
        NSLog("downloadURL: %@", url)
        
        // Use Alamo Fire to Download the .ZIP files (which can be large)
        var urlObj : NSURL = NSURL(string: url as String)!
        
        var path = Util.loadOrCreatePath()
        
        var dest = path
        
        // Downloadthe file
        filePath = Util.downloadFileAtPath(url)
//        Alamofire.download(.GET, url as String, { (temporaryURL, response) in
//            
//            if let directoryURL = NSFileManager.defaultManager()
//                .URLsForDirectory(.DocumentDirectory,
//                    inDomains: .UserDomainMask)[0]
//                as? NSURL {
//                    let pathComponent = response.suggestedFilename
//                    let directoryString =  path.stringByAppendingPathComponent(pathComponent!)
//                    filePath = directoryString as NSString // set the filepath where it is downloaded
//                    NSLog("downloaded to: %@", filePath)
//                    let directoryURL = NSURL(string: directoryString)
//                    return directoryURL!
//            }
//            return temporaryURL
//        })
        
        // Get the Extract Path
        var filenameRaw = filePath.lastPathComponent as NSString
        var filename = filenameRaw.stringByReplacingOccurrencesOfString(".zip", withString: "")
        NSLog("extract path: %@", path)
        
        // Unzip the file
        SSZipArchive.unzipFileAtPath(filePath as String, toDestination: path as String)
        NSFileManager.defaultManager().removeItemAtPath(filePath as String, error: nil)
        NSLog("deleted the .zip file at %@", filePath)
        
        
        
        return path.stringByAppendingPathComponent(filename)
    }
}
