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
    
    
    func getShip(name_ship : NSString) -> (NSString, NSString, NSString, NSString, NSString, NSString, NSString, NSString) {
        var ship = interactor!.getShip(name_ship)
        
        var nameLabel = "NAME: " + (ship.shipName! as String)
        var classLabel = "CLASS: " + (ship.shipClass! as String)
        var roleLabel = "ROLE: "+(ship.shipRole! as String)
        var shipDescription = ship.shipDescription!
        var shipAssetPath = ship.shipAssetPath!
        var shipLength = "LENGTH: " + (ship.shipLength! as String)
        var shipMass = "MASS: " + (ship.shipMass! as String)
        var shipSpeed = "SPEED: " + (ship.shipSpeed! as String)
        
        return (nameLabel, classLabel, roleLabel, shipDescription, shipAssetPath, shipLength, shipMass , shipSpeed)
    }
    func getShipNode(name_ship:NSString) -> NSMutableArray {
        var nodes : NSMutableArray = []
        
        var props = interactor!.getShipDDProperties(name_ship)
        var sceneSource : SCNSceneSource = SCNSceneSource(URL: props.0 , options: nil)!
        
        var test : NSArray = sceneSource.identifiersOfEntriesWithClass(SCNNode.self)!
        var testMute : NSMutableArray = NSMutableArray(array:test)
        
        testMute.removeObject("node/2")
        testMute.removeObject("node/1")
        NSLog("%@ Available Nodes", test)
        
        for nodeName in testMute {
            var sceneNode : SCNNode = sceneSource.entryWithIdentifier(nodeName as! String, withClass: SCNNode.self) as! SCNNode
            sceneNode.position = SCNVector3Make(0, 0, 0)
            sceneNode.rotation = SCNVector4Make(1, 0, 0, Float(M_PI/2))
            nodes.addObject(sceneNode)
        }
        
        return nodes
    }
    func getScene(name : NSString)->SCNScene {
        var props = interactor!.getShipDDProperties(name)
        var sceneSource : SCNSceneSource = SCNSceneSource(URL: props.0 , options: nil)!
        var scene : SCNScene = SCNScene(URL: props.0, options: nil, error: nil)!
        for node in scene.rootNode.childNodes {
            var node : SCNNode = node as! SCNNode
            node.rotation = SCNVector4Make(1, 0, 0, Float(M_PI/2))
        }
        return scene
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
        var id = ids.objectAtIndex(indexpath.row) as! NSString
        var name = list.objectAtIndex(indexpath.row) as! NSString
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
    func createParallax()-> UIMotionEffectGroup {
        // Set vertical effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
            type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -30
        verticalMotionEffect.maximumRelativeValue = 30
        
        // Set horizontal effect
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
            type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -30
        horizontalMotionEffect.maximumRelativeValue = 30
        
        // Create group to combine both
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        // Add both effects to your view
        return group
    }
    func createSpin() -> CABasicAnimation {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * M_PI)))
        spin.duration = 30
        spin.repeatCount = .infinity
        return spin
    }
    
    func createSpinRev() -> CABasicAnimation {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: -1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: -1, z: 0, w: -Float(2 * M_PI)))
        spin.duration = 30
        spin.repeatCount = .infinity
        return spin
    }

    func createLightNode(bgName : NSString) -> SCNNode {
        var positionInfo = interactor!.getLightPositionForBG(bgName)
        var lightNode : SCNNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = SCNLightTypeOmni
        lightNode.position = SCNVector3Make(positionInfo.0, positionInfo.1, positionInfo.2)
        return lightNode
    }
    
    func createAmbientLightNode(bgName : NSString) -> SCNNode {
        var ambientInformation = interactor!.getAmbientInformationForBG(bgName)
        var ambientNode : SCNNode = SCNNode()
        ambientNode.light = SCNLight()
        ambientNode.light?.type = SCNLightTypeAmbient
        ambientNode.light?.color = UIColor(red: ambientInformation.0, green: ambientInformation.1, blue: ambientInformation.2, alpha: ambientInformation.3)
        return ambientNode
    }

    func createAboutAlert() -> UIAlertView {
        var view : UIAlertView = UIAlertView(title: "Nabaal Shipyards",
            message: "Created as fan-service to display and highlight the beautiful detail of Homeworld Remastered \n\n All models, assets, and lore belong to their respective owners (GearBox, Relic, Homeworld Shipyards and Encyclopedia Hiigara).  \n\nThe makers of Nabaal Shipards do not own any of the Homeworld assets, details, or descriptions.",
            delegate: nil, cancelButtonTitle: "CLOSE")
        return view
    }
}
