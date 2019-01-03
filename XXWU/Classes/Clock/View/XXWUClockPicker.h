//
//  XXWUClockPicker.h
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 闹钟页定制的时间选择器，功能单一难以复用，等待后续更新。
 */
@interface XXWUClockPicker : UIView

/// 选择器
@property (nonatomic, strong) UIPickerView *picker;
/// 确定按钮回调block
@property (nonatomic, copy) void(^confirmBlock)(NSInteger hour, NSInteger minute, NSInteger second);

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
