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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Scene
    @IBOutlet weak var myscene: SCNView!
    @IBOutlet weak var wallpaper: UIImageView!
    
    // Top Nav
    @IBOutlet weak var buttonList : UIButton!
    @IBOutlet weak var buttonDetail : UIButton!
    @IBOutlet weak var buttonSettings : UIButton!
    @IBOutlet weak var buttonRotate: UIButton!
    
    // Views
    @IBOutlet weak var shipListView : UITableView!
    @IBOutlet weak var shipDetailView : UIView!
    @IBOutlet weak var settingView : UIView!
    
    let spinKey = "spinRoundRound"
    let transTime = 0.33
    var wallpaperID = "" //preload
    var shipID = "" //preload
    var rotate = false //preload
    var views : NSArray? = nil //preload
    
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
        
        // Load View with Data
        shipID = frame.presenter!.idForLastShip() as String
        wallpaperID = frame.presenter!.idForLastWallpaper() as String
        rotate = frame.presenter!.shouldRotate()
        
        loadWallpaper(wallpaperID)
        loadShipData(shipID)
        wallpaper.addMotionEffect(frame.presenter!.createParallax())
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadShipData(id : NSString) {
        
        // Labels
        var shipInfo = frame.presenter!.getShip(id)
        l_name.text = shipInfo.0 as String
        l_class.text = shipInfo.1 as String
        l_role.text = shipInfo.2 as String
        tv_description.text = shipInfo.3 as String
        
        
        // Model
        if frame.presenter!.isFileDownloaded() {
            
            var scene = SCNScene()
            
            var lightNode = frame.presenter!.createLightNode() as SCNNode
            var sceneNode = frame.presenter!.getShipNode(id) as SCNNode
            var ambientNode = frame.presenter!.createAmbientLightNode()
            
            scene.rootNode.addChildNode(lightNode)
            scene.rootNode.addChildNode(ambientNode)
            scene.rootNode.addChildNode(sceneNode)
            
            myscene.scene = scene

        } else {
            myscene.scene = SCNScene(named: shipInfo.4 as String)
        }
        myscene.backgroundColor = UIColor.clearColor()

        // Spin
        buttonRotate.selected = rotate
        (rotate) ?
            myscene.scene?.rootNode.addAnimation(frame.presenter!.createSpin(), forKey: spinKey) :
            myscene.scene?.rootNode.removeAnimationForKey(spinKey)
        
    }
    
    func loadWallpaper(id : NSString) {
        var image : (UIImage, UIViewContentMode) = frame.presenter!.getWallpaper(id)
        self.wallpaper.image = image.0
        self.wallpaper.contentMode = image.1
    }
    
    // TableViewDelegate Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var details = frame.presenter!.getListDisplayDetails(indexPath)
        var cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: details.0 as String)
        cell.textLabel?.text = details.1 as String //friendlyName
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "Helvetica-Bold", size: 13.0)
        //cell.imageView?.image = details.2 //image
        
        NSLog(cell.textLabel!.text!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        shipID = cell.reuseIdentifier! // Change the current shipID
        loadShipData(shipID) // Change the Ship Details
        frame.presenter!.setShip(shipID) // Set New Default Ship
        tableView.deselectRowAtIndexPath(indexPath, animated: true) // Unhighlight Row
        showView(buttonList) // Hides the view
        return
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frame.presenter!.getShipListCount()
    }
    
    // Custom Methods - Hide / Show Windows
    
    @IBAction func showView(sender:UIButton) {
        var view : UIView = views!.objectAtIndex(sender.tag) as! UIView
        var alpha : CGFloat = sender.selected ? 0.0 : 1.0
        handleAnimation(view, moveToPoint: view.frame.origin, alpha: alpha)
        sender.selected = !(sender.selected)
    }
    
    func handleAnimation(view : UIView, moveToPoint : CGPoint, alpha : CGFloat) {
        UIView.animateWithDuration(transTime, animations: {
            view.frame = CGRectMake(moveToPoint.x, moveToPoint.y, view.frame.size.width, view.frame.size.height)
            view.alpha = CGFloat(alpha)
        })
    }
    
    // Custom Methods - Changing Properties
    
    @IBAction func changeWallpaper() {
        wallpaperID = frame.presenter!.getNextBackground(wallpaperID) as String
        frame.presenter!.setWallpaper(wallpaperID, contentMode: wallpaper.contentMode)
        loadWallpaper(wallpaperID)
    }
    
    @IBAction func changeRotate(sender: UIButton) {
        
        sender.selected ? frame.presenter!.setRotate(false) : frame.presenter!.setRotate(true)
        sender.selected = !sender.selected
        rotate = !rotate
        
        (rotate) ?
            myscene.scene?.rootNode.addAnimation(frame.presenter!.createSpin(), forKey: spinKey) :
            myscene.scene?.rootNode.removeAnimationForKey(spinKey)

    }
    
    @IBAction func downloadShips() {
        frame.presenter!.download()
        shipListView.reloadData()
    }

    @IBAction func about(sender: UIButton) {
        var view : UIAlertView = UIAlertView(title: "Nabaal Shipyards", message: "I don't own any content! Everything here belongs to GearBox", delegate: nil, cancelButtonTitle: "OK")
        view.show()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

