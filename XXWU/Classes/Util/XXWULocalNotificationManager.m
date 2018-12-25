//
//  XXWULocalNotificationManager.m
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWULocalNotificationManager.h"
#import <AVFoundation/AVFoundation.h>

@interface XXWULocalNotificationManager ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVPlayer *player2;

@end

@implementation XXWULocalNotificationManager

IMP_SINGLETON_C(defaultManager)

/// 接收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 如果当前app在前台，在当前页弹窗播放声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"voice.mp3"ofType:nil];
        NSURL *url = [NSURL URLWithString:path];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [self.player prepareToPlay];
        [self.player play];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.player stop];
        }]];
        [[ZCPNavigator sharedInstance].topViewController presentViewController:alert animated:YES completion:nil];
    } else {
        // 如果app在后台通过推送进入app，则进入闹钟页
        [[ZCPNavigator sharedInstance] gotoViewWithIdentifier:APPURL_VIEW_IDENTIFIER_CLOCK queryForInit:nil propertyDictionary:nil retrospect:YES animated:YES];
    }
}

@end
