//
//  XXWUClockQuickToolView.h
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 闹钟页快捷时间选择工具视图
 */
@interface XXWUClockQuickToolView : UIView

/// 工具按钮点击回调block
@property (nonatomic, copy) void(^responseBlock)(NSInteger hour, NSInteger minute, NSInteger second);

/**
 重新从缓存获取数据源更新UI
 */
- (void)update;

@end

NS_ASSUME_NONNULL_END
