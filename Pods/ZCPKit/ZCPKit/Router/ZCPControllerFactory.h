//
//  ZCPControlingCenter.h
//  Apartment
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCPGlobal.h"
@class ZCPVCDataModel;

// ----------------------------------------------------------------------
#pragma mark - 视图控制器工厂
// ----------------------------------------------------------------------
@interface ZCPControllerFactory : NSObject

DEF_SINGLETON

#pragma mark - 初始化

/**
 设置视图控制器模型字典，为生成控制器做准备

 @param vcDataModelDict 视图控制器模型字典（identifier : vcDataModel）
 */
- (void)setVCDataModelDict:(NSMutableDictionary *)vcDataModelDict;

#pragma mark - 生成控制器方法

/**
 通过控制器标识 生成 控制器模型

 @param identifier 控制器标识
 @return 控制器模型
 */
- (ZCPVCDataModel *)generateVCModelWithIdentifier:(NSString *)identifier;

/**
 通过控制器模型 生成 控制器对象

 @param vcDataModel 控制器模型
 @return 控制器对象
 */
- (UIViewController *)generateVCWithVCModel:(ZCPVCDataModel *)vcDataModel;

/**
 通过控制器标识 生成 控制器对象

 @param identifier 控制器标识
 @return 控制器对象
 */
- (UIViewController *)generateVCWithIdentifier:(NSString *)identifier;

#pragma mark - 控制器配置方法

/**
 根据控制器模型去设置控制器对象

 @param controller 控制器对象
 @param vcDataModel 控制器模型
 @param shouldCallInitMethod 是否响应init方法
 */
- (void)configController:(UIViewController *)controller withVCDataModel:(ZCPVCDataModel *)vcDataModel shouldCallInitMethod:(BOOL)shouldCallInitMethod;

#pragma mark - 自定义生成控制器栈方法

/**
 生成 Nav - Tab - VCs 控制器栈

 @return 控制器栈
 */
- (UINavigationController *)generate_Nav_Tab_VCs_Stack;

@end
