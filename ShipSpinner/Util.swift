//
//  Util.swift
//  ShipSpinner
//
//  Created by James Tan on 4/6/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit
import Alamofire

class Util: NSObject {
    class func getDownloadPath() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let pathDownloads = paths.stringByAppendingPathComponent("Downloads") as NSString
        return pathDownloads
    }
    
    class func getPath( fileName: NSString) -> NSString {
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")!
    }
    class func getPathJPG(fileName: NSString)->NSString {
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "jpg")!
    }
    
    // Downloads the PLIST file
    class func downloadFileAtPath(url: NSString) -> NSString {
        var urlObj : NSURL = NSURL(string: url)!
        var urlData : NSData = NSData(contentsOfURL: urlObj)!
        var filePath = Util.getDownloadPath().stringByAppendingPathComponent(url.lastPathComponent)
        urlData.writeToFile(filePath, atomically: true)
        return filePath
    }
    
    
    class func downloadModelAndUnzipAtPath(url: NSString) -> NSString {
        var filePath : NSString = ""
        
        // Use Alamo Fire to Download the .ZIP files (which can be large)
        var urlObj : NSURL = NSURL(string: url)!

        // Get or Create the Path
        var path = Util.getDownloadPath() //Documents/Download/
        var exists = NSFileManager.defaultManager().fileExistsAtPath(path)
        if !exists {
            NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        NSLog("path at: %@", path)
        
        // Downloadthe file
        Alamofire.download(.GET, url as String, { (temporaryURL, response) in
            
            if let directoryURL = NSFileManager.defaultManager()
                .URLsForDirectory(.DocumentDirectory,
                    inDomains: .UserDomainMask)[0]
                as? NSURL {
                    let pathComponent = response.suggestedFilename
                    let directoryString =  path.stringByAppendingPathComponent(pathComponent!)
                    filePath = directoryString as NSString // set the filepath where it is downloaded
                    NSLog("downloaded to: %@", filePath)
                    let directoryURL = NSURL(string: directoryString)
                    return directoryURL!
            }
            return temporaryURL
        })
        
        // Get the Extract Path
        var filenameRaw = filePath.lastPathComponent as NSString
        var filename = filenameRaw.stringByReplacingOccurrencesOfString(".zip", withString: "")
        var extractPath = path.stringByAppendingPathComponent(filename)
        NSLog("extract path: %@", extractPath)
        
        // Unzip the file
        SSZipArchive.unzipFileAtPath(filePath, toDestination: extractPath)
        NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
        NSLog("deleted the .zip file at %@", filePath)
        
        
        
        return extractPath
    }
}
