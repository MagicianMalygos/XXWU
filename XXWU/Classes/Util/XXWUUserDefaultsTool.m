//
//  XXWUUserDefaultsTool.m
//  XXWU
//
//  Created by zcp on 2019/1/3.
//  Copyright © 2019 zcp. All rights reserved.
//

#import "XXWUUserDefaultsTool.h"

/// 本地通知弹窗信息
NSString * const kClockLocationAlertKey = @"kClockLocationAlertKey";
/// 快速选择时间
NSString * const kClockQuickTimesKey = @"kClockQuickTimesKey";

@implementation XXWUUserDefaultsTool

IMP_SINGLETON

#pragma mark - setup

+ (void)initialize {
    if ([[XXWUSettingsManager sharedInstance] isFirstOpenApp]) {
        [[XXWUUserDefaultsTool sharedInstance] setupClockInfo];
    }
}

- (void)setupClockInfo {
    NSString *title = @"闹钟⏰";
    NSString *body = @"叮铃铃~~🔔";
    SaveUserDefaults(@{@"title": title, @"body": body}, kClockLocationAlertKey);
    SaveUserDefaults(@"30,45,60,75,90", kClockQuickTimesKey);
}

@end

#pragma mark - UserDefaults

void SaveUserDefaults(id object, NSString *key) {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

void UserDefaultsSync() {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

id ReadUserDefaults(NSString *key) {
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!result) {
        return @"";
    }
    return result;
}

void RemoveUserDefaults(NSString *key) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
