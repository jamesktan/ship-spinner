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
        Alamofire.request(.GET, "http://httpbin.org/get")

        Alamofire.download(.GET, "http://httpbin.org/stream/100", { (temporaryURL, response) in
            if let directoryURL = NSFileManager.defaultManager()
                .URLsForDirectory(.DocumentDirectory,
                    inDomains: .UserDomainMask)[0]
                as? NSURL {
                    let pathComponent = response.suggestedFilename
                    
                    return directoryURL.URLByAppendingPathComponent(pathComponent!)
            }
            
            return temporaryURL
        })
        
        return filePath
    }
}
