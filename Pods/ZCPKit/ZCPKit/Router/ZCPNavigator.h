//
//  ZCPNavigator.h
//  Apartment
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 zcp. All rights reserved.
//

#import "ZCPBaseNavigator.h"
#import "ZCPGlobal.h"

// ----------------------------------------------------------------------
#pragma mark - 自定义导航器
// ----------------------------------------------------------------------
@interface ZCPNavigator : ZCPBaseNavigator

DEF_SINGLETON

#pragma mark - 初始化

/**
 读取viewMap文件中的控制器信息
 
 @param viewMapNamed viewMap文件名
 */
+ (void)readViewControllerMapWithViewMapNamed:(NSString *)viewMapNamed;

/**
 初始化根视图控制器

 @param rootViewController 根视图控制器
 */
- (void)setupRootViewController:(UIViewController *)rootViewController;

#pragma mark - jump

/**
 根据配置参数进行页面跳转
 
 @param identifier         视图控制器标识
 @param initParams         初始化方法参数
 @param propertyDictionary 属性字典
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary;

/**
 根据配置参数进行页面跳转

 @param identifier         视图控制器标识
 @param initParams         初始化方法参数
 @param propertyDictionary 属性字典
 @param retrospect         是否回溯
 @param animated           是否需要跳转动画
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary
                    retrospect:(BOOL)retrospect
                      animated:(BOOL)animated;

@end
