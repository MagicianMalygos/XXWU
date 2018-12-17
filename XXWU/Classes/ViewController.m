//
//  ViewController.m
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIView *toolContainer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.urlTextField];
    [self.view addSubview:self.loadButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.toolContainer];
    [self addToolButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.urlTextField.text = self.defaultUrl;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.urlTextField.frame = CGRectMake(16, 64+16, self.view.width - 32, 50);
    self.loadButton.frame = CGRectMake(16, self.urlTextField.bottom + 16, (self.view.width - 48) * 3/4, 50);
    self.clearButton.frame = CGRectMake(self.loadButton.right + 16, self.urlTextField.bottom + 16, (self.view.width - 48) /4, 50);
    self.toolContainer.frame = CGRectMake(16, self.loadButton.bottom + 16, self.view.width - 32, self.view.height - self.loadButton.bottom - 32);
}

#pragma mark - private

- (void)addToolButton {
    for (UIView *view in self.toolContainer.subviews) {
        [view removeFromSuperview];
    }
    NSArray *array = @[@"https://", @"http://", @"www", @"www.", @".", @".com", @"com", @"www.baidu.com"];
    
    CGFloat w = 0;
    CGFloat h = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < array.count; i++) {
        w = ((self.view.width - 32) / 3) - 16;
        h = 30.0f;
        x = (i % 3) * ((self.view.width - 32) / 3) + 8;
        y = i / 3 * 46 + 8;
        
        UIButton *button = [self generateButtonWithTitle:array[i]];
        button.frame = CGRectMake(x, y, w, h);
        [self.toolContainer addSubview:button];
    }
}

- (UIButton *)generateButtonWithTitle:(NSString *)title {
    UIButton *button            = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor      = [UIColor lightGrayColor];
    button.titleLabel.font      = [UIFont systemFontOfSize:14.0f];
    button.layer.cornerRadius   = 5;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickToolButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - event response

- (void)clickLoad {
    if (self.delegate && [self.delegate respondsToSelector:@selector(generateUrl:)]) {
        [self.delegate generateUrl:self.urlTextField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickClear {
    self.urlTextField.text = @"";
}

- (void)clickToolButton:(UIButton *)button {
    self.urlTextField.text = [NSString stringWithFormat:@"%@%@", self.urlTextField.text, button.currentTitle];
}

#pragma mark - override

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - getters and setter

- (UITextField *)urlTextField {
    if (!_urlTextField) {
        _urlTextField                   = [[UITextField alloc] init];
        _urlTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _urlTextField.layer.borderWidth = 1;
        _urlTextField.font              = [UIFont systemFontOfSize:14.0f];
        _urlTextField.placeholder       = @"请输入链接";
    }
    return _urlTextField;
}

- (UIButton *)loadButton {
    if (!_loadButton) {
        _loadButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadButton.titleLabel.font     = [UIFont systemFontOfSize:16.0f];
        _loadButton.backgroundColor     = [UIColor orangeColor];
        _loadButton.layer.cornerRadius  = 8;
        _loadButton.layer.masksToBounds = YES;
        [_loadButton setTitle:@"加载" forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(clickLoad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadButton;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton                        = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.titleLabel.font        = [UIFont systemFontOfSize:16.0f];
        _clearButton.backgroundColor        = [UIColor lightGrayColor];
        _clearButton.layer.cornerRadius     = 8;
        _clearButton.layer.masksToBounds    = YES;
        [_clearButton setTitle:@"清空" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIView *)toolContainer {
    if (!_toolContainer) {
        _toolContainer = [[UIView alloc] init];
        _toolContainer.layer.borderColor = [UIColor blackColor].CGColor;
        _toolContainer.layer.borderWidth = 1;
    }
    return _toolContainer;
}

@end
