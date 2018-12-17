//
//  DebugConsoleLogView.m
//  Demo
//
//  Created by 朱超鹏 on 2017/7/26.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "DebugConsoleLogView.h"

@interface DebugConsoleLogView ()

@property (nonatomic, strong) UIView        *backgroundView;
@property (nonatomic, strong) UIScrollView  *consoleScrollView;
@property (nonatomic, strong) UILabel       *consoleInfoView;

@end

@implementation DebugConsoleLogView

#pragma mark - life cycle

+ (instancetype)instanceDebugConsoleLogView {
    DebugConsoleLogView *debugConsoleLogView = [[DebugConsoleLogView alloc] init];
    return debugConsoleLogView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.consoleScrollView];
        [self.consoleScrollView addSubview:self.consoleInfoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame                      = [UIScreen mainScreen].bounds;
    self.backgroundView.frame       = self.bounds;
    self.consoleScrollView.frame    = CGRectMake(16, ((self.height - 400) / 2), self.width - 32, 400);
    self.consoleInfoView.frame      = CGRectMake(0, 0, self.consoleScrollView.width, self.consoleInfoView.height);
}

#pragma mark - public method

- (void)addlog:(NSString *)log {
    if (self.consoleInfoView.text == nil) {
        self.consoleInfoView.text = @"";
    } else {
        self.consoleInfoView.text = [self.consoleInfoView.text stringByAppendingString:@"\n"];
    }
    
    self.consoleInfoView.text = [self.consoleInfoView.text stringByAppendingString:log];
    
    CGFloat consoleInfoHeight = [self.consoleInfoView.text boundingRectWithSize:CGSizeMake(self.consoleInfoView.width, MAXFLOAT)
                                                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: self.consoleInfoView.font}
                                                                        context:nil].size.height;
    self.consoleInfoView.height = consoleInfoHeight;
    if (self.consoleScrollView.height >= self.consoleInfoView.height) {
        self.consoleScrollView.contentOffset    = CGPointMake(0, 0);
        self.consoleScrollView.contentSize      = self.consoleScrollView.size;
    } else {
        self.consoleScrollView.contentOffset    = CGPointMake(0, self.consoleInfoView.height - self.consoleScrollView.height);
        self.consoleScrollView.contentSize      = CGSizeMake(self.consoleScrollView.width, self.consoleInfoView.height);
    }
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)hide {
    if (self.delegate && [self.delegate respondsToSelector:@selector(debugConsoleLogViewWillHide:)]) {
        [self.delegate debugConsoleLogViewWillHide:self];
    }
    [self removeFromSuperview];
}

#pragma mark - getter / setter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView                 = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    }
    return _backgroundView;
}

- (UIScrollView *)consoleScrollView {
    if (!_consoleScrollView) {
        _consoleScrollView                                  = [[UIScrollView alloc] init];
        _consoleScrollView.backgroundColor                  = [UIColor whiteColor];
        _consoleScrollView.showsHorizontalScrollIndicator   = NO;
        _consoleScrollView.showsVerticalScrollIndicator     = YES;
        _consoleScrollView.bounces                          = YES;
        _consoleScrollView.layer.cornerRadius               = 5;
        [_consoleScrollView clipsToBounds];
    }
    return _consoleScrollView;
}

- (UILabel *)consoleInfoView {
    if (!_consoleInfoView) {
        _consoleInfoView                    = [[UILabel alloc] init];
        _consoleInfoView.backgroundColor    = [UIColor whiteColor];
        _consoleInfoView.numberOfLines      = 0;
        _consoleInfoView.font               = [UIFont systemFontOfSize:10.0f];
        _consoleInfoView.textColor          = [UIColor blackColor];
    }
    return _consoleInfoView;
}

@end
