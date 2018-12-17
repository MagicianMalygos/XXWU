//
//  PANoticeUtil.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPToastUtil.h"

static BOOL toastShowed     = NO;   // 跟踪toastView的显示状态
static UIView *toastView    = nil;  // toastView

@interface ZCPToastUtil ()

@end

@implementation ZCPToastUtil

IMP_SINGLETON

#pragma mark - function

+ (void)showToast:(NSString *)msg {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showToast:msg inView:window];
}

+ (void)showToast:(NSString *)msg inView:(UIView *)view {
    float duration = 1;
    if (msg.length > 10)
        duration = 1.5;
    else if (msg.length > 15)
        duration = 2.5;
    [self showToast:msg inView:view duration:duration completion:nil];
}

+ (void)showToast:(NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration {
    [self showToast:msg inView:view duration:duration completion:nil];
}

+ (void)showToast:(nullable NSString *)msg inView:(UIView *)view duration:(NSTimeInterval)duration completion:(void(^)(void))completion {
    // 参数处理
    msg                         = msg ? msg : @"";
    
    if (toastView.superview) {
        [toastView removeFromSuperview];
        toastView = nil;
    };
    
    // msg label
    UILabel *msgLabel           = [[UILabel alloc] init];
    msgLabel.backgroundColor    = [UIColor clearColor];
    msgLabel.textAlignment      = NSTextAlignmentCenter;
    msgLabel.textColor          = [UIColor whiteColor];
    msgLabel.font               = [UIFont fontWithName:@"Helvetica" size:15];
    msgLabel.numberOfLines      = 0;
    CGSize size                 = [msg boundingRectWithSize:CGSizeMake(280, 1500)
                                                    options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: msgLabel.font}
                                                    context:nil].size;
    msgLabel.frame              = CGRectMake(0, 0, size.width, size.height);
    msgLabel.text               = msg;
    
    // background view
    UIView *backgroundView      = [[UIView alloc] init];
    backgroundView.backgroundColor      = [UIColor blackColor];
    backgroundView.layer.cornerRadius   = 5.0f;
    backgroundView.layer.opacity        = 0.0f;
    [backgroundView addSubview:msgLabel];
    
    // 设置origin
    CGFloat margin              = 10;
    backgroundView.frame        = CGRectMake(0, 0, msgLabel.bounds.size.width + margin * 2, msgLabel.bounds.size.height + margin * 2);
    CGPoint center              = view.center;
    if (![view isKindOfClass:[UIWindow class]]) {
        center.y                -= 90;
    }
    msgLabel.center             = CGPointMake(backgroundView.bounds.size.width / 2, backgroundView.bounds.size.height / 2);
    backgroundView.center       = center;

    [ZCPToastUtil showToastWithCustomView:backgroundView inView:view duration:duration completion:completion];
}

+ (void)showToastWithCustomView:(UIView *)customView inView:(UIView *)view duration:(NSTimeInterval)duration completion:(void(^)(void))completion {
    
    // 参数处理
    view                        = view ? view : [[UIApplication sharedApplication].delegate window];
    if (!customView) {
        return;
    }
    
    toastView = customView;
    [view addSubview:toastView];
    [view bringSubviewToFront:toastView];
    
    toastView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    toastShowed = YES;
    
    [self performBlock:^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            toastView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            [toastView.layer setOpacity:0.9];
        } completion:^(BOOL finished) {
            // 延迟移出
            [self performBlock:^{
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                   toastView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                   [toastView.layer setOpacity:0.0];
                } completion:^(BOOL finished) {
                    if (completion != nil) {
                        completion();
                    }
                    [toastView removeFromSuperview];
                    toastShowed = NO;
                }];
            } afterDelay:duration cancelPreviousOperation:YES];
        }];
    } afterDelay:0 cancelPreviousOperation:YES];
}


#pragma mark - private method

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousOperation:(BOOL)cancel {
    if (cancel) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    [self performBlock:block afterDelay:delay];
}

+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(delayedAddOperation:)
               withObject:[NSBlockOperation blockOperationWithBlock:block]
               afterDelay:delay];
}

+ (void)delayedAddOperation:(NSOperation *)operation {
    [[NSOperationQueue currentQueue] addOperation:operation];
}

@end
