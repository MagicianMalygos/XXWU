//
//  FoldClockItemView.m
//  Demo
//
//  Created by 朱超鹏 on 2018/6/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "FoldClockItemView.h"

#define MAX_LENGTH  2

@interface FoldClockItemView ()

@property (nonatomic, strong) NSMutableArray <FoldClockLabel *>*labels;
@property (nonatomic, assign) NSInteger currentTime;

@end

@implementation FoldClockItemView

#pragma mark - life cycle

- (instancetype)init {
    return [self initWithTime:0];
}

- (instancetype)initWithTime:(NSInteger)time {
    if (self = [super init]) {
        self.currentTime = time;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        NSInteger a = time;
        NSInteger b = 0;
        
        for (int i = MAX_LENGTH - 1; i >= 0; i--) {
            b = a % 10;
            a = a / 10;
            
            FoldClockLabel *label = [[FoldClockLabel alloc] initWithTime:[@(b) stringValue]];
            [self addSubview:label];
            [self.labels insertObject:label atIndex:0];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat labelWidth = self.width / self.labels.count;
    for (int i = 0; i < self.labels.count; i++) {
        FoldClockLabel *label = self.labels[i];
        label.frame = CGRectMake(i * labelWidth, 0, labelWidth, self.height);
    }
}

#pragma mark - public

- (void)updateTime:(NSInteger)time {
    [self updateTime:time animated:YES];
}

- (void)updateTime:(NSInteger)time animated:(BOOL)animated {
    self.currentTime = time;
    
    NSInteger a = time;
    NSInteger b = 0;
    
    for (int i = MAX_LENGTH - 1; i >= 0; i--) {
        
        b = a % 10;
        a = a / 10;
        
        NSString *nextTime = [@(b) stringValue];
        FoldClockLabel *label = self.labels[i];
        
        if (![label.currentTime isEqualToString:nextTime]) {
            [label updateTime:nextTime animated:animated];
        }
    }
}

#pragma mark - setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    for (FoldClockLabel *label in self.labels) {
        label.backgroundColor = backgroundColor;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    for (FoldClockLabel *label in self.labels) {
        label.font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (FoldClockLabel *label in self.labels) {
        label.textColor = textColor;
    }
}

#pragma mark - getters

- (NSMutableArray <FoldClockLabel *>*)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

@end
