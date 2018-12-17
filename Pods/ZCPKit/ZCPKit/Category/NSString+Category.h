//
//  NSString+Category.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+Category.h"
#import "NSDate+Category.h"

@interface NSString (Category)

#pragma mark - 
/**
 判断是否包含特定字符串
 */
- (BOOL)contains:(NSString *)str;

/**
 转换为json对象
 */
- (id)JSONObject;

#pragma mark - 日期/字符串转换
/**
 日期转换成字符串 yyyy-MM-dd格式
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 日期转换成字符串 yyyy-MM-dd HH-mm-ss格式
 */
+ (NSString *)stringFromYDMHmsDate:(NSDate *)date;

/**
 日期转换成字符串 自定义转换格式
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)format;

/**
 转换成日期 yyyy-MM-dd格式
 */
- (NSDate *)toDate;

/**
 转换成日期 yyyy-MM-dd HH:mm:ss格式
 */
- (NSDate *)toYDMHmsDate;

/**
 转换成日期 自定义格式
 */
- (NSDate *)toDateWithDateFormat:(NSString *)format;


#pragma mark - Remove Emoji
/**
 判断字符串中是否含有Emoji表情
 */
- (BOOL)isIncludeEmoji;

/**
 移除字符串中的Emoji表情。不改变原字符串，返回移除后的字符串
 */
- (NSString *)stringRemoveEmoji;

@end


