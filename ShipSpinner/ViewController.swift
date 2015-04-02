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
    
    @IBOutlet weak var buttonList : UIButton
    @IBOutlet weak var buttonDetail : UIButton
    @IBOutlet weak var buttonStats : UIButton
    @IBOutlet weak var buttonSettings : UIButton
    var buttons = [buttonList, buttonDetail, butonStats, buttonSettings]
    
    @IBOutlet weak var shipListView : UITableView!
    @IBOutlet weak var shipDetailView : UIView!
    @IBOutlet weak var shipStatisticsView : UIView!
    @IBOutlet weak var settingsView : UIView!
    var view = [shipListView, shipDetailView, shipStatisticsView, settingView]
    
    var frameList = CGRectMake(0,0,320,768)
    var frameDetail = CGRectMake(0,0,320,768)
    var frameStats = CGRectMake(0,0,320,768)
    var frameSetting = CGRectMake(0,0,320,768)
    var frames = [frameList, frameDetail, frameStats, frameSetting]
    
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
    
    @IBAction func showView(sender:UIButton) {
        var view = views.objectAtIndex(sender.tag)
        var frame = frames.objectAtIndex(sender.tag)
        if sender.selected {
            handleAnimation(view, frame, 0.0)
        } else {
            handleAnimation(view, frame, 1.0)
        }
        sender.selected = !(sender.selected)
    }
    
    // Custom Methods - HandleAnimation
    
    func handleAnimation(view : UIView, moveToPoint : CGPoint, alpha : Float) {
        UIView.animateWithDuration(transTime, animations: {
            view.setFrame(CGRectMake(moveToPoint.x, moveToPoint.y, view.frame.size.width, view.frame.size.height))
            view.alpha = alpha
        }, completion: {
        })
    }
    
    // Custom Methods - Changing Properties
    
    @IBAction func changeWallpaper() {
        frame!.presenter.setWallpaper(wallpaperID)
    }
    
    @IBAction func changeMusic() {
        frame!.presenter.setMusic(musicID)
    }
    
    @IBAction func changeShip() {
        frame!.presenter.setShip(shipID)
    }
    
    @IBAction func changeShipRotateSpeed(sender : UISlider) {
        frame!.presenter.setRotateSpeed(rotateRate)
    }
    
    @IBAction func downloadShips() {
        frame!.presenter.download()
    }

}

