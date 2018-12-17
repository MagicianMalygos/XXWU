//
//  ZCPIndicator.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPIndicator.h"

@interface ZCPIndicator()
@property (nonatomic, assign) NSInteger loadingCount;
@end

@implementation ZCPIndicator

IMP_SINGLETON

#pragma mark - public methods
- (void)showIndicator {
    // 只在状态栏显示菊花
    [self showNetworkActivityIndicatorInStatusBar];
}

- (void)dismissIndicator {
    //隐藏状态栏菊花
    [self dismissNetworkActivityIndicator];
}

- (void)stopLoading {
    self.loadingCount --;
    if (self.loadingCount == 0) {
        [self dismissIndicator];
    }
}

#pragma mark - internal methods
- (void)showNetworkActivityIndicatorInStatusBar {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)dismissNetworkActivityIndicator {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
