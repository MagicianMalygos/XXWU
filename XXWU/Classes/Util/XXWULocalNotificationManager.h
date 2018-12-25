//
//  XXWULocalNotificationManager.h
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 本地通知管理器
 */
@interface XXWULocalNotificationManager : NSObject

DEF_SINGLETON_C(defaultManager)

/**
 接收到本地通知。实现AppDelegate中的该方法，然后进行分发
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

@end

NS_ASSUME_NONNULL_END
