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
    
    // Scene
    @IBOutlet weak var myscene: SCNView!
    
    // Top Nav
    @IBOutlet weak var buttonList : UIButton!
    @IBOutlet weak var buttonDetail : UIButton!
    @IBOutlet weak var buttonSettings : UIButton!
    
    // Views
    @IBOutlet weak var shipListView : UITableView!
    @IBOutlet weak var shipDetailView : UIView!
    @IBOutlet weak var settingView : UIView!
    var views : NSArray? = nil
    
    let transTime = 0.33

    
    // Labels
    @IBOutlet weak var l_name: UILabel!
    @IBOutlet weak var l_class: UILabel!
    @IBOutlet weak var l_role: UILabel!
    @IBOutlet weak var l_length: UILabel!
    @IBOutlet weak var l_mass: UILabel!
    @IBOutlet weak var l_acc: UILabel!
    @IBOutlet weak var tv_description: UITextView!
    
    
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

        views = [shipListView, shipDetailView, settingView]
        
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
    
    @IBAction func showView(sender:UIButton) {
        
        var view : UIView = views!.objectAtIndex(sender.tag) as UIView
        if sender.selected {
            handleAnimation(view, moveToPoint: view.frame.origin, alpha: 0.0)
        } else {
            handleAnimation(view, moveToPoint: view.frame.origin, alpha: 1.0)
        }
        sender.selected = !(sender.selected)
    }
    
    // Custom Methods - HandleAnimation
    
    func handleAnimation(view : UIView, moveToPoint : CGPoint, alpha : CGFloat) {
        UIView.animateWithDuration(transTime, animations: {
            var offset : CGFloat = 0
//            if alpha == 0.0 {
//                offset = -320.0
//            }
            view.frame = CGRectMake(moveToPoint.x + offset, moveToPoint.y, view.frame.size.width, view.frame.size.height)
            view.alpha = CGFloat(alpha)
        })
    }
    
    // Custom Methods - Changing Properties
    
    @IBAction func changeWallpaper() {
        var wallpaperID = "bg1.jpg"
        frame.presenter!.setWallpaper(wallpaperID)
    }
    
    @IBAction func changeMusic() {
        var musicID = "music1.jpg"
        frame.presenter!.setMusic(musicID)
    }
    
    @IBAction func changeShip() {
        var shipID = "ship1"
        frame.presenter!.setShip(shipID)
    }
    
    @IBAction func changeShipRotateSpeed(sender : UISlider) {
        var rotateRate : Float = 30.0
        frame.presenter!.setRotateSpeed(rotateRate)
    }
    
    @IBAction func downloadShips() {
        frame.presenter!.download()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

