//
//  ZCPNetworkCheck.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/1.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPNetworkCheck.h"

#define PING_URL_HOST       @"www.baidu.com"

@interface ZCPNetworkCheck ()

@property (nonatomic, strong) Reachability *networkReacher;
@property (nonatomic, assign) NetworkStatus networkStatus;

@end

@implementation ZCPNetworkCheck

IMP_SINGLETON

// ----------------------------------------------------------------------
#pragma mark - init
// ----------------------------------------------------------------------

- (instancetype)init {
    if (self = [super init]) {
        [self observeNetwork];
    }
    return self;
}

// ----------------------------------------------------------------------
#pragma mark - public
// ----------------------------------------------------------------------

/// 返回网络类型
- (NetworkStatus)getNetworkStatus {
    return _networkStatus;
}

/// 判断是否连网
- (BOOL)hasNetwork {
    if (self.networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

// ----------------------------------------------------------------------
#pragma mark - observe network change
// ----------------------------------------------------------------------

- (void)observeNetwork {
    if (self.networkReacher) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.networkReacher = [Reachability reachabilityWithHostName:PING_URL_HOST];
    [self.networkReacher startNotifier];
    
    self.networkStatus = ReachableViaWiFi;
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = [notification object];
    self.networkStatus  = reach.currentReachabilityStatus;
    if (self.networkStatus == NotReachable) {
        ZCPLog(@"似乎已断开与互联网的连接");
    } else {
        ZCPLog(@"似乎已断开与互联网的连接");
    }
}

@end
