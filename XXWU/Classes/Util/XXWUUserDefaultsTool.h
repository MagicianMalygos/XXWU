//
//  XXWUUserDefaultsTool.h
//  XXWU
//
//  Created by zcp on 2019/1/3.
//  Copyright © 2019 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

// 常量
/// 本地通知弹窗信息
extern NSString * const kClockLocationAlertKey;
/// 快速选择时间
extern NSString * const kClockQuickTimesKey;


/**
 用户偏好设置
 */
@interface XXWUUserDefaultsTool : NSObject

DEF_SINGLETON

@end


#pragma mark - UserDefaults

/// 保存
void SaveUserDefaults(id object, NSString *key);
/// 读取
id ReadUserDefaults(NSString *key);
/// 删除
void RemoveUserDefaults(NSString *key);
/// 同步
void UserDefaultsSync(void);
