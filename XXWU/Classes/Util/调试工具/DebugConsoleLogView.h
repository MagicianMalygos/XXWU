//
//  DebugConsoleLogView.h
//  Demo
//
//  Created by 朱超鹏 on 2017/7/26.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DebugConsoleLogView;

@protocol DebugConsoleLogViewDelegate <NSObject>

- (void)debugConsoleLogViewWillHide:(DebugConsoleLogView *)view;

@end

#pragma mark - 调试控制台视图
@interface DebugConsoleLogView : UIView

@property (nonatomic, weak) id<DebugConsoleLogViewDelegate> delegate;

+ (instancetype)instanceDebugConsoleLogView;

- (void)show;
- (void)hide;

- (void)addlog:(NSString *)log;

@end
