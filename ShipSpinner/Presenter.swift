//
//  Presenter.swift
//  ShipSpinner
//
//  Created by James Tan on 4/1/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit

class Presenter: NSObject {
    
    // VIPER
    var view : ViewController? = nil
    var interactor : Interactor? = nil
    
    func getShip(name_ship : NSString) -> (NSString, NSString, NSString, NSString, NSString) {
        var ship = interactor!.getShip(name_ship)
        return (ship.shipName!, ship.shipClass!, ship.shipRole!, ship.shipDescription!, ship.shipAssetPath!)
    }
    
    func getShipListNice() -> NSArray {
        var niceList = interactor.getShipListNice
        return niceList
    }

    // SET
    
    func setWallpaper(idWall : NSString) {
        interactor?.setWallpaper(idWall)
    }
    
    func setMusic(idMusic : NSString) {
        interactor?.setMusic(idMusic)
    }
    
    func setShip(idShip : NSString) {
        interactor?.setShip(idShip)
    }
    
    func setRotateSpeed(idSpeed : Float) {
        interactor?.setRotateSpeed(NSNumber(numberWithFloat:idSpeed))
    }
    
    func download() {
        interactor?.download()
    }
    
    func getHello() {
        NSLog("HELLO")
        interactor?.getHello()
    }
}
