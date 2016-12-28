//
//  IndexingController.swift
//  MobileCapture2SDKTest
//
//  Created by Carsten Houweling on 20-04-16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit
import MobileCapture2SDK

class IndexingController: UITableViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var addressAdditionalTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    
//    @IBOutlet weak var birthdateTextField: UITextField!
//    
//    var datePickerView: UIDatePicker = UIDatePicker()
//    var dateflag: Bool = true
//    @IBAction func dateFieldEditing(sender: UITextField) {
//
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        dateflag = false
//        sender.inputView = datePickerView
//        datePickerView.addTarget(self, action: #selector(IndexingController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
//        
//    }
//    
//    func datePickerValueChanged(sender:UIDatePicker) {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//        dateFormatter.locale = NSLocale(localeIdentifier: "de_DE")
//        
//
//        birthdateTextField.text = dateFormatter.stringFromDate(sender.date)
//        if(!dateflag){
//            birthdateTextField.resignFirstResponder()
//            datePickerView.hidden = false
//            dateflag = true
//        }
//        
//    }
    override func viewDidLoad() {
        if let value = NSUserDefaults.standardUserDefaults().stringForKey("emailaddress") {
            emailTextField.text = value
        }
        
        if let sex = appDelegate.clientConnector.selectedDocumentFieldValue("Sex") {
            if !sex.isEmpty {
                sexTextField.text = sex == "M" ? "Männlich" : "Weiblich"
            }
        }
        
        firstnameTextField.text = appDelegate.clientConnector.selectedDocumentFieldValue("FirstNameF")
        lastnameTextField.text = appDelegate.clientConnector.selectedDocumentFieldValue("LastNameF")
        
//        if let birthdate = appDelegate.clientConnector.selectedDocumentFieldValue("DateOfBirth") {
//            if !birthdate.isEmpty {
//                let parseFormatter = NSDateFormatter()
//                parseFormatter.dateFormat = "yyMMdd"
//                
//                let date = parseFormatter.dateFromString(birthdate)
//                
//                let formatter = NSDateFormatter()
//                formatter.dateFormat = "dd.MM.yyyy"
//                formatter.locale = NSLocale(localeIdentifier: "de_DE")
//                
//                birthdateTextField.text = formatter.stringFromDate(date!)
//            }
//        }
        
//        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        
        sexTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        streetTextField.delegate = self
        addressAdditionalTextField.delegate = self
        zipcodeTextField.delegate = self
        cityTextField.delegate = self
        emailTextField.delegate = self
        telephoneTextField.delegate = self
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
//        
//        self.performSegueWithIdentifier("cameraSegue", sender: self)
    }
}
