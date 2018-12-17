//
//  NSDateFormatter+Category.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "NSDateFormatter+Category.h"

#pragma mark - 日期格式化单例对象

static NSDateFormatter *staticDateFormatter;

@implementation NSDateFormatter (Category)

IMP_SINGLETON_C(staticDateFormatter)

@end
