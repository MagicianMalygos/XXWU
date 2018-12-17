//
//  ZCPVCDataModel.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPDataModel.h"

// ----------------------------------------------------------------------
#pragma mark - 视图控制器模型基类
// ----------------------------------------------------------------------
@interface ZCPVCDataModel : NSObject

// ViewController 类
@property (nonatomic, strong)   Class               vcClass;
// ViewController 初始化方法
@property (nonatomic, strong)   NSValue             *vcInitMethod;
// ViewController 实例化方法
@property (nonatomic, strong)   NSValue             *vcInstanceMethod;
// 初始化方法参数
@property (nonatomic, strong)   NSMutableDictionary *queryForInitMethod;
// 实例化方法参数
@property (nonatomic, strong)   NSMutableDictionary *queryForInstanceMethod;
// 属性字典
@property (nonatomic, strong)   NSDictionary        *propertyDictionary;
// 标识
@property (nonatomic, copy)     NSString            *identifier;

@end
