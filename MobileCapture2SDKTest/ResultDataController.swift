//
//  ResultDataController.swift
//  MobileCapture2SDKTest
//
//  Created by PF Olthof on 30/08/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

class ResultDataController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var indexingController: IndexingController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(sender: AnyObject) {
        if let value = indexingController.sexTextField.text {
            if value.isEmpty {
                appDelegate.clientConnector.selectedDocumentSetFieldValue("Sex", value: "")
            } else if !value.hasPrefix("M") {
                appDelegate.clientConnector.selectedDocumentSetFieldValue("Sex", value: "F")
            } else {
                appDelegate.clientConnector.selectedDocumentSetFieldValue("Sex", value: "M")
            }
        }
        
//        let year = yearsBetweenDates(indexingController.birthdateTextField.text!)

        
        appDelegate.clientConnector.selectedDocumentSetFieldValue("FirstNameF", value: indexingController.firstnameTextField.text!)
        appDelegate.clientConnector.selectedDocumentSetFieldValue("LastNameF", value: indexingController.lastnameTextField.text!)
        
        
        
        appDelegate.clientConnector.selectedDocumentSetFieldValue("LastNameF", value: indexingController.lastnameTextField.text!)
        
        
//        if(year >= 18){
//            appDelegate.clientConnector.selectedDocumentSetFieldValue("DateOfBirth", value: indexingController.birthdateTextField.text!)
            self.performSegueWithIdentifier("orderSegue", sender: self)
//        }else {
//            self.performSegueWithIdentifier("datefailedSegue", sender: self)
//        }

    }
    
//    func yearsBetweenDates(birthDate: String) -> Int{
//        let f:NSDateFormatter = NSDateFormatter()
//        f.dateFormat = "dd.MM.yyyy"
//        f.locale = NSLocale(localeIdentifier: "de_DE")
//        let now = f.stringFromDate(NSDate())
//        let startDate = f.dateFromString(birthDate)
//        let endDate = f.dateFromString(now)
//        let calendar: NSCalendar = NSCalendar.currentCalendar()
//        let calendarunits = NSCalendarUnit.Year
//        let dateComponents = calendar.components(calendarunits, fromDate: startDate!, toDate: endDate!, options: [])
//        let year = abs(dateComponents.year)
//        return year
//    
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? IndexingController where segue.identifier == "indexingSegue" {
            self.indexingController = viewController
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}
