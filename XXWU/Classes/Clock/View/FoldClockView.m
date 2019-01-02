//
//  FoldClockView.m
//  Demo
//
//  Created by 朱超鹏 on 2018/6/28.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "FoldClockView.h"
#import "FoldClockItemView.h"

@interface FoldClockView ()

@property (nonatomic, strong) FoldClockItemView *hourItem;
@property (nonatomic, strong) FoldClockItemView *minuteItem;
@property (nonatomic, strong) FoldClockItemView *secondItem;
@property (nonatomic, strong) UIView *splitLine;

@end

@implementation FoldClockView

#pragma mark - life cycle

- (instancetype)init {
    return [self initWithDate:[NSDate date]];
}

- (instancetype)initWithDate:(NSDate *)date {
    if (self = [super initWithFrame:CGRectZero]) {
        [self addSubview:self.hourItem];
        [self addSubview:self.minuteItem];
        [self addSubview:self.secondItem];
        [self addSubview:self.splitLine];
        
        // 默认值
        self.backgroundColor            = [UIColor blackColor];
        self.hourItem.backgroundColor   = [UIColor darkGrayColor];
        self.minuteItem.backgroundColor = [UIColor darkGrayColor];
        self.secondItem.backgroundColor = [UIColor darkGrayColor];
        self.hourItem.textColor         = [UIColor grayColor];
        self.minuteItem.textColor       = [UIColor grayColor];
        self.secondItem.textColor       = [UIColor grayColor];

        self.itemInsets                 = UIEdgeInsetsMake(20, 20, 20, 20);
        self.itemSpacing                = 20;
        self.layer.cornerRadius         = 5;
        self.layer.masksToBounds        = YES;

        [self setDate:date animated:NO];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemWidth       = (self.width - self.itemInsets.left - self.itemInsets.right - 2*self.itemSpacing) / 3;
    CGFloat itemHeight      = self.height - self.itemInsets.top - self.itemInsets.bottom;
    
    self.hourItem.frame     = CGRectMake(self.itemInsets.left, self.itemInsets.top, itemWidth, itemHeight);
    self.minuteItem.frame   = CGRectMake(self.hourItem.right + self.itemSpacing, self.itemInsets.top, itemWidth, itemHeight);
    self.secondItem.frame   = CGRectMake(self.minuteItem.right + self.itemSpacing, self.itemInsets.top, itemWidth, itemHeight);
    self.splitLine.frame    = CGRectMake(0, (self.height - self.splitLineHeight) / 2, self.width, self.splitLineHeight);
}

#pragma mark - setters

- (void)setDate:(NSDate *)date {
    [self setDate:date animated:YES];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    _date = date;
    NSCalendar *calendar            = [NSCalendar currentCalendar];
    NSUInteger unitFlags            = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];

    [self.hourItem updateTime:dateComponent.hour animated:animated];
    [self.minuteItem updateTime:dateComponent.minute animated:animated];
    [self.secondItem updateTime:dateComponent.second animated:animated];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    // font缺省值，因为缺省值与view的width有关，所以写在setFrame方法中
    if (!self.font) {
        CGFloat itemWidth       = (self.width - self.itemInsets.left - self.itemInsets.right - 2*self.itemSpacing) / 3;
        UIFont *defaultFont     = [UIFont fontWithName:@"AmericanTypewriter-Condensed" size:itemWidth / 2];
        self.hourItem.font      = defaultFont;
        self.minuteItem.font    = defaultFont;
        self.secondItem.font    = defaultFont;
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.hourItem.font      = font;
    self.minuteItem.font    = font;
    self.secondItem.font    = font;
}

- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor {
    _itemBackgroundColor = itemBackgroundColor;
    self.hourItem.backgroundColor   = itemBackgroundColor;
    self.minuteItem.backgroundColor = itemBackgroundColor;
    self.secondItem.backgroundColor = itemBackgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.splitLine.backgroundColor = backgroundColor;
}

- (void)setSplitLineHeight:(CGFloat)splitLineHeight {
    _splitLineHeight = splitLineHeight;
    [self setNeedsLayout];
}

#pragma mark - getters and setters

- (FoldClockItemView *)hourItem {
    if (!_hourItem) {
        _hourItem = [[FoldClockItemView alloc] initWithTime:0];
    }
    return _hourItem;
}

- (FoldClockItemView *)minuteItem {
    if (!_minuteItem) {
        _minuteItem = [[FoldClockItemView alloc] initWithTime:0];
    }
    return _minuteItem;
}

- (FoldClockItemView *)secondItem {
    if (!_secondItem) {
        _secondItem = [[FoldClockItemView alloc] initWithTime:0];
    }
    return _secondItem;
}

- (UIView *)splitLine {
    if (!_splitLine) {
        _splitLine = [[UIView alloc] init];
    }
    return _splitLine;
}

@end
