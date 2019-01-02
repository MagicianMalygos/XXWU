//
//  FoldClockLabel.m
//  Demo
//
//  Created by 朱超鹏 on 2018/6/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "FoldClockLabel.h"

// 动画最大进度
#define MaximumProgress 1.0f
// nextLabel的起始旋转角度，用于让其只显示上半部分
#define NextLabelStartAngel (M_PI/180.0)

@interface FoldClockLabel ()

/// 背景视图，用于nextLabel存在旋转角度时遮挡其下半部分
@property (nonatomic, strong) UIView *bgView;
/// 用于展示完整时间的label
@property (nonatomic, strong) UILabel *timeLabel;
/// 用于展示下一个时间的label，只显示上半部分
@property (nonatomic, strong) UILabel *nextLabel;
/// 用于旋转实现折叠效果的label
@property (nonatomic, strong) UILabel *foldLabel;

/// 执行动画的定时器
@property (nonatomic, strong) CADisplayLink *displayLink;
/// 折叠动画的进度，0~MaximumProgress
@property (nonatomic, assign) CGFloat animationProgress;

/// 当前时间
@property (nonatomic, copy) NSString *currentTime;

@end

@implementation FoldClockLabel

#pragma mark - life cycle

- (instancetype)init {
    return [self initWithTime:0];
}

- (instancetype)initWithTime:(NSString *)time {
    if (self = [super init]) {
        
        self.currentTime = time;
        
        [self addSubview:self.bgView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.nextLabel];
        [self addSubview:self.foldLabel];
        
        self.timeLabel.text = self.currentTime;
        self.foldLabel.text = self.currentTime;
        self.nextLabel.text = self.currentTime;
        
        // 给nextLabel一个初始旋转角度，使其只显示上半部分
        self.nextLabel.layer.transform = CATransform3DMakeRotation(NextLabelStartAngel, -1, 0, 0);
        // 初始化计时器
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimation)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame       = self.bounds;
    self.timeLabel.frame    = self.bounds;
    self.nextLabel.frame    = self.bounds;
    self.foldLabel.frame    = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        if (_displayLink != nil) {
            [_displayLink invalidate];
            _displayLink = nil;
        }
    }
}

#pragma mark - public

- (void)updateTime:(NSString *)time {
    [self updateTime:time animated:YES];
}

- (void)updateTime:(NSString *)time animated:(BOOL)animated {
    
    if (animated) {
        self.timeLabel.text     = self.currentTime;
        self.foldLabel.text     = self.currentTime;
        self.nextLabel.text     = time;
        self.nextLabel.hidden   = YES;
        self.animationProgress  = 0;
        self.currentTime        = time;
        [self startAnimation];
    } else {
        self.timeLabel.text     = time;
        self.foldLabel.text     = time;
        self.nextLabel.text     = time;
        self.nextLabel.hidden   = YES;
        self.animationProgress  = 0;
        self.currentTime        = time;
    }
}

#pragma mark - private

/// 配置label信息
- (void)configureLabel:(UILabel *)label {
    label.font = [UIFont fontWithName:@"AmericanTypewriter-Condensed" size:80.0f];
    label.textColor = [UIColor blackColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
}

#pragma mark - time

- (void)startAnimation {
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation {
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateAnimation {
    self.animationProgress += 1.0/60.0;
    
    // 如果 progress > max 则结束旋转
    if (self.animationProgress > MaximumProgress) {
        self.timeLabel.text = self.nextLabel.text;
        [self stopAnimation];
        return;
    }
    
    CATransform3D transform = CATransform3DIdentity;
    // x轴旋转 从 0~M_PI
    CGFloat currAngle = M_PI * self.animationProgress;
    transform = CATransform3DRotate(transform, currAngle, -1, 0, 0);
    
    // 如果 progress >= max/2 则在y轴z轴上旋转M_PI
    if (self.animationProgress >= MaximumProgress / 2) {
        transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
        transform = CATransform3DRotate(transform, M_PI, 0, 0, 1);
        self.foldLabel.text = self.nextLabel.text;
    }
    self.foldLabel.layer.transform = transform;
    // 在foldLabel旋转到能盖住nextLabel上半部分的时候，显示nextLabel
    self.nextLabel.hidden = (currAngle < NextLabelStartAngel);
}

#pragma mark - setters

- (void)setFont:(UIFont *)font {
    _font = font;
    self.timeLabel.font = font;
    self.nextLabel.font = font;
    self.foldLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.timeLabel.textColor = textColor;
    self.nextLabel.textColor = textColor;
    self.foldLabel.textColor = textColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.bgView.backgroundColor     = backgroundColor;
    self.timeLabel.backgroundColor  = backgroundColor;
    self.nextLabel.backgroundColor  = backgroundColor;
    self.foldLabel.backgroundColor  = backgroundColor;
}

#pragma mark - getters

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [self configureLabel:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)foldLabel {
    if (!_foldLabel) {
        _foldLabel = [[UILabel alloc] init];
        [self configureLabel:_foldLabel];
    }
    return _foldLabel;
}

- (UILabel *)nextLabel {
    if (!_nextLabel) {
        _nextLabel = [[UILabel alloc] init];
        [self configureLabel:_nextLabel];
    }
    return _nextLabel;
}

@end
