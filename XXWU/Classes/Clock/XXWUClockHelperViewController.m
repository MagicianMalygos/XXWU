//
//  XXWUClockHelperViewController.m
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import "XXWUClockHelperViewController.h"

@interface XXWUClockHelperViewController ()

/// alert标题
@property (nonatomic, strong) UILabel *alertTitleLabel;
/// alert标题输入框
@property (nonatomic, strong) UITextField *alertTitleInputView;
/// alert内容
@property (nonatomic, strong) UILabel *alertBodyLabel;
/// alert内容输入框
@property (nonatomic, strong) UITextField *alertBodyInputView;
/// 快捷时间标题
@property (nonatomic, strong) UILabel *timesLabel;
/// 快捷时间输入框
@property (nonatomic, strong) UITextField *timesInputView;
/// 保存按钮
@property (nonatomic, strong) UIButton *saveButton;
/// 重置按钮
@property (nonatomic, strong) UIButton *resetButton;

@end

@implementation XXWUClockHelperViewController

#pragma mark - life cycle

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [self init]) {
        self.callback = [query objectForKey:@"_callback"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.alertTitleLabel.frame = CGRectMake(16, 16, 90, 30);
    self.alertTitleInputView.frame = CGRectMake(self.alertTitleLabel.right + 10, self.alertTitleLabel.top, self.view.width - 132, 30);
    self.alertBodyLabel.frame = CGRectMake(16, self.alertTitleLabel.bottom + 10, 90, 30);
    self.alertBodyInputView.frame = CGRectMake(self.alertBodyLabel.right + 10, self.alertBodyLabel.top, self.view.width - 132, 30);
    self.timesLabel.frame = CGRectMake(16, self.alertBodyLabel.bottom + 10, 90, 30);
    self.timesInputView.frame = CGRectMake(self.timesLabel.right + 10, self.timesLabel.top, self.view.width - 132, 30);
    self.saveButton.frame = CGRectMake(16, self.timesLabel.bottom + 20, (self.view.width - 42) * 3/4, 50);
    self.resetButton.frame = CGRectMake(self.saveButton.right + 10, self.saveButton.top, (self.view.width - 42) / 4, 50);
}

#pragma mark - setup

- (void)setupUI {
    [self.view addSubview:self.alertTitleLabel];
    [self.view addSubview:self.alertTitleInputView];
    [self.view addSubview:self.alertBodyLabel];
    [self.view addSubview:self.alertBodyInputView];
    [self.view addSubview:self.timesLabel];
    [self.view addSubview:self.timesInputView];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.resetButton];
}

- (void)setupData {
    self.alertTitleLabel.text = @"通知标题：";
    self.alertBodyLabel.text = @"通知内容：";
    self.timesLabel.text = @"快捷时间：";
    self.alertTitleInputView.placeholder = @"请输入通知标题";
    self.alertBodyInputView.placeholder = @"请输入通知内容";
    self.timesInputView.placeholder = @"请输入快捷时间，使用“,”分割";
    
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    // read cache
    NSDictionary *dict = ReadUserDefaults(kClockLocationAlertKey);
    self.alertTitleInputView.text = dict[@"title"];
    self.alertBodyInputView.text = dict[@"body"];
    self.timesInputView.text = ReadUserDefaults(kClockQuickTimesKey);
}

#pragma mark - event response

- (void)save {
    [self cacheData];
    [ZCPToastUtil showToast:@"保存成功"];
    if (self.callback) {
        self.callback();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reset {
    self.alertTitleInputView.text = @"闹钟⏰";
    self.alertBodyInputView.text = @"叮铃铃~~🔔";
    self.timesInputView.text = @"30,45,60,75,90";
    [self cacheData];
    [ZCPToastUtil showToast:@"重置成功"];
}

#pragma mark <help method>

- (void)cacheData {
    NSString *title = self.alertTitleInputView.text?:@"";
    NSString *body = self.alertBodyInputView.text?:@"";
    NSString *times = self.timesInputView.text?:@"";
    
    SaveUserDefaults(@{@"title": title, @"body": body}, kClockLocationAlertKey);
    SaveUserDefaults(times, kClockQuickTimesKey);
}

#pragma mark - getters and setters

- (UILabel *)alertTitleLabel {
    if (!_alertTitleLabel) {
        UILabel *label = [[UILabel alloc] init];
        _alertTitleLabel = label;
    }
    return _alertTitleLabel;
}

- (UITextField *)alertTitleInputView {
    if (!_alertTitleInputView) {
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.borderColor = [UIColor blackColor].CGColor;
        textField.layer.borderWidth = 1;
        _alertTitleInputView = textField;
    }
    return _alertTitleInputView;
}

- (UILabel *)alertBodyLabel {
    if (!_alertBodyLabel) {
        UILabel *label = [[UILabel alloc] init];
        _alertBodyLabel = label;
    }
    return _alertBodyLabel;
}

- (UITextField *)alertBodyInputView {
    if (!_alertBodyInputView) {
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.borderColor = [UIColor blackColor].CGColor;
        textField.layer.borderWidth = 1;
        _alertBodyInputView = textField;
    }
    return _alertBodyInputView;
}

- (UILabel *)timesLabel {
    if (!_timesLabel) {
        UILabel *label = [[UILabel alloc] init];
        _timesLabel = label;
    }
    return _timesLabel;
}

- (UITextField *)timesInputView {
    if (!_timesInputView) {
        UITextField *textField = [[UITextField alloc] init];
        textField.layer.borderColor = [UIColor blackColor].CGColor;
        textField.layer.borderWidth = 1;
        _timesInputView = textField;
    }
    return _timesInputView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor orangeColor];
        _saveButton = button;
    }
    return _saveButton;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor lightGrayColor];
        _resetButton = button;
    }
    return _resetButton;
}

@end
