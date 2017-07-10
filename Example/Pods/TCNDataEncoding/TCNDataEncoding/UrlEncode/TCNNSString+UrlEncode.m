//
//  NSString+UrlEncode.m
//  TCNDataCommon
//
//  Created by tangyiyuan on 2017/7/6.
//  Copyright © 2017年 tangyiyuan. All rights reserved.
//

#import "TCNNSString+UrlEncode.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#import "sys/utsname.h"

@implementation NSString(UrlEncode)

- (NSString *)md5 {
  const char *cStr = [self UTF8String];
  unsigned char result[16];
  CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

- (NSString *)urlEncode {
  return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
  return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                                       (NULL, (CFStringRef)self, NULL,
                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                        CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSString *)urlDecode {
  return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                      CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

// 把这个字符串当做一个URL地址，往后面追加一个新的查询参数，把新生成的字符串作为返回值返回出来
- (NSString *)stringByAppendingUrlQueryParameter:(NSString *)key value:(NSString *)value {
  key = [key urlEncodeUsingEncoding:NSUTF8StringEncoding];
  value = [value urlEncodeUsingEncoding:NSUTF8StringEncoding];
  NSString* queryString = [key stringByAppendingFormat:@"=%@", value];
  if ([self isContains:queryString]) return self;
  if ([self isContains:@"?"]){
    return [self stringByAppendingFormat:@"&%@", queryString];
  }else{
    return [self stringByAppendingFormat:@"?%@", queryString];
  }
}

// 把这个字符串当做一个URL地址，获取到某一个查询参数的值
- (NSString *)urlQueryParameterValueForKey:(NSString *)key {
  NSString *queryString = [NSString stringWithFormat:@"?%@=", key];
  NSInteger start = [self rangeOfString:queryString].location;
  if(start == NSNotFound) {
    queryString = [NSString stringWithFormat:@"&%@=", key];
    start = [self rangeOfString:queryString].location;
  }
  if (start != NSNotFound) { // 找到了
    NSRange searchRange = NSMakeRange(start + queryString.length, self.length - start - queryString.length);
    NSInteger end = [self rangeOfString:@"&"
                                options:NSCaseInsensitiveSearch
                                  range:searchRange].location;
    if (end == NSNotFound) end = self.length;
    return [self substringWithRange:NSMakeRange(start + queryString.length, end - start - queryString.length)];
  }else { // 如果没有找到，尝试把key值进行urlencode之后再查询
    NSString *newKey = [key urlEncodeUsingEncoding:NSUTF8StringEncoding];
    if (![newKey isEqualToString:key]){
      return [self urlQueryParameterValueForKey:newKey];
    }else{
      return nil;
    }
  }
}

- (BOOL)isContains:(NSString *)aString {
  if(!aString) return false;
  NSRange aRange = [self rangeOfString:aString];
  return aRange.location != NSNotFound;
}

- (BOOL)isEndsWith:(NSString *)aString {
  NSRange aRange = [self rangeOfString:aString options:NSBackwardsSearch];
  return aRange.location == [self length] - [aString length];
}

- (BOOL)isStartsWith:(NSString *)aString {
  NSRange aRange = [self rangeOfString:aString];
  return aRange.location == 0;
}

@end
