//
//  TCNViewController.m
//  TCNDeviceInfo
//
//  Created by 周高举 on 07/06/2017.
//  Copyright (c) 2017 周高举. All rights reserved.
//

#import "TCNViewController.h"
#import <TCNDeviceInfo/TCNDeviceInfo.h>

@interface TCNViewController ()

@end

@implementation TCNViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  NSLog(@"设备的UUID是:%@", [TCNDeviceInfo clientUUID]);
  NSLog(@"应用的渠道号是:%@", [TCNDeviceInfo clientSource]);
  NSLog(@"设备的名字是:%@", [TCNDeviceInfo hardwareDeviceName]);
  NSLog(@"应用的版本是:%@", [TCNDeviceInfo clientVersion]);
  NSLog(@"系统的数字版本号是:%@", [TCNDeviceInfo systemVersion]);
  NSLog(@"系统的名称是:%@", [TCNDeviceInfo clientOS]);
  NSLog(@"应用的包名是:%@", [TCNDeviceInfo bundleIdentifier]);
  NSLog(@"设备的IMSI是:%@", [TCNDeviceInfo clientIMSI]);
  NSLog(@"运营商信息是:%@", [TCNDeviceInfo clientCarrier]);
  NSLog(@"设备的当前国家代码是:%@", [TCNDeviceInfo clientLocal]);
  NSLog(@"屏幕分辨率是:%@", [TCNDeviceInfo deviceResolution]);
  NSLog(@"用户是否限制了广告追踪:%@", @([TCNDeviceInfo isLimitAdTracking]));
  NSLog(@"设备的广告标识是:%@", [TCNDeviceInfo identifierForAdvertising]);
  NSLog(@"设备是否已经越狱:%@", @([TCNDeviceInfo isDeviceJailbroken]));
  NSLog(@"当前设备屏幕的DPI是:%@", [TCNDeviceInfo dpi]);
  NSLog(@"前屏幕的宽度是:%@", [TCNDeviceInfo width]);
  NSLog(@"当前屏幕的高度是:%@", [TCNDeviceInfo height]);
}

@end
