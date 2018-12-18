//
//  XXWUSettingsManager.h
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

// setting key
extern NSString * const HAS_BEEN_LAUNCHED;      // 是否已经启动过app
extern NSString * const SETTINGID_SHAKE;        // 摇一摇
extern NSString * const SETTINGID_DEBUGTOOL;    // 调试工具

NS_ASSUME_NONNULL_BEGIN

@interface XXWUSettingsManager : NSObject

DEF_SINGLETON

@property (nonatomic, strong, readonly) NSDictionary *preference;

- (void)setup;
- (void)readPreference;

- (BOOL)isFirstOpenApp;
- (void)setHasBeenLaunched;

- (BOOL)isOpenDebugger;

@end

NS_ASSUME_NONNULL_END
