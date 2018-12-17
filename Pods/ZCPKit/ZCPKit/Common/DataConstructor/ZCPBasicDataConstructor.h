//
//  ZCPBasicDataConstructor.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------
#pragma mark - 基础数据构造器
// ----------------------------------------------------------------------
@interface ZCPBasicDataConstructor : NSObject

// 用来存放构造出来的数据
@property (nonatomic, strong)   NSMutableArray  *items;
@property (nonatomic, weak)     id              responder;

// 构造数据方法，由子类来实现此方法
- (void)constructData;

@end
