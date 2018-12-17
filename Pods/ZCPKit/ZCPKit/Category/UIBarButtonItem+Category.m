//
//  UIBarButtonItem+Category.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "UIBarButtonItem+Category.h"
#import "ZCPGlobal.h"
#import "UIColor+Category.h"

@implementation UIBarButtonItem (Category)

+ (id) setBackItemWithTarget:(id)target action:(SEL)action {
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = YES;
    btn.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    btn.backgroundColor = [UIColor clearColor];
    if (iOS11Upper) {
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    }
    [btn setTitle:@"<" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:24.0];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"333333"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    ((UIViewController *)target).navigationItem.leftBarButtonItem = backItem;
    return backItem;
    
}

+ (id)rightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [UIBarButtonItem rightBarItemWithTitle:title
                                             font:[UIFont fontWithName:@"iconfont" size:16]
                                           target:target action:action];
}

+ (id)rightBarItemWithTitle:(NSString *)title font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"777777"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    btn.showsTouchWhenHighlighted = YES;
    if (font) {
        btn.titleLabel.font = font;
    }else{
        btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    }
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+ (id)rightBarItemWithTitle:(NSString *)title  titleColor:(NSString *)bgColorStr font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    if(iOS11Upper){
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:bgColorStr] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.showsTouchWhenHighlighted = YES;
    if (font) {
        btn.titleLabel.font = font;
    }else{
        btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:18];
    }
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


+ (id)rightBarItemWithIcon:(NSString *)iconCode iconSize:(CGFloat)size iconColor:(UIColor *)iconColor highlighted:(BOOL)highlighted target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    [btn setTitle:iconCode forState:UIControlStateNormal];
    [btn setTitleColor:iconColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.showsTouchWhenHighlighted = highlighted;
    btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:size];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (id)leftBarItemWithIcon:(NSString *)iconCode iconSize:(CGFloat)size iconColor:(UIColor *)iconColor highlighted:(BOOL)highlighted target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    [btn setTitle:iconCode forState:UIControlStateNormal];
    [btn setTitleColor:iconColor forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.showsTouchWhenHighlighted = highlighted;
    btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:size];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (id)rightBarItemWithIcon:(NSString *)iconCode target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    [btn setTitle:iconCode forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"777777"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.showsTouchWhenHighlighted = YES;
    btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:28];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (id)rightBarItemWithFont:(int)font Icon:(NSString *)iconCode target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    [btn setTitle:iconCode forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexRGB:@"777777"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.showsTouchWhenHighlighted = YES;
    btn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:font];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
