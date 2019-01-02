//
//  FoldClockItemView.h
//  Demo
//
//  Created by 朱超鹏 on 2018/6/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoldClockLabel.h"

/**
 折叠式时钟时间项视图
 */
@interface FoldClockItemView : UIView

/// 当前时间
@property (nonatomic, assign, readonly) NSInteger currentTime;
/// 字体
@property (nonatomic, strong) UIFont *font;
/// 字体颜色
@property (nonatomic, strong) UIColor *textColor;

/**
 实例化方法
 
 @param time 初始时间
 */
- (instancetype)initWithTime:(NSInteger)time;

/**
 更新时间
 
 @param time 新时间
 */
- (void)updateTime:(NSInteger)time;

/**
 更新时间

 @param time 新时间
 @param animated 是否显示动画
 */
- (void)updateTime:(NSInteger)time animated:(BOOL)animated;

@end
