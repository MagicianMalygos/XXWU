//
//  XXWULoginViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWULoginViewController.h"

@interface XXWULoginViewController ()

/// 提示信息
@property (nonatomic, strong) UILabel *tipLabel;
/// 密码输入框
@property (nonatomic, strong) UITextField *passwordInputView;
/// 登陆按钮
@property (nonatomic, strong) UIButton *loginButton;

// Query
@property (nonatomic, copy) NSString *url;

@end

@implementation XXWULoginViewController

#pragma mark - life cycle

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
        self.url = [query objectForKey:@"url"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"请登陆";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat tipHeight = [self.tipLabel sizeThatFits:CGSizeMake(self.view.width-32, MAXFLOAT)].height;
    self.tipLabel.frame = CGRectMake(16, 50, self.view.width-32, tipHeight);
    self.passwordInputView.frame = CGRectMake(16, self.tipLabel.bottom + 20, self.view.width-32, 55);
    self.loginButton.frame = CGRectMake(16, self.passwordInputView.bottom + 50, self.view.width - 32, 55);
}

#pragma mark - load

- (void)loadViews {
    // add
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.passwordInputView];
    [self.view addSubview:self.loginButton];
    
    // pro
    self.tipLabel.text = @"您需要通过密码校验之后才能继续进行后续操作！";
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    
    // event
    [self.loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - event response

- (void)clickLoginButton {
    NSString *password = self.passwordInputView.text;
    
    // judge
    if (!password || password.length == 0) {
        [ZCPToastUtil showToast:@"请输入密码！"];
        return;
    }
    
    // judge
    if (![password isEqualToString:@"xxwu"]) {
        [ZCPToastUtil showToast:@"密码不正确！"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&secret=%@", self.url, password];
    
    // jump
    openURL(url);
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (vc == self) {
            NSMutableArray *newVCs = self.navigationController.viewControllers.mutableCopy;
            [newVCs removeObject:vc];
            self.navigationController.viewControllers = newVCs;
            break;
        }
    }
}

#pragma mark - getters and setters

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UITextField *)passwordInputView {
    if (!_passwordInputView) {
        _passwordInputView = [[UITextField alloc] init];
        _passwordInputView.placeholder = @"请输入登陆密码";
        _passwordInputView.font = [UIFont boldSystemFontOfSize:24.0f];
    }
    return _passwordInputView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor blueColor];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:24];
    }
    return _loginButton;
}

@end
