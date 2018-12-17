//
//  ZCPNetworkCheck.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/1.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "ZCPGlobal.h"

// ----------------------------------------------------------------------
#pragma mark - 网络状况监听
// ----------------------------------------------------------------------
@interface ZCPNetworkCheck : NSObject

DEF_SINGLETON

/**
 返回网络类型
 */
- (NetworkStatus)getNetworkStatus;

/**
 判断是否连网
 */
- (BOOL)hasNetwork;

@end
