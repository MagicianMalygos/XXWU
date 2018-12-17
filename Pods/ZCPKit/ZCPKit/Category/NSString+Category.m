//
//  NSString+Category.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

#pragma mark -
// 判断是否包含特定字符串
- (BOOL)contains:(NSString *)str {
    if (nil == str || [str length] < 1) {
        return NO;
    }
    return [self rangeOfString:str].location != NSNotFound;
}

/// 转换为json对象
- (id)JSONObject {
    NSError *err        = nil;
    NSObject *object    = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    if (err == nil) {
        return object;
    } else {
        return nil;
    }
}

#pragma mark - 日期/字符串转换
// 日期转换成字符串 yyyy-MM-dd格式
+ (NSString *)stringFromDate:(NSDate *)date {
    NSString *sDate = [self stringFromDate:date withDateFormat:@"yyyy-MM-dd"];
    return sDate;
}

// 日期转换成字符串 yyyy-MM-dd HH-mm-ss格式
+ (NSString *)stringFromYDMHmsDate:(NSDate *)date {
    NSString *sDate = [self stringFromDate:date withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return sDate;
}

// 日期转换成字符串 自定义转换格式
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter staticDateFormatter];
    [formatter setDateFormat:format];
    NSString *sDate = [formatter stringFromDate:date];
    return sDate;
}

// 转换成日期 yyyy-MM-dd格式
- (NSDate *)toDate {
    NSDate *date = [NSDate dateFromString:self];
    return date;
}

// 转换成日期 yyyy-MM-dd HH:mm:ss格式
- (NSDate *)toYDMHmsDate {
    NSDate *date = [NSDate dateFromYDMHmsString:self];
    return date;
}

// 转换成日期 自定义格式
- (NSDate *)toDateWithDateFormat:(NSString *)format {
    NSDate *date = [NSDate dateFromString:self withDateFormat:format];
    return date;
}

#pragma mark - Remove Emoji
// 判断字符串中是否含有Emoji表情
- (BOOL)isIncludeEmoji {
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    return result;
}

// 移除字符串中的Emoji表情。不改变原字符串，返回移除后的字符串
- (NSString *)stringRemoveEmoji {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring isEmoji])? @"": substring];
                          }];
    
    return buffer;
}

// 判断字符是否是Emoji
- (BOOL)isEmoji {
    
    NSCharacterSet *variationSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
    if ([self rangeOfCharacterFromSet:variationSelectors].location != NSNotFound) {
        return YES;
    }
    
    const unichar high = [self characterAtIndex: 0];
    
    // Surrogate pair (U+1D000-1F9FF)
    if (0xD800 <= high && high <= 0xDBFF) {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
        
        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return (0x2100 <= high && high <= 0x27BF);
    }
}

@end
