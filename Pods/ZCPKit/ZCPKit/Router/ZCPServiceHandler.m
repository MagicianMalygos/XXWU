//
//  ZCPServiceHandler.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPServiceHandler.h"

// ----------------------------------------------------------------------
#pragma mark - 统一处理app service请求
// ----------------------------------------------------------------------
@implementation ZCPServiceHandler

IMP_SINGLETON

// hello world
- (void)helloWorld:(NSDictionary *)params {
    NSLog(@"Hello World!");
}

@end

// ----------------------------------------------------------------------
#pragma mark - service处理结果类
// ----------------------------------------------------------------------
@implementation ZCPServiceResult

@end
