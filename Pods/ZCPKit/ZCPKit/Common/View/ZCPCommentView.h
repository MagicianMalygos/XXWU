//
//  ZCPCommentView.h
//  Apartment
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTextView.h"

@protocol ZCPCommentViewDelegate;

@interface ZCPCommentView : UIView <UITextViewDelegate>

@property (nonatomic, strong)   ZCPTextView         *keyboardResponder;     // 文本输入响应者
@property (nonatomic, strong)   UIView              *coverView;             // 覆盖屏幕视图
@property (nonatomic, weak)     UIViewController    *target;                // 目标控制器
@property (nonatomic, weak)     id<ZCPCommentViewDelegate> delegate;        // delegate

// ----------------------------------------------------------------------
#pragma mark - Basic Method
// ----------------------------------------------------------------------
/**
 *  实例化方法
 *
 *  @param target 目标控制器
 */
- (instancetype)initWithTarget:(UIViewController *)target;
/**
 *  显示评论视图
 */
- (void)showCommentView;
/**
 *  隐藏评论视图
 */
- (void)hideCommentView;
/**
 *  清除文本框内容
 */
- (void)clearText;

@end


// ----------------------------------------------------------------------
#pragma mark - PROTOCOL
// ----------------------------------------------------------------------
@protocol ZCPCommentViewDelegate <NSObject>
/**
 *  键盘Retuen键点击响应方法
 *
 *  @param keyboardResponder 键盘响应者
 *
 *  @return YES表示点击隐藏键盘，NO表示点击不隐藏键盘
 */
- (BOOL)textInputShouldReturn:(ZCPTextView *)keyboardResponder;
@end
