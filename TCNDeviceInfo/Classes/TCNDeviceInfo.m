//
//  TCNDeviceInfo.m
//  TCNDeviceInfo
//
//  Created by zhou on 2017/7/6.
//  Copyright © 2017年 truecolor. All rights reserved.
//

#import "TCNDeviceInfo.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <TCNDataEncoding/TCNNSString+UrlEncode.h>

static NSString * const kTCDeviceInfoUdidKey = @"TCCLICK_UDID";
static NSString * const kTCDeviceInfoUdidPastboardKey = @"TCCLICK_UDID_PASTBOARD";

@implementation TCNDeviceInfo

+ (NSString *)clientUUID {
  static NSString *udid = nil;
  if (!udid) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    udid = (NSString *) [defaults objectForKey:kTCDeviceInfoUdidKey];
    if (udid == nil) {
      udid = [self UDIDFromPastboard];
      if (!udid) {
        udid = [self generateFreshOpenUDID];
        [self saveUDIDToPastboard:udid];
      }
      [defaults setObject:udid forKey:kTCDeviceInfoUdidKey];
    }
    else {
      [self saveUDIDToPastboard:udid];
    }
  }
  return udid;
}

+ (NSString *)UDIDFromPastboard {
  UIPasteboard *pastboard = [UIPasteboard pasteboardWithName:kTCDeviceInfoUdidPastboardKey create:NO];
  if (pastboard && pastboard.string){
    return pastboard.string;
  }
  return nil;
}

+ (void)saveUDIDToPastboard:(NSString *)udid {
  UIPasteboard* pastboard = [UIPasteboard pasteboardWithName:kTCDeviceInfoUdidPastboardKey create:YES];
  pastboard.string = udid;
}

+ (NSString *)generateFreshOpenUDID {
  // 先按照 identifierForVendor 的方式去取 UDID，如果不成功再生成一个随机的 UUID
  UIDevice* device = [UIDevice currentDevice];
  if ([device respondsToSelector:@selector(identifierForVendor)]){
    NSString* uniqueIdentifier = [[device performSelector:@selector(identifierForVendor)] UUIDString];
    if (uniqueIdentifier && [uniqueIdentifier isKindOfClass:NSString.class]){
      return [uniqueIdentifier md5];
    }
  }
  
  CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
  const char *cStr = CFStringGetCStringPtr(cfstring, CFStringGetFastestEncoding(cfstring));
  CFRelease(cfstring);
  CFRelease(uuid);
  NSString *string = [NSString stringWithCString:cStr encoding:NSUTF8StringEncoding];
  return [string md5];
}

+ (NSString*)clientVersion {
  static NSString *version = nil;
  if (version == nil || [version isEqualToString:@""]) {
    version = [@"" stringByAppendingString:
               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
  }
  return version ? version : @"";
}

+ (NSString*)systemVersion {
  static NSString *version = nil;
  if (version == nil || [version isEqualToString:@""]) {
    version = [[UIDevice currentDevice] systemVersion];
  }
  return version;
}

+ (NSString *)clientOS {
  static NSString *os = nil;
  if (os == nil) {
    os = [@"iOS" stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
  }
  return os ? os : @"";
}

+ (NSString *)clientLocal {
  static NSString *local = nil;
  if (local == nil || [local isEqualToString:@""]) {
    local = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
  }
  return local;
}

+ (NSString *)clientSource {
  static NSString *source = nil;
  if (source == nil || [source isEqualToString:@""]) {
    NSString* sourceFile = [[NSBundle mainBundle] pathForResource:@"configuration_source" ofType:@"txt"];
    source = [[NSString stringWithContentsOfFile:sourceFile encoding:NSUTF8StringEncoding error:nil]
              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  }
  return source ? source : @"AppStore";
}

+ (NSString *)hardwareDeviceName {
  static NSString *deviceName = nil;
  if (deviceName == nil || [deviceName isEqualToString:@""]) {
    struct utsname u;
    uname(&u);
    deviceName = [NSString stringWithCString:u.machine encoding:NSUTF8StringEncoding];
  }
  return deviceName ? deviceName : @"";
}

+ (NSString *)bundleIdentifier {
  static NSString *identifier = nil;
  if (identifier == nil || [identifier isEqualToString:@""]) {
    identifier = [[NSBundle mainBundle] bundleIdentifier];
  }
  return identifier ? identifier : @"";
}

+ (NSString *)clientLanguage {
  static NSString *language = nil;
  if (language == nil || [language isEqualToString:@""]) {
    if([[NSLocale preferredLanguages] count] > 0) {
      language = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
  }
  return language ? language : @"";
}

+ (NSString *)clientIMSI {
  static NSString *imsi = nil;
  if (imsi == nil || [imsi isEqualToString:@""]) {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if ([carrier mobileCountryCode] && [carrier mobileNetworkCode]) {
      imsi = [NSString stringWithFormat:@"%@%@", [carrier mobileCountryCode], [carrier mobileNetworkCode]];
    }
  }
  return imsi ? imsi : @"";
}

+ (NSString *)clientNetworkStatus {
  struct sockaddr_in zeroAddress;
  bzero(&zeroAddress, sizeof(zeroAddress));
  zeroAddress.sin_len = sizeof(zeroAddress);
  zeroAddress.sin_family = AF_INET;
  zeroAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
  SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault,
                                                                        (const struct sockaddr*)&zeroAddress);
  SCNetworkReachabilityFlags flags = 0;
  SCNetworkReachabilityGetFlags(ref, &flags);
  CFRelease(ref);
  
  if (flags & kSCNetworkReachabilityFlagsTransientConnection) return @"wifi";
  if (flags & kSCNetworkReachabilityFlagsConnectionRequired) return @"wifi";
  if (flags & kSCNetworkReachabilityFlagsIsDirect) return @"wifi";
  if (flags & kSCNetworkReachabilityFlagsIsWWAN) return @"cellnetwork";
  return @"unknow";
}

+ (NSString *)clientCarrier {
  static NSString *carrier = nil;
  if (carrier == nil || [carrier isEqualToString:@""]) {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    carrier = [info.subscriberCellularProvider carrierName];
  }
  return carrier ? carrier : @"";
}

+ (NSString *)deviceResolution {
  static NSString *resolution = nil;
  if (resolution == nil || [resolution isEqualToString:@""]) {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    resolution = [NSString stringWithFormat:@"%.0f,%.0f",screenSize.width,screenSize.height];
  }
  return resolution ? resolution : @"";
}

+ (BOOL)isLimitAdTracking {
  return ![ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled;
}

+ (NSString *)identifierForAdvertising {
  static NSString *identifierForAD = nil;
  if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
    if (identifierForAD == nil || [identifierForAD isEqualToString:@""]) {
      NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
      identifierForAD = [IDFA UUIDString];
    }
    return identifierForAD ? identifierForAD : @"";
  }
  return @"";
}

+ (BOOL)isDeviceJailbroken {
  static bool isChecked = NO;
  static bool isJailbroken = NO;
  if (!isChecked) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
      isJailbroken = YES;
    }
    else if([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt"]) {
      isJailbroken = YES;
    }
  }
  return isJailbroken;
}

+ (NSString *)dpi {
  return @"1";
}

+ (NSString *)width {
  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  return [NSString stringWithFormat:@"%.0f", CGRectGetWidth(screenBounds)];
}

+ (NSString *)height {
  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  return [NSString stringWithFormat:@"%.0f", CGRectGetHeight(screenBounds)];
}

@end

@implementation TCNDeviceInfo (UniversalHTTPHeadersParameters)

+ (NSDictionary<NSString *, NSString *> *)universalHTTPHeadersParameters {
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  
  [parameters setValue:[self clientSource] forKey:@"Client-Source"];
  [parameters setValue:[self clientVersion] forKey:@"Client-Version"];
  [parameters setValue:[self clientUUID] forKey:@"Client-Uid"];
  [parameters setValue:[self hardwareDeviceName] forKey:@"Client-Device"];
  [parameters setValue:@"Apple" forKey:@"Client-Brand"];
  [parameters setValue:[self clientOS] forKey:@"Client-Os"];
  [parameters setValue:[self clientLocal] forKey:@"Client-Local"];
  [parameters setValue:[self clientLanguage] forKey:@"Client-Language"];
  [parameters setValue:[self clientIMSI] forKey:@"Client-Imsi"];
  [parameters setValue:[self isDeviceJailbroken] ? @"true" : @"false" forKey:@"Client-Jailbroken"];
  
  return [parameters copy];
}

@end

@implementation TCNDeviceInfo (UniversalURLParameters)

+ (NSDictionary<NSString *, NSString *> *)universalURLParameters {
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  
  [parameters setValue:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] forKey:@"_"];
  [parameters setValue:[self clientUUID] forKey:@"_udid"];
  [parameters setValue:[self clientSource] forKey:@"_channel"];
  [parameters setValue:[self hardwareDeviceName] forKey:@"_model"];
  [parameters setValue:@"Apple" forKey:@"_brand"];
  [parameters setValue:[self systemVersion] forKey:@"_ov"];
  [parameters setValue:[self clientVersion] forKey:@"_v"];
  [parameters setValue:[self bundleIdentifier] forKey:@"_package"];
  [parameters setValue:[self clientLocal] forKey:@"_locale"];
  [parameters setValue:[self clientCarrier] forKey:@"_carrier"];
  [parameters setValue:[self deviceResolution] forKey:@"_resolution"];
  [parameters setValue:[self identifierForAdvertising] forKey:@"_idfa"];
  
  return [parameters copy];
}

@end

@implementation TCNDeviceInfo (UniversalADTrackParameters)

+ (NSDictionary *)universalAdTrackParameters {
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  
  [parameters setObject:[self clientUUID] forKey:@"udid"];
  [parameters setObject:[self bundleIdentifier] forKey:@"ios_identifier"];
  [parameters setObject:[self clientSource] forKey:@"channel"];
  [parameters setObject:[self hardwareDeviceName] forKey:@"model"];
  [parameters setObject:[self systemVersion] forKey:@"os_version"];
  [parameters setObject:[self clientVersion] forKey:@"app_version"];
  [parameters setObject:[self clientCarrier] forKey:@"carrier"];
  [parameters setObject:[self deviceResolution] forKey:@"resolution"];
  [parameters setObject:[self clientLocal] forKey:@"locale"];
  [parameters setObject:[self clientNetworkStatus] forKey:@"network"];
  [parameters setObject:@([self isDeviceJailbroken]) forKey:@"jailbroken"];
  [parameters setObject:[self identifierForAdvertising] forKey:@"idfa"];
  
  if ([self isLimitAdTracking]) {
    [parameters setObject:@YES forKey:@"is_limit_ad_tracking"];
  } else {
    // MARK:这里之前设置的值是NSNull，现在改为@NO，需要确定服务器可以正确处理
    [parameters setObject:@NO forKey:@"is_limit_ad_tracking"];
  }
  
  return [parameters copy];
}

@end

@implementation TCNDeviceInfo (UniversalNewTrackParameters)

+ (NSDictionary *)universalNewTrackParameters {
  NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
  
  [parameters setObject:[self clientUUID] forKey:@"udid"];
  [parameters setObject:[self clientSource] forKey:@"channel"];
  [parameters setObject:[self hardwareDeviceName] forKey:@"model"];
  [parameters setObject:[self systemVersion] forKey:@"os_version"];
  [parameters setObject:[self clientVersion] forKey:@"app_version"];
  [parameters setObject:[self clientCarrier] forKey:@"carrier"];
  [parameters setObject:[self deviceResolution] forKey:@"resolution"];
  [parameters setObject:[self clientLocal] forKey:@"locale"];
  [parameters setObject:[self clientNetworkStatus] forKey:@"network"];
  [parameters setObject:[self identifierForAdvertising] forKey:@"idfa"];
  [parameters setObject:[self bundleIdentifier] forKey:@"package_name"];
  
  return [parameters copy];
}

@end
