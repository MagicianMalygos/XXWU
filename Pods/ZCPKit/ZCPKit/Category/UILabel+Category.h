//
//  UILabel+Category.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 设置label行间距

 @param height 行间距值
 */
- (void)setLineSpace:(CGFloat)height;

/**
 sizeToFit带边距方法

 @param edgeInsets 内边距
 */
- (void)sizeToFitWithEdge:(UIEdgeInsets)edgeInsets;

@end
