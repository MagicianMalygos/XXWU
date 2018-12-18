//
//  NSDate+Category.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+Category.h"
#import "NSString+Category.h"

@interface NSDate (String)

#pragma mark - 日期/字符串转换
/**
 字符串转换成日期 yyyy-MM-dd格式
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/**
 字符串转换成日期 yyyy-MM-dd HH:mm:ss格式
 */
+ (NSDate *)dateFromYDMHmsString:(NSString *)dateString;

/**
 字符串转换成日期 自定义格式
 */
+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)format;

/**
 转换成字符串 yyyy-MM-dd格式
 */
- (NSString *)toString;

/**
 转换成字符串 yyyy-MM-dd HH:mm:ss格式
 */
- (NSString *)toYDMHmsString;

/**
 转换成字符串 自定义格式
 */
- (NSString *)toStringWithDateFormat:(NSString *)format;

#pragma mark - 日期信息
/**
 获取星期 1~7
 */
- (NSUInteger)weekdayNumber;

@end
