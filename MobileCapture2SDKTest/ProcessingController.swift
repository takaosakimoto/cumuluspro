//
//  ProcessingController.swift
//  MobileCapture2SDKTest
//
//  Created by Carsten Houweling on 20-04-16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit
import MobileCapture2SDK

class ProcessingController: UIViewController {
    
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
