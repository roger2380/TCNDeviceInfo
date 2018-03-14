//
//  TCNDeviceInfo.h
//  TCNDeviceInfo
//
//  Created by zhou on 2017/7/6.
//  Copyright © 2017年 truecolor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCNDeviceInfo : NSObject

/**
 获取设备的UUID
 
 @return 设备的UUID
 */
+ (NSString *)clientUUID;

/**
 获取应用的渠道号
 
 @return 应用的渠道号
 */
+ (NSString *)clientSource;

/**
 获取设备的型号信息 如 @"iPhone7,1"
 
 @return 设备的型号信息
 */
+ (NSString *)hardwareDeviceName;

/**
 获取应用的版本
 
 @return 应用的版本
 */
+ (NSString *)clientVersion;

/**
 获取系统的数字版本号 如 @"4.0"
 
 @return 系统的数字版本号
 */
+ (NSString*)systemVersion;

/**
 获取系统的名称 如 @"iOS8.1"
 
 @return 系统的名称
 */
+ (NSString *)clientOS;

/**
 获取应用的包名
 
 @return 应用的包名
 */
+ (NSString *)bundleIdentifier;

/**
 获取系统当前的语言
 
 @return 系统当前的语言
 */
+ (NSString *)clientLanguage;

/**
 获取设备的IMSI
 
 @return 设备的IMSI
 */
+ (NSString *)clientIMSI;


/**
 获取当前的网络状态 如@"wifi", @"cellnetwork", @"unknow"

 @return 当前的网络状态
 */
+ (NSString *)clientNetworkStatus;

/**
 获取当前的运营商信息
 
 @return 当前的运营商信息
 */
+ (NSString *)clientCarrier;

/**
 获取设备的当前国家代码 如 @"CN",@"US"
 
 @return 设备的当前国家代码
 */
+ (NSString*)clientLocal;

/**
 获取设备的屏幕分辨率 格式为@"640.0,480.0"
 
 @return 设备的屏幕分辨率
 */
+ (NSString *)deviceResolution;


/**
 用户是否限制了广告追踪
 如果返回结果为YES 那么通过identifierForAdvertising获取的标识符将会是无效的
 
 @return 是否限制了广告追踪
 */
+ (BOOL)isLimitAdTracking;

/**
 获取设备的广告标识
 
 如果用户限制了广告更跟踪
 这里获取的标识将会是无效的
 
 @return 设备的广告标识
 */
+ (NSString *)identifierForAdvertising;


/**
 获取当前设备是否已经越狱
 
 @return 当前设备是否已经越狱
 */
+ (BOOL)isDeviceJailbroken;

/**
 获取当前设备屏幕的DPI
 目前暂时会返回固定值@"1"
 
 @return 当前设备屏幕的DPI 目前暂时会返回固定值@"1"
 */
+ (NSString *)dpi;

/**
 获取当前屏幕的宽度
 
 @return 当前屏幕的宽度
 */
+ (NSString *)width;

/**
 获取当前屏幕的高度
 
 @return 当前屏幕的高度
 */
+ (NSString *)height;

@end

@interface TCNDeviceInfo (UniversalHTTPHeadersParameters)

/**
 放在http请求头部的通用参数，当前方法返回的字典中没有用户的token字段
 
 @return 参数字典
 */
+ (NSDictionary<NSString *, NSString *> *)universalHTTPHeadersParameters;

@end

@interface TCNDeviceInfo (UniversalURLParameters)

/**
 放在请求的url部分的通用参数，当前方法返回的字典中没有用户的token字段

 @return 参数字典
 */
+ (NSDictionary<NSString *, NSString *> *)universalURLParameters;

@end

@interface TCNDeviceInfo (UniversalADTrackParameters)

/**
 用于广告追踪的通用参数，一般放在HTTP请求的body部分
 
 @return 参数字典
 */
+ (NSDictionary *)universalAdTrackParameters;

@end

@interface TCNDeviceInfo (UniversalNewTrackParameters)

/**
 漫咖新的数据追踪使用的通用参数字典
 文档:http://admin.en.dailymanga.mobi/documents/api?page=Track
 
 @return 参数字典
 */
+ (NSDictionary *)universalNewTrackParameters;

@end


