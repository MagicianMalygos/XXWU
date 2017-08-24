//
//  DebugManager.h
//  Demo
//
//  Created by 朱超鹏 on 2017/7/26.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DebugStatusBallView;
@class DebugConsoleLogView;

void DebugLog(NSString *format, ...);

@interface DebugManager : NSObject

@property (nonatomic, strong) DebugStatusBallView *statusBallView;
@property (nonatomic, strong) DebugConsoleLogView *consoleLogView;

@property (nonatomic, assign, getter=isAlwaysShowStatusBall) BOOL alwaysShowStatusBall;

+ (instancetype)defaultManager;
+ (void)log:(NSString *)log;

@end
