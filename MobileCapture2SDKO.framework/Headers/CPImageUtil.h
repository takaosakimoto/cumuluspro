//
//  CPImageUtil.h
//  MobileCapture2SDKO
//
//  Created by PF Olthof on 06/05/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPImageUtil : NSObject

+ (void)convertImages:(NSArray *)imagePaths toTIFF:(NSString *)tiffPath withKey:(NSString *)key;

+ (long)convertTiff:(NSString *)tiffPath toPDF:(NSString *)pdfPath;

@end
