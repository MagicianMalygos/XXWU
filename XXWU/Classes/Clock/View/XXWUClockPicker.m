//
//  XXWUClockPicker.m
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import "XXWUClockPicker.h"

@interface XXWUClockPicker () <UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong) NSArray <NSArray *>*componentArr;
@property (nonatomic, strong) NSArray *hourDataSource;
@property (nonatomic, strong) NSArray *minuteDataSource;
@property (nonatomic, strong) NSArray *secondDataSource;

/// 遮罩
@property (nonatomic, strong) UIView *maskView;
/// 容器视图
@property (nonatomic, strong) UIView *containerView;
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 确认按钮
@property (nonatomic, strong) UIButton *confirmButton;
/// 分割线
@property (nonatomic, strong) UIView *splitLine;

/// 选择的值
@property (nonatomic, assign) NSInteger selectedHour;
@property (nonatomic, assign) NSInteger selectedMinute;
@property (nonatomic, assign) NSInteger selectedSecond;

@end

@implementation XXWUClockPicker

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.maskView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.picker];
    [self.containerView addSubview:self.splitLine];
    [self.containerView addSubview:self.cancelButton];
    [self.containerView addSubview:self.confirmButton];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [self.cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = self.bounds;
    self.containerView.frame = CGRectMake(0, self.height - 300, self.width, 300);
    self.cancelButton.frame = CGRectMake(16, 0, 50, 50);
    self.confirmButton.frame = CGRectMake(self.containerView.width - 66, 0, 50, 50);
    self.splitLine.frame = CGRectMake(0, 50, self.width, 1);
    self.picker.frame = CGRectMake(0, 51, self.width, self.containerView.height - self.splitLine.bottom);
}

#pragma mark - public

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

#pragma mark - event response

- (void)clickConfirmButton {
    if (self.confirmBlock) {
        self.confirmBlock(self.selectedHour, self.selectedMinute, self.selectedSecond);
    }
    [self hide];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.componentArr.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.componentArr[component].count;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.componentArr[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger value = [self.componentArr[component][row] integerValue];
    if (component == 0) {
        self.selectedHour = value;
    } else if (component == 1) {
        self.selectedMinute = value;
    } else if (component == 2) {
        self.selectedSecond = value;
    }
}

#pragma mark - getters and setters

- (UIPickerView *)picker {
    if (!_picker) {
        _picker = [[UIPickerView alloc] init];
        _picker.dataSource = self;
        _picker.delegate = self;
    }
    return _picker;
}

- (NSArray *)componentArr {
    if (!_componentArr) {
        _componentArr = @[self.hourDataSource, self.minuteDataSource, self.secondDataSource];
    }
    return _componentArr;
}

- (NSArray *)hourDataSource {
    if (!_hourDataSource) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i <= 24; i++) {
            [arr addObject:[@(i) stringValue]];
        }
        _hourDataSource = arr.copy;
    }
    return _hourDataSource;
}

- (NSArray *)minuteDataSource {
    if (!_minuteDataSource) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i <= 59; i++) {
            [arr addObject:[@(i) stringValue]];
        }
        _minuteDataSource = arr.copy;
    }
    return _minuteDataSource;
}

- (NSArray *)secondDataSource {
    if (!_secondDataSource) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i <= 59; i++) {
            [arr addObject:[@(i) stringValue]];
        }
        _secondDataSource = arr.copy;
    }
    return _secondDataSource;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorFromHexRGB:@"333333"] forState:UIControlStateNormal];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton = button;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor colorFromHexRGB:@"1C86EE"] forState:UIControlStateNormal];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton = button;
    }
    return _confirmButton;
}

- (UIView *)splitLine {
    if (!_splitLine) {
        _splitLine = [[UIView alloc] init];
        _splitLine.backgroundColor = [UIColor colorFromHexRGB:@"dfdfdf"];
    }
    return _splitLine;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _maskView;
}

@end
