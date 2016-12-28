//
//  WelcomeController.swift
//  MobileCapture2SDKTest
//
//  Created by PF Olthof on 07/10/2016.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

public class WelcomeController: UIViewController {
    override public func viewWillAppear(animated: Bool) {
        // self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
//        navigationController!.setNavigationBarHidden(true, animated: animated)
                
        super.viewWillAppear(animated)
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

//        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
}
