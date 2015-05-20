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
  
  @IBAction func buyRemastered(sender: AnyObject) {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.daledietrich.com"]];
    
    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.amazon.com/gp/product/B00TUIGLLU/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00TUIGLLU&linkCode=as2&tag=kawila-20&linkId=UUZFVQIKRUJP3R7H")!)

  }
  
  @IBAction func buyCollector(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.amazon.com/gp/product/B00K6ZUOQE/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00K6ZUOQE&linkCode=as2&tag=kawila-20&linkId=5QY2TZU3QTDVE6KT")!)

  }
  
  @IBAction func buyArt(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.amazon.com/gp/product/0985902248/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0985902248&linkCode=as2&tag=kawila-20&linkId=QMWLXOCEG3RSZP7B")!)

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
