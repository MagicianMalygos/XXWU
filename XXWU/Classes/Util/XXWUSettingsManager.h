//
//  XXWUSettingsManager.h
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

// setting key
/// 首次启动appkey
extern NSString * const kIsFirstLaunchAppKey;
/// 摇一摇
extern NSString * const kSettingShakeKey;
/// 调试工具
extern NSString * const kSettingDebugToolKey;

NS_ASSUME_NONNULL_BEGIN

@interface XXWUSettingsManager : NSObject

DEF_SINGLETON

@property (nonatomic, strong, readonly) NSDictionary *preference;

/**
 初始化
 */
- (void)setup;
/**
 读取设置信息
 */
- (void)readPreference;

/**
 是否首次启动app
 */
- (BOOL)isFirstOpenApp;
/**
 设置已启动过app
 */
- (void)setHasBeenLaunchedApp;


/**
 是否开启调试工具
 */
- (BOOL)isOpenDebugger;
/**
 是否开启摇一摇
 */
- (BOOL)isOpenShake;

@end

NS_ASSUME_NONNULL_END
