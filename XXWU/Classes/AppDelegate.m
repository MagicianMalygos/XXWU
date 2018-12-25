//
//  AppDelegate.m
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "AppDelegate.h"
#import "XXWUBaseDelegate.h"

@interface AppDelegate ()

/// 主框架负责的生命周期回调
@property (strong, nonatomic) id<UIApplicationDelegate> basicDelegate;
/// 业务方需要的生命周期回调
@property (strong, nonatomic) NSArray<id<UIApplicationDelegate>> *eventQueues;

@end

@implementation AppDelegate

@synthesize window = _window;

/**
 程序启动（app未启动时点击通知只会走这个方法，而不会走didReceiveLocalNotification）
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL launch = [self.basicDelegate application:application didFinishLaunchingWithOptions:launchOptions];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return launch;
}

/**
 app即将进入后台（后台：息屏、回到桌面、双击home停留）
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    [self.basicDelegate applicationWillResignActive:application];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate applicationWillResignActive:application];
    }
}

/**
 app已经进入后台（双击home后切换到其他app）
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.basicDelegate applicationDidEnterBackground:application];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate applicationDidEnterBackground:application];
    }
}

/**
 app将要进入前台
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.basicDelegate applicationWillEnterForeground:application];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate applicationWillEnterForeground:application];
    }
}

/**
 app已经进入前台
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.basicDelegate applicationDidBecomeActive:application];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate applicationDidBecomeActive:application];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.basicDelegate applicationWillTerminate:application];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate applicationWillTerminate:application];
    }
}

/**
 本地通知回调
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self.basicDelegate application:application didReceiveLocalNotification:notification];
    for (id<UIApplicationDelegate> delegate in self.eventQueues) {
        [delegate application:application didReceiveLocalNotification:notification];
    }
}

#pragma mark - getters and setters

- (NSArray<id<UIApplicationDelegate>> *)eventQueues {
    if (!_eventQueues) {
        // 各模块需要在此注册
        _eventQueues = [NSArray array];
    }
    return _eventQueues;
}

- (id<UIApplicationDelegate>)basicDelegate {
    if (!_basicDelegate) {
        _basicDelegate = [[XXWUBaseDelegate alloc] init];
    }
    return _basicDelegate;
}

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

@end
