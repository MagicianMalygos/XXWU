//
//  ZCPSettingsManager.h
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// setting key
extern NSString * const IS_FIRSTOPENAPP;        // 是否首次开启APP
extern NSString * const SETTINGID_SHAKE;        // 摇一摇
extern NSString * const SETTINGID_DEBUGTOOL;    // 调试工具

@interface ZCPSettingsManager : NSObject

DEF_SINGLETON

@property (nonatomic, strong, readonly) NSDictionary *preference;

- (void)setup;
- (void)readingPreference;

- (BOOL)isFirstOpenApp;
- (void)setFirstOpenApp;

@end

NS_ASSUME_NONNULL_END
