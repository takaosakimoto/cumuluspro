//
//  FinishController.swift
//  MobileCapture2SDKTest
//
//  Created by Carsten Houweling on 20-04-16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

class FinishController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var newButton: UIButton!
    
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        newButton.layer.masksToBounds = true
        newButton.layer.cornerRadius = 40
    }
    
    @IBAction func newDocument(sender: AnyObject) {
        let cc = appDelegate.clientConnector
        
        // remove document page files
        cc.removeDocumentState(cc.currentDocumentStateUniqueId)
        
        cc.createDocumentState(true)
        // select frontside document type
        for i in 0 ..< cc.currentDocumentTypesCount {
            if cc.currentDocumentTypeName(i) == appDelegate.FIRST_DOCUMENT_NAME {
                cc.selectDocumentTypeIndex(i, finished: { (error) in
                    dispatch_async(dispatch_get_main_queue(), { 
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                        self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
                    })
                })
                
                break
            }
        }
    }
}
