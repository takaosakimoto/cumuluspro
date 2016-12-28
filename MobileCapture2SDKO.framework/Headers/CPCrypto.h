//
//  CPCrypto.h
//  MobileCapture2SDKO
//
//  Created by PF Olthof on 03/05/16.
//  Copyright © 2016 CumulusPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPCrypto : NSOperation

+ (NSError *)encrypt:(NSInputStream *)inputStream toOutputStream:(NSOutputStream *)outputStream withKey:(NSString *)key;
+ (NSError *)decrypt:(NSInputStream *)inputStream toOutputStream:(NSOutputStream *)outputStream withKey:(NSString *)key;

@end
