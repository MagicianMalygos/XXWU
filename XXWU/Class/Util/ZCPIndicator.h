//
//  ZCPIndicator.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 指示控制类，比如loading，activity等
@interface ZCPIndicator : NSObject

DEF_SINGLETON

// ----------------------------------------------------------------------
#pragma mark - 显示/隐藏加载指示
// ----------------------------------------------------------------------

/**
 显示activity 指示
 */
- (void)showIndicator;

/**
 隐藏activity
 */
- (void)dismissIndicator;

/**
 隐藏activity
 */
- (void)stopLoading;

@end
