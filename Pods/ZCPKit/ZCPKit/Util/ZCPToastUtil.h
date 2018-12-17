//
//  PANoticeUtil.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCPGlobal.h"

// ----------------------------------------------------------------------
#pragma mark - 吐司提示工具类
// ----------------------------------------------------------------------
@interface ZCPToastUtil : NSObject

DEF_SINGLETON

/**
 显示吐司
 信息为空显示空视图
 
 @param msg        要显示信息
 */
+ (void)showToast:(NSString *)msg;
/**
 显示吐司
 view为nil，则显示在keyWindow上
 
 @param msg        要显示信息
 @param view       要在哪个视图上添加
 */
+ (void)showToast:(NSString *)msg inView:(UIView *)view;
/**
 显示吐司
 
 @param msg        要显示信息
 @param view       要在哪个视图上添加
 @param duration   显示时间
 */
+ (void)showToast:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration;

/**
 显示吐司

 @param msg        要显示信息
 @param view       要在哪个视图上添加
 @param duration   显示时间
 @param completion 完成执行块
 */
+ (void)showToast:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration completion:(void(^)(void))completion;
/**
 显示吐司
 
 @param customView 自定义的显示视图
 @param view       要在哪个视图上添加
 @param duration   显示时间
 @param completion 完成执行块
 */
+ (void)showToastWithCustomView:(UIView *)customView inView:(UIView *)view duration:(NSTimeInterval)duration completion:(void(^)(void))completion;

@end
