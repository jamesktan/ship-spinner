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
    
    // Views
    @IBOutlet weak var shipListView : UITableView!
    @IBOutlet weak var shipDetailView : UIView!
    @IBOutlet weak var settingView : UIView!
    var views : NSArray? = nil
    
    let spinKey = "spinRoundRound"
    let transTime = 0.33
    var wallpaperID = ""
    var shipID = ""
    var rotate = false
    
    
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
        shipID = frame.presenter!.idForLastShip()
        wallpaperID = frame.presenter!.idForLastWallpaper()
        rotate = frame.presenter!.shouldRotate()
        
        loadWallpaper(wallpaperID)
        loadShipData(shipID)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadShipData(id : NSString) {
        
        // Labels
        var shipInfo = frame.presenter!.getShip(id)
        l_name.text = shipInfo.0
        l_class.text = shipInfo.1
        l_role.text = shipInfo.2
        tv_description.text = shipInfo.3
        
        // Model
        myscene.scene = SCNScene(named: shipInfo.4)
        
        // Spin
        (rotate) ?
            myscene.scene?.rootNode.addAnimation(frame.presenter!.createSpin(), forKey: spinKey) :
            myscene.scene?.rootNode.removeAnimationForKey(spinKey)
    }
    
    func loadWallpaper(id : NSString) {
        var image = frame.presenter!.getWallpaper(id)
        wallpaper.image = image.0
        wallpaper.contentMode = image.1
    }
    
    // TableViewDelegate Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var details = frame.presenter!.getListDisplayDetails(indexPath)
        var cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: details.0)
        cell.textLabel?.text = details.1 //friendlyName
        cell.imageView?.image = details.2 //image
        return UITableViewCell()
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
        var view : UIView = views!.objectAtIndex(sender.tag) as UIView
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
        wallpaperID = frame.presenter!.getNextBackground(wallpaperID)
        loadWallpaper(wallpaperID)
        frame.presenter!.setWallpaper(wallpaperID)
    }
    
    @IBAction func changeRotate(sender: UIButton) {
        sender.selected ? frame.presenter!.setRotate(false) : frame.presenter!.setRotate(true)
        sender.selected = !sender.selected
    }
    
    @IBAction func downloadShips() {
        frame.presenter!.download()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

