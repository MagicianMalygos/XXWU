//
//  UIBarButtonItem+Category.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Category)

// 搞个小清新按钮
+ (id) setBackItemWithTarget:(id)target action:(SEL)action;

// 导航栏右item butuon 统一样式
+ (id)rightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (id)rightBarItemWithTitle:(NSString *)title font:(UIFont *)font target:(id)target action:(SEL)action;
+ (id)rightBarItemWithTitle:(NSString *)title  titleColor:(NSString *)bgColorStr font:(UIFont *)font target:(id)target action:(SEL)action;
+ (id)rightBarItemWithFont:(int)font Icon:(NSString *)iconCode target:(id)target action:(SEL)action;

//用iconfont 自定义右导航栏按钮，可设置颜色，大小，图标（iconfont），高亮
+ (id)rightBarItemWithIcon:(NSString *)iconCode iconSize:(CGFloat)size iconColor:(UIColor *)iconColor highlighted:(BOOL)highlighted target:(id)target action:(SEL)action;
//用iconfont 自定义左导航栏按钮，可设置颜色，大小，图标（iconfont），高亮
+ (id)leftBarItemWithIcon:(NSString *)iconCode iconSize:(CGFloat)size iconColor:(UIColor *)iconColor highlighted:(BOOL)highlighted target:(id)target action:(SEL)action;


+ (id)rightBarItemWithIcon:(NSString *)iconCode target:(id)target action:(SEL)action;

@end
