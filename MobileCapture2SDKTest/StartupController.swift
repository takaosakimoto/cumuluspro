//
//  StartupController.swift
//  MobileCapture2SDKTest
//
//  Created by Carsten Houweling on 19-04-16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit
import MobileCapture2SDK

class StartupController: UINavigationController, UIGestureRecognizerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewWillAppear(animated: Bool) {
        // self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        setNavigationBarHidden(true, animated: animated)
        interactivePopGestureRecognizer?.enabled = true
        interactivePopGestureRecognizer?.delegate = self
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        
//        super.viewWillAppear(animated)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let view = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, UIApplication.sharedApplication().statusBarFrame.height))
//        view.backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
//        self.view.addSubview(view)

        appDelegate.startupController = self
        
        login();
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }

    func login() {
        
        let cc = appDelegate.clientConnector
        
        cc.loadConfiguration(appDelegate.CONFIGURATION_UNIQUEID, finished: { (error, docTypesJSON) in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    print(error)
                } else {
                    // There is more than 1 document type available
                    if docTypesJSON != nil {
                        
                        // select frontside document type
                        for i in 0 ..< cc.currentDocumentTypesCount {
                            if cc.currentDocumentTypeName(i) == self.appDelegate.FIRST_DOCUMENT_NAME {
                                cc.selectDocumentTypeIndex(i, finished: { (error) in
                                    dispatch_async(dispatch_get_main_queue(), { 
                                        self.performSegueWithIdentifier("productSegue", sender: self)
                                    })
                                })
                                break
                            }
                        }
                    } else {
                        print("No doctypes")
                    }
                }
            })
        })
        
    }
}
