//
//  Presenter.swift
//  ShipSpinner
//
//  Created by James Tan on 4/1/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class Presenter: NSObject {
    
    // VIPER
    var view : ViewController? = nil
    var interactor : Interactor? = nil
    
    func idForLastShip() -> NSString {
        return interactor!.idForLastShip()
    }
    func idForLastWallpaper() -> NSString {
        return interactor!.idForLastWallpaper()
    }
    func shouldRotate() -> Bool {
        return interactor!.shouldRotate().boolValue
    }
    
    
    func getShip(name_ship : NSString) -> (NSString, NSString, NSString, NSString, NSString) {
        var ship = interactor!.getShip(name_ship)
        return ("NAME: " + ship.shipName!, "CLASS: " + ship.shipClass!, "ROLE: "+ship.shipRole!, ship.shipDescription!, ship.shipAssetPath!)
    }
    
    func getWallpaper(name_wallpaper : NSString) -> (UIImage, UIViewContentMode){
        return (UIImage(), UIViewContentMode.Center)
    }
    
    func getShipListCount() -> NSInteger {
        return getShipListNice().count
    }
    
    func getListDisplayDetails(indexpath : NSIndexPath) -> (NSString, NSString, UIImage) {
        return ("","",UIImage())
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
        
    func setShip(idShip : NSString) {
        interactor?.setShip(idShip)
    }
    
    func setRotate(rotate : Bool) {
        interactor?.setRotateSpeed(NSNumber(bool:rotate))
    }
    
    func download() {
        interactor?.download()
    }
    
    
    // Create
    
    func createSpin() -> CABasicAnimation {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * M_PI)))
        spin.duration = 20
        spin.repeatCount = .infinity
        return spin
    }
    
}
