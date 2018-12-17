//
//  XXWUSettingsManager.h
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

// setting key
extern NSString * const IS_FIRSTOPENAPP;        // 是否首次开启APP
extern NSString * const SETTINGID_SHAKE;        // 摇一摇
extern NSString * const SETTINGID_DEBUGTOOL;    // 调试工具

NS_ASSUME_NONNULL_BEGIN

@interface XXWUSettingsManager : NSObject

DEF_SINGLETON

@property (nonatomic, strong, readonly) NSDictionary *preference;

- (void)setup;
- (void)readingPreference;

- (BOOL)isFirstOpenApp;
- (void)setFirstOpenApp;

@end

NS_ASSUME_NONNULL_END
