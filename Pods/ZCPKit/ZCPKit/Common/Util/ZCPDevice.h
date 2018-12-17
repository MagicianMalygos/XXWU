//
//  ZCPDevice.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/1.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCPDevice : NSObject

// ----------------------------------------------------------------------
#pragma mark - statistics
// ----------------------------------------------------------------------

/**
 国家
 */
+ (NSString *)countryString;
/**
 语言
 */
+ (NSString *)languageString;
/**
 系统版本
 */
+ (NSString *)osVersionString;
/**
 时区
 */
+ (NSString *)timezoneString;
/**
 分辨率
 */
+ (NSString *)resolutionString;
/**
 运营商
 */
+ (NSString *)carrierString;


// ----------------------------------------------------------------------
#pragma mark - permission
// ----------------------------------------------------------------------

+ (BOOL)isCameraAvailable;

+ (BOOL)hasAuthorization;

+ (BOOL)isQRCodeScanAvailable;

// ----------------------------------------------------------------------
#pragma mark - baseinfo
// ----------------------------------------------------------------------

/**
 openudid
 */
+ (NSString *)getDeviceOpenUDID;

/**
 设备型号
 */
+ (NSString *)deviceModel;

/**
 是否ipad
 */
+ (BOOL)isIpad;

/**
 是否是 iphone plus
 */
+ (BOOL)isIphonePlus;

/**
 设备mac地址，iOS 7以后获取不到
 */
+ (NSString *)deviceMacAddressString;

/**
 应用广告标示
 */
+ (NSString *)appIdentfierForAdvert;
+ (NSString *)appIdentfierForVendor;


// ----------------------------------------------------------------------
#pragma mark - security
// ----------------------------------------------------------------------

/**
 判断App是否被破解
 */
+ (BOOL)isPirated;

/**
 判断设备是否越狱
 */
+ (BOOL)isJailbroken;

@end
