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
    
    // initialize
    [ZCPURLHelper setAppURLScheme:@"xxwu"];
    
    /// view map
    [ZCPNavigator readViewControllerMapWithViewMapNamed:@"xxwuViewMap"];
    /// vc stack
    UINavigationController *nav = [[ZCPControllerFactory sharedInstance] generateCustomStack];
    [[ZCPNavigator sharedInstance] setupRootViewController:nav];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ZCPNavigator sharedInstance].rootViewController;
    [self.window makeKeyAndVisible];
    
    // setting
    [[XXWUSettingsManager sharedInstance] setup];
    [self setupSetting];
    [[XXWUSettingsManager sharedInstance] setFirstOpenApp];
    
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
    [[XXWUSettingsManager sharedInstance] readingPreference];
    BOOL openDebugger = [[[XXWUSettingsManager sharedInstance].preference objectForKey:SETTINGID_DEBUGTOOL] boolValue];
    [DebugManager defaultManager].alwaysShowStatusBall = openDebugger;
}

@end
