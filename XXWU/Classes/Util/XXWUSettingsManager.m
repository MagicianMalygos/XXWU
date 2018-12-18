//
//  XXWUSettingsManager.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUSettingsManager.h"

// setting key
NSString * const HAS_BEEN_LAUNCHED      = @"has_been_launched";
NSString * const SETTINGID_SHAKE        = @"settingsid_shake";
NSString * const SETTINGID_DEBUGTOOL    = @"settingsid_debugtool";

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *debug = @([[userDefaults objectForKey:SETTINGID_DEBUGTOOL] boolValue]);
    NSNumber *shake = @([[userDefaults objectForKey:SETTINGID_SHAKE] boolValue]);
    
    _preference = @{SETTINGID_DEBUGTOOL: debug,
                    SETTINGID_SHAKE: shake};
}

- (BOOL)isFirstOpenApp {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ![[defaults objectForKey:HAS_BEEN_LAUNCHED] boolValue];
}

- (void)setHasBeenLaunched {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults objectForKey:HAS_BEEN_LAUNCHED] boolValue]) {
        [defaults setObject:@YES forKey:HAS_BEEN_LAUNCHED];
        [defaults synchronize];
    }
}

- (BOOL)isOpenDebugger {
    return [[[XXWUSettingsManager sharedInstance].preference objectForKey:SETTINGID_DEBUGTOOL] boolValue];
}

#pragma mark - getters and setters

- (NSDictionary *)preference {
    if (!_preference) {
        _preference = [NSDictionary dictionary];
    }
    return _preference;
}

@end
