//
//  OverlayView.swift
//  MobileCapture2SDKTest
//
//  Created by PF Olthof on 30/08/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

import UIKit

public class OverlayView : UIView {
    public var start: CGPoint!
    public var end: CGPoint!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        
        // transparency layer
        
        CGContextSaveGState(context)
        
        CGContextBeginTransparencyLayer(context, nil)
        
        CGContextSetLineWidth(context, 1.0)
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 1.0)
        
        //-----------------------------------------------------------------
        // Create complex path as intersection of subpath 1 with subpath 2
        //-----------------------------------------------------------------
        
        // Create subpath 1 with the whole image size
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.4);
        CGContextAddRect(context, self.bounds);
        // Create subpath 2 which cuts a page area from the subpath 1
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, end.x, start.y)
        CGContextAddLineToPoint(context, end.x, end.y)
        CGContextAddLineToPoint(context, start.x, end.y)
        CGContextAddLineToPoint(context, start.x, start.y)
        CGContextEOFillPath(context)
        
        CGContextEndTransparencyLayer(context)
    }
}
