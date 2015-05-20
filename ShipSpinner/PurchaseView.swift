//
//  PurchaseView.swift
//  ShipSpinner
//
//  Created by James Tan on 5/20/15.
//  Copyright (c) 2015 Axon Flux. All rights reserved.
//

import UIKit

class PurchaseView: UIViewController {

  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func launchWeb(sender: UIButton) {
    
  }

  @IBAction func dismissPurchase(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion:nil)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
