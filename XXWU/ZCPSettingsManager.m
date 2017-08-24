
//
//  ZCPSettingsManager.m
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "ZCPSettingsManager.h"

// setting key
NSString * const IS_FIRSTOPENAPP        = @"is_firstopenapp";
NSString * const SETTINGID_SHAKE        = @"settingsid_shake";
NSString * const SETTINGID_DEBUGTOOL    = @"settingsid_debugtool";

@implementation ZCPSettingsManager

@synthesize preference = _preference;

IMP_SINGLETON(ZCPSettingsManager)

- (void)setup {
    if ([self isFirstOpenApp]) {
        // 初始化Settings
        NSString *settingsBundle    = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        NSDictionary *settings      = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        NSArray *preferences        = [settings objectForKey:@"PreferenceSpecifiers"];
        for(NSDictionary *prefSpecification in preferences) {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if (key) {
                [[NSUserDefaults standardUserDefaults] setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)readingPreference {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *debug = [userDefaults objectForKey:SETTINGID_DEBUGTOOL];
    NSNumber *shake = [userDefaults objectForKey:SETTINGID_SHAKE];
    
    _preference = @{SETTINGID_DEBUGTOOL: debug,
                    SETTINGID_SHAKE: shake};
}

- (BOOL)isFirstOpenApp {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:IS_FIRSTOPENAPP]) {
        return NO;
    }
    return YES;
}

- (void)setFirstOpenApp {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1"  forKey:IS_FIRSTOPENAPP];
    [defaults synchronize];
}

#pragma mark - getters and setters

- (NSDictionary *)preference {
    if (!_preference) {
        _preference = [NSDictionary dictionary];
    }
    return _preference;
}

@end
