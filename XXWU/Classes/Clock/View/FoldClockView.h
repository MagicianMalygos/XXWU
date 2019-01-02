//
//  FoldClockView.h
//  Demo
//
//  Created by 朱超鹏 on 2018/6/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldClockItemView.h"

/*
 problem: 在模拟器上发现，每个label右边有一竖条黑线。然后解决的过程中发现把每个item的宽度调的大一点就又好了，解决无果。但是后面发现真机上没有该情况，猜测可能是模拟器上的显示问题，故不用解决。
 */

/**
 折叠式钟表
 */
@interface FoldClockView : UIView

/// 日期，定时修改此值使钟表工作
@property (nonatomic, strong) NSDate *date;

/// 字体
@property (nonatomic, strong) UIFont *font;
/// 时间字体颜色
@property (nonatomic, strong) UIColor *textColor;
/// 每一项的背景色
@property (nonatomic, strong) UIColor *itemBackgroundColor;

/// item整体相对于该视图的insets
@property (nonatomic, assign) UIEdgeInsets itemInsets;
/// item之间的间隔
@property (nonatomic, assign) CGFloat itemSpacing;
/// 分割线宽度
@property (nonatomic, assign) CGFloat splitLineHeight;


/**
 实例化方法

 @param date 日期
 @return 实例化对象
 */
- (instancetype)initWithDate:(NSDate *)date;

/**
 设置日期

 @param date 新日期
 @param animated 是否显示动画
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end
