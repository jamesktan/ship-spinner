//
//  ViewController.swift
//  ShipSpinner
//
//  Created by James Tan on 11/16/14.
//  Copyright (c) 2014 Axon Flux. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myscene: SCNView!
    @IBOutlet weak var shipListView : UITableView!
    @IBOutlet weak var shipDetailView : UIView!
    @IBOutlet weak var shipStatisticsView : UIView!
    @IBOutlet weak var settingsView : UIView!
    
    class var shared : ViewController {
        struct Static {
            static let instance : ViewController = ViewController()
        }
        return Static.instance
    }
    struct frame {
        static var presenter : Presenter? = nil
    }

    // UIView LifeCycle Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myscene.scene = SCNScene(named: "kushdae.scnassets/kush_cloakedfighter")
        myscene.allowsCameraControl = true;
        
        // Spin
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * M_PI)))
        spin.duration = 20
        spin.repeatCount = .infinity
        myscene.scene?.rootNode.addAnimation(spin, forKey: "spin around")

        //BG
        myscene.backgroundColor = UIColor.clearColor() 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // TableViewDelegate Methods
    
    // Custom Methods - Hide / Show Windows
    
    func showSettings() {
    }

    func showShipList() {
    }
    
    func showShipDetails() {
    }
    
    func showShipStatistics() {
    }
    
    // Custom Methods - Changing Properties
    
    func changeWallpaper() {
        frame!.presenter.setWallpaper(wallpaperID)
    }
    
    func changeMusic() {
        frame!.presenter.setMusic(musicID)
    }
    
    func changeShip() {
        frame!.presenter.setShip(shipID)
    }
    
    func changeShipRotateSpeed() {
        frame!.presenter.setRotateSpeed(rotateRate)
    }
    
    func downloadShips() {
        frame!.presenter.download()
    }

}

