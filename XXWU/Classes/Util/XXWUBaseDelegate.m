//
//  XXWUBaseDelegate.m
//  XXWU
//
//  Created by zcp on 2018/12/25.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUBaseDelegate.h"
#import "XXWULocalNotificationManager.h"

@implementation XXWUBaseDelegate

@synthesize window = _window;

/**
 程序启动（app未启动时点击通知只会走这个方法，而不会走didReceiveLocalNotification）
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // initialize
    [ZCPURLHelper setAppURLScheme:@"xxwu"];
    
    // view map
    [ZCPNavigator readViewControllerMapWithViewMapNamed:@"xxwuViewMap"];
    // vc stack
    UINavigationController *nav = [[ZCPControllerFactory sharedInstance] generateCustomStack];
    [[ZCPNavigator sharedInstance] setupRootViewController:nav];
    // window
    self.window = [UIApplication sharedApplication].delegate.window;
    self.window.rootViewController = [ZCPNavigator sharedInstance].rootViewController;
    [self.window makeKeyAndVisible];
    
    // setting
    [[XXWUSettingsManager sharedInstance] setup];
    [[XXWUSettingsManager sharedInstance] readPreference];
    [DebugManager defaultManager].alwaysShowStatusBall = [[XXWUSettingsManager sharedInstance] isOpenDebugger];
    [[XXWUSettingsManager sharedInstance] setHasBeenLaunched];
    
    // register local notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
    }
    
    // 分发本地通知
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        [[XXWULocalNotificationManager defaultManager] application:application didReceiveLocalNotification:localNotification];
    }
    return YES;
}

/**
 app即将进入后台（后台：息屏、回到桌面、双击home停留）
 */
- (void)applicationWillResignActive:(UIApplication *)application {
}

/**
 app已经进入后台（双击home后切换到其他app）
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
}

/**
 app将要进入前台
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 更新app设置
    [[XXWUSettingsManager sharedInstance] readPreference];
    [DebugManager defaultManager].alwaysShowStatusBall = [[XXWUSettingsManager sharedInstance] isOpenDebugger];
}

/**
 app已经进入前台
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
}

/**
 app将要终止
 */
- (void)applicationWillTerminate:(UIApplication *)application {
}

/**
 本地通知回调
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 分发本地通知
    [[XXWULocalNotificationManager defaultManager] application:application didReceiveLocalNotification:notification];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[ZCPNavigationController class]]) {
        ZCPNavigationController *nav = (ZCPNavigationController *)rootVC;
        UIViewController *topVC = nav.topViewController;
        
        if ([topVC shouldAutorotate]) {
            return [topVC supportedInterfaceOrientations];
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end






@interface ZCPViewController (Orientation)

@end

@implementation ZCPViewController (Orientation)

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

@interface ZCPNavigationController (Orientation)

@end

@implementation ZCPNavigationController (Orientation)

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end

@interface ZCPTabBarController (Orientation)

@end

@implementation ZCPTabBarController (Orientation)

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
