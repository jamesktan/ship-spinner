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
    
    func isFileDownloaded() -> Bool {
        return interactor!.isFileDownloaded()
    }
    
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
    func getShipNode(name_ship:NSString) -> SCNNode {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:@"product-1-optimized.scnassets/cube.dae"];
//
        var ddURL = NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false, error: nil)
        var a = ddURL!.URLByAppendingPathComponent("/Downloads/kush_cloakedfighter.scnassets/kush_cloakedfighter.dae")
        
        var ship = interactor!.getShip(name_ship)
        var shipasst = ship.shipAssetPath as String
        var url = NSURL(string: shipasst)
        var sceneSource : SCNSceneSource = SCNSceneSource(URL: a , options: nil)!
        var sceneIdentifier : String = "Kus_CloakedFighter1"
        var b : NSArray = sceneSource.identifiersOfEntriesWithClass(SCNNode.self)!
        var sceneNode : SCNNode = sceneSource.entryWithIdentifier(sceneIdentifier, withClass: SCNNode.self) as SCNNode
        sceneNode.position = SCNVector3Make(0, 0, 0)
        
        return sceneNode
    }
    
    func getWallpaper(name_wallpaper : NSString) -> (UIImage, UIViewContentMode){
        return interactor!.getWallpaper(name_wallpaper)
    }
    
    func getShipListCount() -> NSInteger {
        return getShipListNice().count
    }
    
    // resuse, nice title, image
    func getListDisplayDetails(indexpath : NSIndexPath) -> (NSString, NSString, UIImage)  {
        var list : NSArray = getShipListNice()
        var ids : NSArray = interactor!.getShipList()
        var id = ids.objectAtIndex(indexpath.row) as NSString
        var name = list.objectAtIndex(indexpath.row) as NSString
        return (id,name,UIImage())
    }
    
    func getShipListNice() -> NSArray {
        var niceList = interactor!.getShipListNice()
        return niceList
    }

    func getNextBackground(id_current : NSString) -> NSString {
        return interactor!.getNextWallpaper(id_current)
    }
    
    // SET
    
    func setWallpaper(idWall : NSString, contentMode: UIViewContentMode) {
        interactor?.setWallpaper(idWall,contentMode: contentMode)
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
    
    func createLightNode() -> SCNNode {
        var lightNode : SCNNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3Make(0, 6, 10)
        return lightNode
    }
    
    func createAmbientLightNode() -> SCNNode {
        var ambientNode : SCNNode = SCNNode()
        ambientNode.light = SCNLight()
        ambientNode.light?.type = SCNLightTypeAmbient
        ambientNode.light?.color = UIColor.grayColor()
        return ambientNode
    }
    
}
