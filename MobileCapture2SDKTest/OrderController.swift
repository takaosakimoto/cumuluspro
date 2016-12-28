//
//  OrderController.swift
//  MobileCapture2SDKTest
//
//  Created by PF Olthof on 31/08/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

public class OrderController : UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        productImageView.image = UIImage(named: product + "_order")
    }
    
    @IBAction func upload(sender: AnyObject) {
        appDelegate.clientConnector.upload(appDelegate.clientConnector.currentDocumentStateUniqueId, progressHandler: { (progress) in
            
            print("\(progress)")
            
            }, finished: { error, response in
                if error != nil {
                    print("Re-upload error: \(error)")
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("finishSegue", sender: self)
                })
            }
        })
    }

    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
