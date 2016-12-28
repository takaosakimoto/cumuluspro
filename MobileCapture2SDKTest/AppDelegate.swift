//
//  AppDelegate.swift
//  MobileCapture2
//
//  Created by PF Olthof on 12-02-16.
//  Copyright © 2016 De Voorkant. All rights reserved.
//

import UIKit
import MobileCapture2SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate /*, GGLInstanceIDDelegate */ {
    var window: UIWindow?
    
//    var gcmSenderID: String?
//    var registrationOptions = [String: AnyObject]()
    
//    let GCM_APNS_SANDBOX = true
    
    let CONFIGURATION_UNIQUEID = "7ed2eee7-adeb-4e79-88b3-861c60637470" // Intrum Justitia CH PROD
    
    let FIRST_DOCUMENT_NAME = "IDFront"
    let SECOND_DOCUMENT_NAME = "IDBack"
    
    // MARK: Properties
    
    let clientConnector = ClientConnector(backgroundIdentifier: "com.cumuluspro.MobileCapture2SDKTest")
    
    var startupController: StartupController?
    var doctypesDict: [String: Int]?
    
    // MARK: Base functions
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {        
//        if let font = UIFont(name: "CenturyGothic", size: 18) {
//            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blackColor()]
//            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blackColor()], forState: .Normal)
//        }
        
        // Configure the Google context: parses the GoogleService-Info.plist, and initializes
        // the services that have entries in the file
//        var configureError:NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//        gcmSenderID = GGLContext.sharedInstance().configuration.gcmSenderID
//        
//        print("+ registering user notification settings")
//        
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
//        
//        let gcmConfig = GCMConfig.defaultConfig()
//        GCMService.sharedInstance().startWithConfig(gcmConfig)
        
        
        // clientConnector.debugNetRequest = true // DEBUG
        
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        fetchMessages()
        
        return true
    }
    
    var timer: dispatch_source_t!
    
    // fetch messages every 3 seconds / keeps the App working if notifications are not received
    func fetchMessages() {
        let queue = dispatch_queue_create("myTimer", nil);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 3 * NSEC_PER_SEC);
        
        dispatch_source_set_event_handler(timer) {
            dispatch_async(dispatch_get_global_queue(0, 0), {
                print("fetching messages")
                self.clientConnector.fetchMessages(self.clientConnector.currentDocumentStateUniqueId)
            })
        }
        
        dispatch_resume(timer)
    }
    
//    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
//        print("+ application did register for user notification settings")
//        
//        application.registerForRemoteNotifications()
//    }
//    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        print("+ application did register for remote notifications, deviceToken: \(deviceToken)")
//        
//        // Create a config and set a delegate that implements the GGLInstaceIDDelegate protocol.
//        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
//        instanceIDConfig.delegate = self
//        
//        // Start the GGLInstanceID shared instance with that config and request a registration
//        // token to enable reception of notifications
//        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
//        
//        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
//                               kGGLInstanceIDAPNSServerTypeSandboxOption:GCM_APNS_SANDBOX]
//        
//        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID, scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
//    }
//    
//    func onTokenRefresh() {
//        // A rotation of the registration tokens is happening, so the app needs to request a new token.
//        print("The GCM registration token needs to be changed.")
//        
//        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderID, scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: registrationHandler)
//    }
//    
//    func subscribeToTopic() {
//        if (clientConnector.deviceToken != nil) {
//            GCMPubSub.sharedInstance().subscribeWithToken(clientConnector.deviceToken, topic: "/topics/global", options: nil, handler: { (error) in
//                if let error = error {
//                    // Treat the "already subscribed" error more gently
//                    if error.code == 3001 {
//                        print("Already subscribed to /topics/global")
//                    } else {
//                        print("Subscription failed: \(error.localizedDescription)");
//                    }
//                } else {
//                    print("Subscribed to /topics/global");
//                }
//            })
//        }
//    }
//    
//    func registrationHandler(registrationToken: String!, error: NSError!) {
//        if (registrationToken != nil) {
//            print("Registration Token: \(registrationToken)")
//            self.clientConnector.registerDeviceToken(registrationToken)
//            
//            subscribeToTopic()
//        } else {
//            print("Registration to GCM failed with error: \(error.localizedDescription)")
//            
//            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
//            dispatch_after(delayTime, dispatch_get_main_queue(), {
//                self.onTokenRefresh()
//            })
//        }
//    }
//    
//    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//        print("+ application failed to register for remote notifications: \(error)")
//    }
//    
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        print("+ application didReceiveRemoteNotification \(userInfo)")
//        
//        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
//        
//        let documentStateUniqueId = userInfo["DocumentUniqueId"] as! String
//        clientConnector.fetchMessages(documentStateUniqueId)
//    }
    
    //    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //        print("+ application didReceiveRemoteNotification fetchCompletionHandler")
    //    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        clientConnector.backgroundTransferCompletionHandler = completionHandler
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        print("* applicationDidEnterBackground")
        
//        GCMService.sharedInstance().disconnect()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Connect to the GCM server to receive non-APNS notifications
//        GCMService.sharedInstance().connectWithHandler({(error:NSError?) -> Void in
//            if let error = error {
//                print("Could not connect to GCM: \(error.localizedDescription)")
//            } else {
//                print("Connected to GCM")
//                
//                self.subscribeToTopic()
//            }
//        })
        
        clientConnector.fetchMessages(clientConnector.currentDocumentStateUniqueId)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

