//
//  DebugStatusBallView.m
//  Demo
//
//  Created by 朱超鹏 on 2017/7/26.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "DebugStatusBallView.h"

@interface DebugStatusBallView () {
    CGPoint _beganPointAtWindow;
    CGPoint _touchPointAtWindow;
    CGPoint _touchPointAtSelf;
}

@end

@implementation DebugStatusBallView

#pragma mark - life cycle

+ (instancetype)instanceDebugStatusBallView {
    DebugStatusBallView *debugStatusBallView = [[[NSBundle mainBundle] loadNibNamed:@"DebugStatusBallView" owner:self options:nil] firstObject];
    
    return debugStatusBallView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.frame              = CGRectMake(0, 20, 50, 50);
        self.layer.cornerRadius = self.height / 2;
        [self clipsToBounds];
    }
    return self;
}

#pragma mark - public method

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

#pragma mark - event response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch      = [touches anyObject];
    _touchPointAtWindow = [touch locationInView:self.superview];
    _touchPointAtSelf   = [touch locationInView:self];
    
    _beganPointAtWindow = _touchPointAtWindow;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint movedPointAtWindow = [touch locationInView:self.superview];
    
    if (movedPointAtWindow.x < _touchPointAtSelf.x) {
        movedPointAtWindow.x = _touchPointAtSelf.x;
    }
    if (movedPointAtWindow.x + self.width - _touchPointAtSelf.x > SCREENWIDTH) {
        movedPointAtWindow.x = SCREENWIDTH - (self.width - _touchPointAtSelf.x);
    }
    if (movedPointAtWindow.y < _touchPointAtSelf.y) {
        movedPointAtWindow.y = _touchPointAtSelf.y;
    }
    if (movedPointAtWindow.y + self.height - _touchPointAtSelf.y > SCREENHEIGHT) {
        movedPointAtWindow.y = SCREENHEIGHT - (self.height - _touchPointAtSelf.y);
    }
    
    touch.view.center = CGPointMake(movedPointAtWindow.x - _touchPointAtWindow.x + self.center.x, movedPointAtWindow.y - _touchPointAtWindow.y + self.center.y);
    _touchPointAtWindow = movedPointAtWindow;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch      = [touches anyObject];
    
    CGPoint endPointAtWindow = [touch locationInView:self.superview];
    if (CGPointGetDistanceToPoint(_beganPointAtWindow, endPointAtWindow) < 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickDebugStatusBallView:)]) {
            [self.delegate clickDebugStatusBallView:self];
        }
    }
    _touchPointAtWindow = CGPointZero;
}

@end
