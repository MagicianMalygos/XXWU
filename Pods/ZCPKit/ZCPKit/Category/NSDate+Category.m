//
//  NSDate+Category.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

@implementation NSDate (String)

#pragma mark - 日期/字符串转换
// 字符串转换成日期 yyyy-MM-dd格式
+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDate *date = [self dateFromString:dateString withDateFormat:@"yyyy-MM-dd"];
    return date;
}

// 字符串转换成日期 yyyy-MM-dd HH:mm:ss格式
+ (NSDate *)dateFromYDMHmsString:(NSString *)dateString {
    NSDate *date = [self dateFromString:dateString withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return date;
}

// 字符串转换成日期 自定义格式
+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter staticDateFormatter];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

// 转换成字符串 yyyy-MM-dd格式
- (NSString *)toString {
    NSString *sDate = [NSString stringFromDate:self];
    return sDate;
}

// 转换成字符串 yyyy-MM-dd HH:mm:ss格式
- (NSString *)toYDMHmsString {
    NSString *sDate = [NSString stringFromYDMHmsDate:self];
    return sDate;
}

// 转换成字符串 自定义格式
- (NSString *)toStringWithDateFormat:(NSString *)format {
    NSString *sDate = [NSString stringFromDate:self withDateFormat:format];
    return sDate;
}

#pragma mark - 日期信息

- (NSUInteger)weekdayNumber {
    NSCalendar *calendar            = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone            = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit     = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:self];
    NSUInteger weekdayNumber        = theComponents.weekday - 1;
    weekdayNumber                   = (weekdayNumber != 0) ? weekdayNumber : 7;
    return weekdayNumber;
}

@end
