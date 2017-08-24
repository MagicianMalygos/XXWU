//
//  AppDelegate.m
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "AppDelegate.h"
#import "ZCPWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window            = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window                 = window;
    ZCPWebViewController *root  = [[ZCPWebViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];
    window.rootViewController   = nav;
    [root loadUrl:@"mobile.xxwu.me"];
    
    [window makeKeyAndVisible];
    
    [[ZCPSettingsManager sharedInstance] setup];
    [self setupSetting];
    [[ZCPSettingsManager sharedInstance] setFirstOpenApp];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self setupSetting];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - private

- (void)setupSetting {
    [[ZCPSettingsManager sharedInstance] readingPreference];
    BOOL openDebugger = [[[ZCPSettingsManager sharedInstance].preference objectForKey:SETTINGID_DEBUGTOOL] boolValue];
    [DebugManager defaultManager].alwaysShowStatusBall = openDebugger;
}

@end
