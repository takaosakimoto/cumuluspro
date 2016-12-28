//
//  CCOpenCVWrapper.h
//  MobileCapture2
//
//  Created by PF Olthof on 29-02-16.
//  Copyright © 2016 De Voorkant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPOpenCVWrapper : NSObject

@property BOOL detectCornersEnabled;

- (void)initOpenCVCameraWithView:(UIView *)view updateCorners:(void (^)(CGPoint, CGPoint, CGPoint, CGPoint, BOOL))updateCornersBlock noAccessForCamera:(void (^)())noAccessBlock;

- (void)stop;
- (void)start;
- (void)pause;

- (void)flashOn:(BOOL)on;

- (BOOL)cameraReady;

- (void)importPicture:(UIImage *)image finishedBlock:(void (^)(UIImage *, CGPoint[]))finishedBlock;
- (void)takePicture:(void (^)(UIImage *, CGPoint[]))finishedBlock;

- (UIImage *)cropImage:(UIImage *)image corners:(const CGPoint[])corners;

+ (CGFloat)matchPoint11:(CGPoint)point11 point12:(CGPoint)point12 point13:(CGPoint)point13 point14:(CGPoint)point14
            withPoint21:(CGPoint)point21 point22:(CGPoint)point22 point23:(CGPoint)point23 point24:(CGPoint)point24;

@end