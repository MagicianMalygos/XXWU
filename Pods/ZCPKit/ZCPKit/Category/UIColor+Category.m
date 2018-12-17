//
//  UIColor+Category.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

// 根据16进制字符串获取Color
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor whiteColor];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location      = 0;
    range.length        = 2;
    NSString *rString   = [cString substringWithRange:range];
    
    range.location      = 2;
    NSString *gString   = [cString substringWithRange:range];
    
    range.location      = 4;
    NSString *bString   = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}

// 根据16进制值获取Color
+ (UIColor *)colorFromHex:(UInt32)color {
    UIColor *result = nil;
    UInt8 alphaByte, redByte, greenByte, blueByte;
    
    alphaByte   = (color & 0xFF000000) >> 24;
    redByte     = (color & 0x00FF0000) >> 16;
    greenByte   = (color & 0x0000FF00) >> 8;
    blueByte    = (color & 0x000000FF);
    
    result = [UIColor colorWithRed:redByte/255.0 green:greenByte/255.0 blue:blueByte/255.0 alpha:alphaByte/255.0];
    return result;
}

@end
