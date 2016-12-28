//
//  CPCropView.h
//  MobileCapture2
//
//  Created by PF Olthof on 12-06-15.
//  Copyright (c) 2015 CumulusPro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CornerTypeLeftTop,
    CornerTypeRightTop,
    CornerTypeLeftBottom,
    CornerTypeRightBottom
} CornerType;

@interface CornerView : UIImageView
{
    CGPoint centerOffset;
    CGPoint pushCenter;
    CornerType cornerType;
    BOOL isSelected;
    UIImage *imageNormal;
    UIImage *imageSelected;
}

@property (nonatomic, assign) CGPoint centerOffset;
@property (nonatomic, assign) CGPoint pushCenter;
@property (nonatomic, assign) CornerType cornerType;
@property (nonatomic, assign) BOOL selected;

- (id)initWithImage:(UIImage *)normal andSelected:(UIImage *)selected;

@end

#pragma mark -

@interface CPCropView : UIView
{
    UIImage *image;
    CGLayerRef layerBottom; // contains image preview
    CGFloat minScale;
    CGFloat scale;
    
    CGPoint startLocation;
    
    CornerView *corner[4];
    CornerView *corverDragged;
}

@property (nonatomic, retain) UIImage *image;

@property int gapTop;
@property int gapLeft;
@property int gapRight;
@property int gapBottom;

@property BOOL disableZoom;

- (id)initWithFrame:(CGRect)frame;

- (void)getCorners:(CGPoint[4])points coordinates:(BOOL)inImage;
- (void)setCorners:(const CGPoint[4])points coordinates:(BOOL)inImage;

- (void)setDefaultPositionOfCorners;

- (CGRect)wholeImageRectInView;
- (CornerView *)nearestCornerView:(CGPoint)point;
- (CGPoint)getCornerPoint:(CornerView *)corner;
- (BOOL)correctCornerPosition:(CGPoint *)point corner:(CornerView *)aCorner;

- (CGPoint)convertFromViewToImagePt:(CGPoint)pt;
- (CGPoint)convertFromImageToViewPt:(CGPoint)pt;

@end
