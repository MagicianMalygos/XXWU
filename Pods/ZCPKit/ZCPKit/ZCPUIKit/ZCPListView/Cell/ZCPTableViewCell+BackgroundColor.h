//
//  ZCPTableViewCell+BackgroundColor.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/7/30.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPTableViewCell.h"

@interface ZCPTableViewCell (BackgroundColor)

/**
 设置自定义背景颜色
 */
- (void)setCustomBackgroundColor:(UIColor *)customBackgroundColor;

/**
 清除背景颜色
 */
- (void)clearBackgroundColor;

@end
