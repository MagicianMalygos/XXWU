//
//  CommentView.m
//  Apartment
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPCommentView.h"
#import "ZCPCategory.h"

@implementation ZCPCommentView

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize keyboardResponder   = _keyboardResponder;
@synthesize coverView           = _coverView;
@synthesize target              = _target;
@synthesize delegate            = _delegate;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)initWithTarget:(UIViewController *)target {
    if (self = [super init]) {
        // 初始化CommentView
        CGRect bounds = [[UIScreen mainScreen] bounds];
        [self setFrame:CGRectMake(0, bounds.size.height, bounds.size.width, 44)];
        [self setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0f]];
        self.hidden = YES;
        
        // 添加键盘响应者
        [self addSubview:self.keyboardResponder];
        
        // 创建可以覆盖整个视图的coverView，为其添加点击手势与点击响应事件
        self.coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.coverView setAlpha:0.01009f];
        [self.coverView setBackgroundColor:[UIColor whiteColor]];
        [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverView)]];
        
        // 监听键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCommentView:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCommentView:) name:UIKeyboardWillHideNotification object:nil];
        
        // 设置目标控制器
        self.target = target;
    }
    return self;
}

// ----------------------------------------------------------------------
#pragma mark - life cycle
// ----------------------------------------------------------------------
/**
 *  销毁观察者
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// ----------------------------------------------------------------------
#pragma mark - getter / setter
// ----------------------------------------------------------------------
- (ZCPTextView *)keyboardResponder {
    if (_keyboardResponder == nil) {
        _keyboardResponder = [[ZCPTextView alloc] initWithFrame:CGRectMake(4, 4, self.width - 8, self.height - 8)];
        _keyboardResponder.placeholder = @"请输入内容...";
        _keyboardResponder.keyboardType = UIKeyboardTypeDefault;    // 设置键盘样式
        _keyboardResponder.returnKeyType = UIReturnKeySend;         // 设置return键为send
        _keyboardResponder.delegate = self;
    }
    return _keyboardResponder;
}

// ----------------------------------------------------------------------
#pragma mark - Private Method
// ----------------------------------------------------------------------
/**
 *  显示评论视图
 */
- (void)showCommentView {
    // 键盘响应者得到第一响应者，弹出键盘
    [self.keyboardResponder becomeFirstResponder];
}
/**
 *  隐藏评论视图
 */
- (void)hideCommentView {
    // 键盘响应者失去第一响应者，缩回键盘
    [self.keyboardResponder resignFirstResponder];
}
/**
 *  清除文本框内容
 */
- (void)clearText {
    self.keyboardResponder.text = @"";
}

// ----------------------------------------------------------------------
#pragma mark - Private Method
// ----------------------------------------------------------------------
/**
 *  显示评论视图
 */
- (void)showCommentView:(NSNotification *)notification {
    
    // 添加覆盖视图
    [self.target.view addSubview:self.coverView];
    
    // ------------------
    // 将‘响应键盘输入视图’和‘评论视图’置顶
    UIView *responderView = self.keyboardResponder;
    while (![[responderView superview] isEqual:self.target.view]) {
        responderView = [responderView superview];
    }
    [self.target.view bringSubviewToFront:responderView];
    [self.target.view bringSubviewToFront:self];
    [self changeCommentViewByNotification:notification isShow:YES];
    // ------------------
}
/**
 *  隐藏评论视图
 */
- (void)hideCommentView:(NSNotification *)notification {
    [self changeCommentViewByNotification:notification isShow:NO];
    [self.coverView removeFromSuperview];
}
/**
 *  通过键盘弹出、缩回事件，改变评论视图的位置
 *
 *  @param notification 键盘弹出、缩回通知
 *  @param isShow       设置评论视图是否显示
 */
- (void)changeCommentViewByNotification:(NSNotification *)notification isShow:(BOOL)isShow {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]; // 添加移动动画，使视图跟随键盘移动
    
    // 得到键盘弹出或缩回后的键盘视图所在的y坐标
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y; // 得到键盘弹出后的键盘视图所在的y坐标
    CGFloat Y = (isShow)?(keyBoardEndY - self.bounds.size.height/2.0):(keyBoardEndY + self.bounds.size.height/2.0);
    // 判断是否隐藏CommentView
    self.hidden = !isShow;
    // 如果target是UITableView或其子类，需要再加上64
//    if ([self.target isKindOfClass:[UITableViewController class]]) {
//        Y -= 64;
//    }
    Y -= 64;
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        self.center = CGPointMake(self.center.x, Y);
    }];
}
/**
 *  遮盖背景视图点击响应方法（隐藏键盘）
 */
- (void)tapCoverView {
    [self.keyboardResponder resignFirstResponder];  // 缩回键盘
}

// ----------------------------------------------------------------------
#pragma mark - UITextFiledDelegate
// ----------------------------------------------------------------------
/**
 *  textView内容将要发生改变的时调用
 *
 *  @param textView textView
 *  @param range    变化范围：range.location表示从何处开始变化，range.length始终为0
 *  @param text     变化的值（即输入的值）
 *
 *  @return YES是允许修改textview的值， NO是不允许修改textview的值
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if(![textView.text isEqualToString:@""]
           && self.delegate
           && [self.delegate respondsToSelector:@selector(textInputShouldReturn:)]){
            BOOL isHiddenKeyboard = [self.delegate textInputShouldReturn:self.keyboardResponder];
            if (isHiddenKeyboard) {
                [self hideCommentView];
            }
        }
        return NO;
    }
    return YES;
}

@end
