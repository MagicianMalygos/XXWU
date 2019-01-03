//
//  XXWUClockQuickToolView.m
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import "XXWUClockQuickToolView.h"

#define LineNumber  4
#define ButtonH     50

@interface XXWUClockQuickToolView ()

/// 时间数组
@property (nonatomic, strong) NSArray *timeArr;
/// 时间按钮数组
@property (nonatomic, strong) NSMutableArray *buttonArr;

@end

@implementation XXWUClockQuickToolView

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.width - LineNumber*10 - 32) / LineNumber;
    CGFloat h = ButtonH;
    
    for (NSInteger i = 0; i < self.buttonArr.count; i++) {
        UIButton *button = self.buttonArr[i];
        x = 16 + (i % LineNumber) * (w + 10);
        y = 16 + (i / LineNumber) * (h + 10);
        button.frame = CGRectMake(x, y, w, h);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSInteger lineCount = (self.buttonArr.count / LineNumber + 1);
    return CGSizeMake(self.superview.width, lineCount * ButtonH + (lineCount - 1) * 10 + 32);
}


#pragma mark - UI

- (void)updateUI {
    for (UIButton *button in self.buttonArr) {
        [button removeFromSuperview];
    }
    [self.buttonArr removeAllObjects];
    
    for (NSString *time in self.timeArr) {
        UIButton *button = [self generateButtonWithTime:time];
        [self.buttonArr addObject:button];
        [self addSubview:button];
    }
    [self setNeedsLayout];
}

- (UIButton *)generateButtonWithTime:(NSString *)time {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorFromHexRGB:@"FF8C00"];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setTitle:time forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - public

- (void)update {
    NSString *timesStr = ReadUserDefaults(kClockQuickTimesKey);
    if (!timesStr) {
        return;
    }
    self.timeArr = [timesStr componentsSeparatedByString:@","];
}

#pragma mark - event response

- (void)clickButton:(UIButton *)button {
    NSInteger time = button.titleLabel.text.integerValue;
    NSInteger hour = time / 60;
    NSInteger minute = time % 60;
    NSInteger second = 0;
    
    if (self.responseBlock) {
        self.responseBlock(hour, minute, second);
    }
}

#pragma mark - getters and setters

- (void)setTimeArr:(NSArray *)timeArr {
    _timeArr = timeArr;
    [self updateUI];
}

- (NSMutableArray *)buttonArr {
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

@end
