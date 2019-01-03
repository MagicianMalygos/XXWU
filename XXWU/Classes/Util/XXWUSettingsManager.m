//
//  XXWUSettingsManager.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUSettingsManager.h"

// setting key
NSString * const kIsFirstLaunchAppKey   = @"is_first_launch_app";
NSString * const kSettingShakeKey       = @"setting_shake";
NSString * const kSettingDebugToolKey   = @"setting_debug_tool";

@implementation XXWUSettingsManager

@synthesize preference = _preference;

IMP_SINGLETON

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

- (void)readPreference {
    NSNumber *debug = @([ReadUserDefaults(kSettingDebugToolKey) boolValue]);
    NSNumber *shake = @([ReadUserDefaults(kSettingShakeKey) boolValue]);
    _preference = @{kSettingDebugToolKey: debug,
                    kSettingShakeKey: shake};
}

- (BOOL)isFirstOpenApp {
    return ![ReadUserDefaults(kIsFirstLaunchAppKey) boolValue];
}

- (void)setHasBeenLaunchedApp {
    if ([self isFirstOpenApp]) {
        SaveUserDefaults(@YES, kIsFirstLaunchAppKey);
        UserDefaultsSync();
    }
}

- (BOOL)isOpenDebugger {
    return [[[XXWUSettingsManager sharedInstance].preference objectForKey:kSettingDebugToolKey] boolValue];
}

- (BOOL)isOpenShake {
    return [[[XXWUSettingsManager sharedInstance].preference objectForKey:kSettingShakeKey] boolValue];
}

#pragma mark - getters and setters

- (NSDictionary *)preference {
    if (!_preference) {
        _preference = [NSDictionary dictionary];
    }
    return _preference;
}

@end
