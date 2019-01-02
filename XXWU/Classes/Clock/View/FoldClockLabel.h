//
//  FoldClockLabel.h
//  Demo
//
//  Created by 朱超鹏 on 2018/6/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 折叠式时钟标签视图
 */
@interface FoldClockLabel : UIView

/// 当前时间，使用NSString类型是为了可以支持中文符号等表示方式
@property (nonatomic, copy, readonly) NSString *currentTime;
/// 字体
@property (nonatomic, strong) UIFont *font;
/// 字体颜色
@property (nonatomic, strong) UIColor *textColor;

/**
 实例化方法

 @param time 初始时间
 */
- (instancetype)initWithTime:(NSString *)time;

/**
 更新时间

 @param time 新时间
 */
- (void)updateTime:(NSString *)time;

/**
 更新时间

 @param time 新时间
 @param animated 是否显示动画
 */
- (void)updateTime:(NSString *)time animated:(BOOL)animated;

@end
