//
//  ZCPPackageInfo.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2017/11/27.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "ZCPPackageInfo.h"

@implementation ZCPPackageInfo

+ (NSString *)appPackageNameString {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleIdentifier"];
}

+ (NSString *)appDisplayNameString {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleDisplayName"];
}

+ (NSString *)appBuildVersionString {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleVersion"];
}

+ (NSString *)appVersionString {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return info[@"CFBundleShortVersionString"];
}

@end
