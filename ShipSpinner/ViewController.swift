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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SCNSceneRendererDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    // Scene
    @IBOutlet weak var myscene: SCNView!
    @IBOutlet weak var wallpaper: UIImageView!
    
    // Top Nav
    @IBOutlet weak var buttonList : UIButton!
    @IBOutlet weak var buttonDetail : UIButton!
    @IBOutlet weak var buttonSettings : UIButton!
    @IBOutlet weak var buttonRotate: UIButton!
    
    // Other Buttons
    @IBOutlet weak var buttonDownloadAll: UIButton!

    
    // Views
    @IBOutlet weak var shipListView : UITableView!
    @IBOutlet weak var shipDetailView : UIView!
    @IBOutlet weak var settingView : UIView!
    
    @IBOutlet weak var fleetIcon: UIImageView!
    
    let spinKey = "spinRoundRound"
    let transTime = 0.33
    var wallpaperID = "" //preload
    var shipID = "" //preload
    var rotate = false //preload
    var views : NSArray? = nil //preload
    var buttons : NSArray? = nil
    var count = 0
    var originalCenter : CGPoint? = nil
  
    // Labels
    @IBOutlet weak var l_name: UILabel!
    @IBOutlet weak var tv_description: UITextView!
    
    
    // Nodes
    var lightNode : SCNNode? = nil
    var ambientNode : SCNNode? = nil
    
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
        buttons = [buttonList, buttonDetail,buttonSettings]
        
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
        tv_description.text = shipInfo.1 as String
        fleetIcon.image = shipInfo.3
        
        hideMyScene()
        
        // Model
        if frame.presenter!.isFileDownloaded() {
            var scene = SCNScene()
            var sceneNode : NSMutableArray = frame.presenter!.getShipNode(id)
            for node in sceneNode {
                scene.rootNode.addChildNode(node as! SCNNode)
            }
            myscene.scene = scene
//            myscene.antialiasingMode = SCNAntialiasingMode.Multisampling4X
          //@jtan: it would appear that at this time, having any multisampling at all will crash the app on an iPad. It's not clear that there are any discernable effects on other devices without actual investigation. The error is that of a "gpu restart" meaning that the GPU dies around 60FPS because, supposedly, there is some bugn in the thread handling for SceneKit. Multisampling seems to make this a  lot worse.
        } else {
            myscene.scene = SCNScene(named: shipInfo.2 as String)
        }
        myscene.backgroundColor = UIColor.clearColor()
        loadLight(wallpaperID) // Load the right Lide nodes
      
        showMyScene()
        
        // Spin
        buttonRotate.selected = rotate
        (rotate) ?
            myscene.scene?.rootNode.addAnimation(frame.presenter!.createSpin(), forKey: spinKey) :
            myscene.scene?.rootNode.removeAnimationForKey(spinKey)
    }
    
    func loadWallpaper(id : NSString) {
        // Load the Light Nodes
        loadLight(id)
        
        // Set the wallpaper image and content mode
        var image : (UIImage, UIViewContentMode) = frame.presenter!.getWallpaper(id)
        self.wallpaper.image = image.0
        self.wallpaper.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    func loadLight(id:NSString) {
        // adjust the
        lightNode?.removeFromParentNode()
        ambientNode?.removeFromParentNode()
        lightNode = frame.presenter!.createLightNode(id)
        ambientNode = frame.presenter!.createAmbientLightNode(id)
        myscene.scene?.rootNode.addChildNode(lightNode!)
        myscene.scene?.rootNode.addChildNode(ambientNode!)
    }
    
    // TableViewDelegate Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var details = frame.presenter!.getListDisplayDetails(indexPath)
        var cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: details.0 as String)
        cell.textLabel?.text = details.1 as String //friendlyName
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel!.font = UIFont(name: "Helvetica-Bold", size: 13.0)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping

        if frame.presenter!.shipIsPresent(details.0) {
            cell.detailTextLabel?.text = "SAVED"
            cell.detailTextLabel!.textColor = UIColor.orangeColor()

        } else {
            cell.detailTextLabel?.text = "DOWNLOAD NOW"
            cell.detailTextLabel!.textColor = UIColor.lightGrayColor()

        }
        NSLog(details.0 as String)
        NSLog(cell.textLabel!.text!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        shipID = cell.reuseIdentifier! // Change the current shipID
        // if the ship is not downloaded, download it first
        
        if (cell.detailTextLabel!.text != "SAVED") {
            if(!Util.isInternetAvailable()) {
                self.showView(self.buttonList)
                var alert = frame.presenter!.createNoInternetAlert()
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.showView(self.buttonList) // Hides the view
            tableView.deselectRowAtIndexPath(indexPath, animated: true) // Unhighlight Row

            self.activity.startAnimating()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                frame.presenter!.downloadShip(self.shipID)
                dispatch_async(dispatch_get_main_queue(), {
                    self.shipListView.reloadData()
                    self.activity.stopAnimating()
                    self.loadShipData(self.shipID)
                    frame.presenter!.setShip(self.shipID) // Set New Default Ship

                })
            })
        } else {
            self.showView(self.buttonList) // Hides the view
            self.loadShipData(self.shipID)
            frame.presenter!.setShip(self.shipID) // Set New Default Ship
            tableView.deselectRowAtIndexPath(indexPath, animated: true) // Unhighlight Row

        }
        return
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frame.presenter!.getShipListCount()
    }
    
    // Custom Methods - Hide / Show Windows
    func hideMyScene() {
        self.myscene.alpha = 0.0
        self.activity.startAnimating()
    }
    
    func showMyScene() {
        UIView.animateWithDuration(3.0, animations: {
            self.myscene.alpha = 1.0
            }, completion:{ finished in
                self.activity.stopAnimating()
            }
        )
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("handleAnimationScene"), userInfo: nil, repeats: false)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for button in buttons! {
            var b : UIButton = button as! UIButton
            if b.selected {
                if !b.isEqual(buttonDetail) {
                    showView(b)
                }
            }
        }
    }
    
    @IBAction func showView(sender:UIButton) {
        if (activity.isAnimating()) {
            return
        }
        var view : UIView = views!.objectAtIndex(sender.tag) as! UIView
        var alpha : CGFloat = sender.selected ? 0.0 : 1.0
        handleAnimation(view, moveToPoint: view.frame.origin, alpha: alpha)
        sender.selected = !(sender.selected)
        handleAnimationScene()

    }
    
    /// Handles the Supporting Views
    func handleAnimation(view : UIView, moveToPoint : CGPoint, alpha : CGFloat) {
        UIView.animateWithDuration(transTime, animations: {
            view.frame = CGRectMake(moveToPoint.x, moveToPoint.y, view.frame.size.width, view.frame.size.height)
            view.alpha = CGFloat(alpha)
        })
        
    }
    
    // Handles the Main Scene View
    func handleAnimationScene() {
        var value : CGFloat = -120
        if buttonList.selected {
            value = 0
        }
        if buttonDetail.selected {
            value = -200
        }
        if buttonList.selected && buttonDetail.selected {
            value = -90
        }
        UIView.animateWithDuration(transTime, animations: {
            self.myscene.frame.origin.x = value
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
        count = 0
        
        (rotate) ?
            myscene.scene?.rootNode.addAnimation(frame.presenter!.createSpin(), forKey: spinKey) :
            myscene.scene?.rootNode.removeAnimationForKey(spinKey)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("handleAnimationScene"), userInfo: nil, repeats: false)


    }
    
    @IBAction func downloadShips(sender: UIButton) {
        if(!Util.isInternetAvailable()) {
            self.showView(self.buttonSettings)
            var alert = frame.presenter!.createNoInternetAlert()
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

        var alert = UIAlertController(title: "Warming!", message: "You've chosen to download the entire ship library. \n\n Be aware that this will take some time, depending on internet connection. Ensure your device has enough space, is fully charged, and has a reliable internet connection", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "DOWNLOAD", style: UIAlertActionStyle.Default, handler: {action in
            self.activity.startAnimating()
            self.buttonDownloadAll.enabled = false
            self.buttonDownloadAll.selected = true
            self.showView(self.buttonSettings) // hide
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                frame.presenter!.download()
                dispatch_async(dispatch_get_main_queue(), {
                    self.shipListView.reloadData()
                    self.activity.stopAnimating()
                    self.buttonDownloadAll.enabled = true
                    self.buttonDownloadAll.selected = false
                })
            })
            self.handleAnimationScene()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func about(sender: UIButton) {
        var alert = frame.presenter!.createAboutAlert()
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

