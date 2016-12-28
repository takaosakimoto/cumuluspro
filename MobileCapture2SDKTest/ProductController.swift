//
//  ProductController.swift
//  MobileCapture2SDKTest
//
//  Created by PF Olthof on 30/08/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

var product = "laptop"

class ProductController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var laptopSelected: UIImageView!
    @IBOutlet weak var tabletSelected: UIImageView!
    @IBOutlet weak var smartphoneSelected: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
    }
    
    let image1View = UIImageView(image: UIImage(named: "laptop"))
    let image2View = UIImageView(image: UIImage(named: "tablet"))
    let image3View = UIImageView(image: UIImage(named: "smartphone"))

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        image1View.contentMode = .ScaleAspectFill
        image1View.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        
        image2View.contentMode = .ScaleAspectFill
        image2View.frame = CGRectMake(scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        
        image3View.contentMode = .ScaleAspectFill
        image3View.frame = CGRectMake(scrollView.frame.size.width * 2, 0, scrollView.frame.size.width, scrollView.frame.size.height)
        
        scrollView.addSubview(image1View)
        scrollView.addSubview(image2View)
        scrollView.addSubview(image3View)
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height)

        laptopSelected.image = UIImage(named: "page_selected")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        if (pageNumber == 0) {
            laptopSelected.image = UIImage(named: "page_selected")
            tabletSelected.image = UIImage(named: "page_not_selected")
            smartphoneSelected.image = UIImage(named: "page_not_selected")
            
            product = "laptop"
        } else if (pageNumber == 1) {
            laptopSelected.image = UIImage(named: "page_not_selected")
            tabletSelected.image = UIImage(named: "page_selected")
            smartphoneSelected.image = UIImage(named: "page_not_selected")
            
            product = "tablet"
        } else {
            laptopSelected.image = UIImage(named: "page_not_selected")
            tabletSelected.image = UIImage(named: "page_not_selected")
            smartphoneSelected.image = UIImage(named: "page_selected")
            
            product = "smartphone"
        }
    }
    
    @IBAction func selectDark(sender: AnyObject) {
        let x = CGFloat(0) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)

//        darkSelected.hidden = false
//        whiteSelected.hidden = true
    }
    
    @IBAction func selectWhite(sender: AnyObject) {
        let x = CGFloat(1) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)

//        darkSelected.hidden = true
//        whiteSelected.hidden = false
    }
}
