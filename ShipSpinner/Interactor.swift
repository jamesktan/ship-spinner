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
    
    // getShipList - return list of all ship names
    func getShipList() -> NSArray {
        return dm!.findShipList()
    }
    
    // getShipListNice - return a nice named list of all ships
    func getShipListNice() -> NSArray {
        var niceList : NSMutableArray = []
        var shipList = getShipList()
        for ship in shipList {
            var shipEntity = interactor!.getShip(ship)
            var niceName = ship.shipName
            niceList.addObject(niceName)
        }
        return niceList
    }
    
    func getShip(id_ship : NSString) -> ShipEntity {
        return dm!.findShip(id_ship)
    }
    
    // SET
    
    func setWallpaper(id : NSString) {
        dm!.saveDefault("currentWall", id)
    }
    
    func setMusic(id : NSString) {
        dm!.saveDefault("currentMusic", id)
    }
    
    func setShip(id : NSString) {
        dm!.saveDefault("currentShip", id)
    }
    
    func setRotateSpeed(v : NSNumber) {
        dm!.saveDefault("currentSpeed", id)
    }
    
    func download() {
        dm!.download()
    }
    
 
    func getHello() {
        NSLog("Hello!!!")
        dm?.getHello()
    }
}
