//
//  ViewController.swift
//  ShipSpinner
//
//  Created by James Tan on 11/16/14.
//  Copyright (c) 2014 Axon Flux. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myscene: SCNView!
    
    class var shared : ViewController {
        struct Static {
            static let instance : ViewController = ViewController()
        }
        return Static.instance
    }
    struct frame {
        static var presenter : Presenter? = nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        myscene.scene = SCNScene(named: "kushdae.scnassets/kush_cloakedfighter")
        myscene.allowsCameraControl = true;
        
        if frame.presenter == nil {
            NSLog("ERROR")
            return
        }
        frame.presenter?.getHello()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

