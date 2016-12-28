//
//  ViewController.swift
//  MobileCapture2SDKTest
//
//  Created by Carsten Houweling on 19-04-16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit
import MobileCapture2SDK

class CaptureContainerController: UIViewController {
    enum CameraButtonState : Int {
        case camera = 0, crop
    }
    
    //
    // Determine mode for auto-snap and crop:
    //
    
    let disableDetectBoundaries = false
    let disableAutoSnap = false
    let disableCrop = true
    
    //
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var cameraViewController: CPCameraViewController!
    var processingController: ProcessingController!
    
    var frontScanNotificationReceived = false
    var backScanFinished = false
    
    var documentStateUniqueIdFront: String? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var cameraContainer: UIView!

    let overlayView = OverlayView(frame: CGRectMake(0, 0, 0, 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate.clientConnector.createDocumentState(true)
        
        cameraButton.layer.masksToBounds = true
        cameraButton.layer.cornerRadius = 30
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let navigationBarHeight = 70
        let whiteTopPanelHeight: Int32 = 70
        
        let insetHorizontal = 20
        //let insetVertical = 90
        
        let verticalSize = (cameraContainer.frame.size.width - 2.0 * CGFloat(insetHorizontal)) * 0.63 // ID Card is 85,60x53,98 thus a factor of 0,63
        
        let insetVertical = Int((cameraContainer.frame.size.height - 140.0 - verticalSize) / 2.0)
        
        cameraViewController.insetTop = CGFloat(whiteTopPanelHeight + insetVertical)
        cameraViewController.insetBottom = CGFloat((140 - ((Int32(view.frame.height) - navigationBarHeight) - Int32(cameraViewController.view.frame.height)))) + CGFloat(insetVertical)
        cameraViewController.insetHorizontal = CGFloat(insetHorizontal)

        cameraViewController.cropViewGapTop = whiteTopPanelHeight + insetVertical
        cameraViewController.cropViewGapBottom = (140 - ((Int32(view.frame.height) - navigationBarHeight) - Int32(cameraViewController.view.frame.height))) + insetVertical

        if disableCrop {
            cameraViewController.cropViewGapLeft = Int32(insetHorizontal)
            cameraViewController.cropViewGapRight = Int32(insetHorizontal)
        }
        
        // let overlayView = OverlayView(frame: CGRectMake(0, 0, cameraContainer.frame.size.width, cameraContainer.frame.size.height))
        overlayView.frame = CGRectMake(0, 0, cameraContainer.frame.size.width, cameraContainer.frame.size.height)
        overlayView.start = CGPoint(x: insetHorizontal, y: Int(cameraViewController.insetTop))
        overlayView.end = CGPoint(x: Int(cameraViewController.view.frame.width) - insetHorizontal, y: Int(cameraViewController.view.frame.height - cameraViewController.insetBottom))
        cameraContainer.addSubview(overlayView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("CaptureContainerController memory warning")
    }
    
    @IBAction func cameraButtonClick(sender: AnyObject) {
        if cameraButton.tag == CameraButtonState.camera.rawValue {
            cameraViewController.takePicture { (foundPage) in
                if !self.disableCrop {
                    self.startCrop()
                } else {
                    //
                    // alternatively, if cropping is not used, call imageTaken directly instead of startCrop:
                    //
                    self.imageTaken()
                }
            }
        } else {
            imageTaken()
            endCrop()
        }
//        self.performSegueWithIdentifier("processingSegue", sender: self)
//
//        self.processingController.performSegueWithIdentifier("indexingSegue", sender: self)
//        self.processingController.performSegueWithIdentifier("ageerrorsegue", sender: self)
        
        
    }
    
    func startCrop() {
        cameraButton.tag = CameraButtonState.crop.rawValue;
        
        cameraViewController.stopCamera()
        cameraViewController.stopAppActivationCameraListener()
        
        cameraViewController.showCrop()
        
        self.cameraButton.setTitle("\u{E3BE}", forState: .Normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CaptureContainerController.endCrop as (CaptureContainerController) -> () -> ()))
    }
    
    func endCrop() {
        endCrop(startCamera: true)
    }
    
    func endCrop(startCamera startCamera: Bool) {
        // reset UI to camera
        cameraButton.tag = CameraButtonState.camera.rawValue;
        
        navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        
        if (startCamera) {
            cameraViewController.startCamera()
        }
        
        cameraViewController.startAppActivationCameraListener()
        
        cameraViewController.hideAndClearCrop()
        
        cameraViewController.resetBorderDetection()
        
        self.cameraButton.setTitle("\u{E3B0}", forState: .Normal)
    }
    
    func imageTaken() {
        cameraButton.enabled = false

        cameraViewController.cropAndAddPage(appDelegate.clientConnector)
        
        let cc = appDelegate.clientConnector
        
        // First capture the front, then the back.
        if cc.selectedDocumentTypeName == appDelegate.FIRST_DOCUMENT_NAME {
            // Front upload notification callback
            cc.registerNotificationsFetchedListener("front-listener") { (notifications) in
                cc.removeNotificationsFetchedListener("front-listener")
                
                self.frontScanNotificationReceived = true
                
                if self.backScanFinished {
                    self.uploadBack()
                }
            }
            
            documentStateUniqueIdFront = cc.currentDocumentStateUniqueId
            
            if let value = NSUserDefaults.standardUserDefaults().stringForKey("emailaddress") {
                cc.selectedDocumentSetFieldValue("EmailAddress", value: value)
            }
            
            // Upload front
            cc.upload(documentStateUniqueIdFront!, progressHandler: { (progress) in
                print("IDFront progress: \(progress)")
            }, finished: { error, response in
                if error != nil {
                    print("IDFront upload error: \(error)")
                } else {
                    print("IDFront upload response: \(response)")
                }
            })
            
            // Create a new document state
            cc.createDocumentState(true)
            
            // select backside document type
            for i in 0 ..< cc.currentDocumentTypesCount {
                if cc.currentDocumentTypeName(i) == appDelegate.SECOND_DOCUMENT_NAME {
//                    cc.selectedDocumentTypeIndex = i
                    cc.selectDocumentTypeIndex(i, finished: { (error) in
                        dispatch_async(dispatch_get_main_queue(), {
                            self.cameraButton.enabled = true
                            self.titleLabel.text = "Identitätskarte fotografieren Rückseite:"
                            
                            // restart the capture process
                            self.cameraViewController.resetBorderDetection()
                        })           
                    })
                    
                    break
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("processingSegue", sender: self)
            }

            if frontScanNotificationReceived {
                uploadBack()
            } else {
                backScanFinished = true
            }
        }
    }

    func uploadBack() {
        let cc = appDelegate.clientConnector
        
        // Back upload notification callback
        cc.registerNotificationsFetchedListener("back-listener") { (notifications) in
            cc.removeNotificationsFetchedListener("back-listener")
            
            print("Last name back: \(cc.selectedDocumentFieldValue("LastNameB"))")
            print("First name back: \(cc.selectedDocumentFieldValue("FirstNameB"))")
            print("IsMinor back: \(cc.selectedDocumentFieldValue("IsMinor"))")
            print("DateofBIRTH: \(cc.selectedDocumentFieldValue("DateOfBirth"))")
            var year = 0
            if let birthdate = cc.selectedDocumentFieldValue("DateOfBirth") {
                if !birthdate.isEmpty {
                    let parseFormatter = NSDateFormatter()
                    parseFormatter.dateFormat = "yyMMdd"
                    
                    let date = parseFormatter.dateFromString(birthdate)
                    
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    formatter.locale = NSLocale(localeIdentifier: "de_DE")
                    year = self.yearsBetweenDates(formatter.stringFromDate(date!))
                    
//                    birthdateTextField.text = formatter.stringFromDate(date!)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if cc.selectedDocumentFieldValue("IsValidDocumentF") != "true" || cc.selectedDocumentFieldValue("IsValidDocumentB") != "true" {
                    self.processingController.performSegueWithIdentifier("failedSegue", sender: self)
                } else {
                    if (year > 18){
                        self.processingController.performSegueWithIdentifier("indexingSegue", sender: self)
                    } else {
                        self.processingController.performSegueWithIdentifier("ageerrorsegue", sender: self)
                    }
                    
                }
            })
        }
        
        cc.selectedDocumentSetFieldValue("DocumentIdF", value: cc.documentFieldValue(documentStateUniqueIdFront!, name: "_documentId")!)
        cc.selectedDocumentSetFieldValue("Product", value: product.capitalizedString)
        
        // remove document image files
        cc.removeDocumentState(self.documentStateUniqueIdFront!)
        
        self.documentStateUniqueIdFront = nil;
        
        // Upload back
        cc.upload(cc.currentDocumentStateUniqueId, progressHandler: { (progress) in
            
            print("IDBack progress: \(progress)")
            
        }, finished: { error, response in
            if error != nil {
                print("IDBack upload error: \(error)")
            } else {
                print("IDBack upload response: \(response)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.cameraButton.enabled = true
                    self.titleLabel.text = "Identitätskarte fotografieren Vorderseite:"
                    self.frontScanNotificationReceived = false
                    self.backScanFinished = false
                })
            }
        })
    }
    
    func yearsBetweenDates(birthDate: String) -> Int{
        let f:NSDateFormatter = NSDateFormatter()
        f.dateFormat = "dd.MM.yyyy"
        f.locale = NSLocale(localeIdentifier: "de_DE")
        let now = f.stringFromDate(NSDate())
        let startDate = f.dateFromString(birthDate)
        let endDate = f.dateFromString(now)
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let calendarunits = NSCalendarUnit.Year
        let dateComponents = calendar.components(calendarunits, fromDate: startDate!, toDate: endDate!, options: [])
        let year = abs(dateComponents.year)
        return year
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "camera":
            cameraViewController = segue.destinationViewController as! CPCameraViewController
            
            cameraViewController.showDetectedBoundaries = !disableDetectBoundaries // do not show red / green borders
            
            if disableCrop {
                // cameraViewController.takePictureSetsCropCorners = false

                cameraViewController.borderCornerIndicatorsMatchColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 1.0)
                //cameraViewController.borderCornerIndicatorsNoMatchColor = UIColor(red: 0.3, green: 0.3, blue: 0.5, alpha: 1.0)
                cameraViewController.borderCornerIndicatorsNoMatchColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                cameraViewController.borderCornerIndicatorsMatchColor = UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0) // show corner edge indicator green if page is valid
            }
            
            cameraViewController.showDetectedBoundaries = false

            if disableAutoSnap {
                // cameraViewController.borderCornerIndicatorsVisible = false
            } else {
                cameraViewController.autoSnap = {
                    self.cameraViewController.takePicture { (foundPage) in
                        if !self.disableCrop {
                            self.startCrop()
                        } else {
                            //
                            // alternatively, if cropping is not used, call imageTaken directly instead of startCrop:
                            //
                            self.imageTaken()
                        }
                    }
                }
            }
            
            cameraViewController.noAccessToCamera = {
                print("no access to camera")
            }
        case "processingSegue":
            processingController = segue.destinationViewController as! ProcessingController
        default:
            break
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

