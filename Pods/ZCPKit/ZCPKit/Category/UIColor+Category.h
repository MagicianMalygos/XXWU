//
//  UIColor+Category.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/**
 根据16进制字符串获取Color

 @param color16String 16进制颜色字符串

 @return UIColor对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)color16String;

/**
 根据16进制值获取Color

 @param color16 16进制值

 @return UIColor对象
 */
+ (UIColor *)colorFromHex:(UInt32)color16;

@end
