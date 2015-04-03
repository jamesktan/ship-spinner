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
    
    func idForLastShip() -> NSString {
        return ""
    }
    func idForLastWallpaper() -> NSString {
        return ""
    }
    
    func getShip(name_ship : NSString) -> (NSString, NSString, NSString, NSString, NSString) {
        var ship = interactor!.getShip(name_ship)
        return ("NAME: " + ship.shipName!, "CLASS: " + ship.shipClass!, "ROLE: "+ship.shipRole!, ship.shipDescription!, ship.shipAssetPath!)
    }
    
    func getWallpaper(name_wallpaper : NSString) -> (UIImage, UIViewContentMode){
        return (UIImage(), UIViewContentMode.Center)
    }
    
    func getShipListNice() -> NSArray {
        var niceList = interactor!.getShipListNice()
        return niceList
    }

    func getNextBackground(id_current : NSString) -> NSString {
        var bgList = []//interactor?.getBackgroundList()
        var index = bgList.indexOfObject(id_current)
        var nextIndex = (index + 1 == bgList.count) ? 0 : index + 1
        return bgList.objectAtIndex(nextIndex) as NSString
    }
    
    func getCurrentBackground() -> NSString {
        return interactor!.getCurrentBackground()
    }
    
    func getNextMusic(id_current : NSString) -> NSString {
        var musicList = []
        var index = musicList.indexOfObject(id_current)
        var nextIndex = (index + 1 == musicList.count) ? 0 : index + 1
        return musicList.objectAtIndex(nextIndex) as NSString
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
        interactor?.setRotateSpeed(NSNumber(float:idSpeed))
    }
    
    func download() {
        interactor?.download()
    }
    
    func getHello() {
        NSLog("HELLO")
        interactor?.getHello()
    }
}
