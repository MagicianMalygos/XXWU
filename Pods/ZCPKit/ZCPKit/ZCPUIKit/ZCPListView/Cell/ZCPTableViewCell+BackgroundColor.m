//
//  ZCPTableViewCell+BackgroundColor.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/7/30.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPTableViewCell+BackgroundColor.h"

@implementation UITableViewCell (BackgroundColor)

/// 设置自定义背景颜色
- (void)setCustomBackgroundColor:(UIColor *)customBackgroundColor {
    UIView *backgroundView              = [[UIView alloc] initWithFrame:CGRectZero];
    backgroundView.backgroundColor      = customBackgroundColor;
    self.backgroundView                 = backgroundView;
    self.backgroundColor                = customBackgroundColor;
    self.contentView.backgroundColor    = customBackgroundColor;
}

/// 清除背景颜色
- (void)clearBackgroundColor {
    UIView *backgroundView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    backgroundView.backgroundColor      = [UIColor clearColor];
    self.backgroundView                 = backgroundView;
    self.backgroundColor                = [UIColor clearColor];
    self.contentView.backgroundColor    = [UIColor clearColor];
    self.selectionStyle                 = UITableViewCellSelectionStyleNone;
}

@end
