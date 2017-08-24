//
//  DebugStatusBallView.h
//  Demo
//
//  Created by 朱超鹏 on 2017/7/26.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DebugStatusBallView;

@protocol DebugStatusBallViewDelegate <NSObject>

/**
 点击状态球视图
 */
- (void)clickDebugStatusBallView:(DebugStatusBallView *)debugStatusBallView;

@end

#pragma mark - 调试状态球视图
@interface DebugStatusBallView : UIButton

@property (nonatomic, weak) id<DebugStatusBallViewDelegate> delegate;

+ (instancetype)instanceDebugStatusBallView;

- (void)show;
- (void)hide;

@end
