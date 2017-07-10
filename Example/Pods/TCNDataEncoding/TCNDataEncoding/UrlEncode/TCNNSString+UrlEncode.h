//
//  NSString+UrlEncode.h
//  TCNDataCommon
//
//  Created by tangyiyuan on 2017/7/6.
//  Copyright © 2017年 tangyiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlEncode)

- (NSString *)md5;

- (NSString *)urlEncode;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlDecode;

// 把这个字符串当做一个URL地址，往后面追加一个新的查询参数，把新生成的字符串作为返回值返回出来
- (NSString *)stringByAppendingUrlQueryParameter:(NSString *)key value:(NSString *)value;

// 把这个字符串当做一个URL地址，获取到某一个查询参数的值
- (NSString *)urlQueryParameterValueForKey:(NSString *)key;

@end
