//
//  TCRSA.h
//  TCCommon
//
//  Created by YongQing Gu on 8/13/12.
//  Copyright (c) 2012 TrueColor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCNRSA : NSObject

+ (NSData *)encrypt:(NSString *)string;

+ (NSString *)doOffset:(NSString *)string offset:(NSInteger)offset;

@end
