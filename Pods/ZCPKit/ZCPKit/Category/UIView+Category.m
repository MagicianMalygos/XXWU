//
//  UIView+EasyFrame.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "UIView+EasyFrame.h"
#import "ZCPGlobal.h"

@implementation UIView (Background)

#pragma mark 设置背景颜色
- (void)setCustomBackgroundColor:(UIColor *)color {
    
    if ([self isKindOfClass:[UITableViewCell class]]) {
        // UITableViewCell
        UITableViewCell *cell               = (UITableViewCell *)self;
        UIView * backgroundView             = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor      = color;
        cell.backgroundColor                = color;
        cell.backgroundView                 = backgroundView;
        cell.contentView.backgroundColor    = color;
    } else if ([self isKindOfClass:[UINavigationBar class]]) {
        // UINavigationBar
        UINavigationBar *navigationBar      = (UINavigationBar *)self;
        if (SYSTEM_VERSION < 7.0) {
            navigationBar.clipsToBounds     = YES;
            navigationBar.shadowImage       = [[UIImage alloc] init];
            navigationBar.tintColor         = color;
        } else {
            navigationBar.barTintColor      = color;
        }
        navigationBar.translucent = NO;
    }
}

#pragma mark 清除背景颜色
- (void)clearBackgroundColor {
    
    if ([self isKindOfClass:[UITableViewCell class]]) {
        // UITableViewCell
        UITableViewCell *cell               = (UITableViewCell *)self;
        UIView * backgroundView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        backgroundView.backgroundColor      = [UIColor clearColor];
        
        cell.backgroundColor                = [UIColor clearColor];
        cell.backgroundView                 = backgroundView;
        cell.contentView.backgroundColor    = [UIColor clearColor];
        cell.selectionStyle                 = UITableViewCellSelectionStyleNone;
    } else if ([self isKindOfClass:[UIWebView class]]) {
        // UIWebView
        UIWebView *webView                  = (UIWebView *)self;
        webView.backgroundColor             = [UIColor clearColor];
        webView.opaque                      = NO;
        for(UIView * shadowView in [[[webView subviews] objectAtIndex:0] subviews]) {
            if ([shadowView isKindOfClass:[UIImageView class]]) {
                shadowView.hidden = YES;
            }
        }
    }
}

@end
