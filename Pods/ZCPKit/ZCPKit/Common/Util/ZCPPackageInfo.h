//
//  ZCPPackageInfo.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2017/11/27.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

//统计渠道
typedef enum {
    PAAppChannelAppStore=100,//appstore
}PAAppChannel;

#define kURLSchemeIdnentifier                           @"PingAnHaoFang"

@interface ZCPPackageInfo : NSObject

// 应用包名
+ (NSString *)appPackageNameString;
// 应用显示名称
+ (NSString *)appDisplayNameString;
// 编译版本号
+ (NSString *)appBuildVersionString;
// 应用版本号
+ (NSString *)appVersionString;

@end
