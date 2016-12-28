//
//  EmailController.swift
//  MobileCapture2SDKTest
//
//  Created by PF Olthof on 30/08/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

class EmailController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        if let value = NSUserDefaults.standardUserDefaults().stringForKey("emailaddress") {
            emailTextField.text = value
            
            if value.isEmpty {
                emailTextField.becomeFirstResponder()
            }
        } else {
            emailTextField.becomeFirstResponder()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    @IBAction func save(sender: AnyObject) {
        if let value = emailTextField.text {
            if !value.isEmpty {                
                NSUserDefaults.standardUserDefaults().setValue(value, forKey: "emailaddress")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
        
        self.performSegueWithIdentifier("cameraSegue", sender: self)
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
