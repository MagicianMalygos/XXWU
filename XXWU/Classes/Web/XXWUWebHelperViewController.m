//
//  XXWUWebHelperViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUWebHelperViewController.h"

@interface XXWUWebHelperViewController ()

/// url输入框
@property (nonatomic, strong) UITextField *urlInputView;
/// 加载按钮
@property (nonatomic, strong) UIButton *loadButton;
/// 清空按钮
@property (nonatomic, strong) UIButton *clearButton;
/// url片段快捷输入工具容器视图
@property (nonatomic, strong) UIView *toolContainer;
/// 清理缓存按钮
@property (nonatomic, strong) UIButton *cleanCacheButton;

@end

@implementation XXWUWebHelperViewController

#pragma mark - life cycle

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
        _defaultUrl = [query objectForKey:@"_defaultUrl"];
        _delegate = [query objectForKey:@"_delegate"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.urlInputView];
    [self.view addSubview:self.loadButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.cleanCacheButton];
    [self.view addSubview:self.toolContainer];
    [self addToolButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor   = [UIColor whiteColor];
    self.urlInputView.text      = self.defaultUrl;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.urlInputView.frame     = CGRectMake(16, 16, self.view.width - 32, 50);
    self.loadButton.frame       = CGRectMake(16, self.urlInputView.bottom + 16, (self.view.width - 48) * 3/4, 50);
    self.clearButton.frame      = CGRectMake(self.loadButton.right + 16, self.urlInputView.bottom + 16, (self.view.width - 48) /4, 50);
    self.cleanCacheButton.frame = CGRectMake(16, self.loadButton.bottom + 16, self.view.width - 32, 50);
    self.toolContainer.frame    = CGRectMake(16, self.cleanCacheButton.bottom + 16, self.view.width - 32, self.view.height - self.cleanCacheButton.bottom - 32);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(helperCallbackGenerateUrl:)]) {
        [self.delegate helperCallbackGenerateUrl:self.urlInputView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickClear {
    self.urlInputView.text = @"";
}

- (void)clickToolButton:(UIButton *)button {
    self.urlInputView.text = [NSString stringWithFormat:@"%@%@", self.urlInputView.text, button.currentTitle];
}

- (void)clickCleanjCacheButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(helperCallbackCleanWebViewCache)]) {
        [self.delegate helperCallbackCleanWebViewCache];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - override

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - getters and setter

- (UITextField *)urlInputView {
    if (!_urlInputView) {
        _urlInputView                   = [[UITextField alloc] init];
        _urlInputView.layer.borderColor = [UIColor blackColor].CGColor;
        _urlInputView.layer.borderWidth = 1;
        _urlInputView.font              = [UIFont systemFontOfSize:14.0f];
        _urlInputView.placeholder       = @"请输入链接";
        _urlInputView.layer.cornerRadius = 8;
        _urlInputView.layer.masksToBounds = YES;
    }
    return _urlInputView;
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
        _toolContainer.layer.cornerRadius = 8;
        _toolContainer.layer.masksToBounds = YES;
    }
    return _toolContainer;
}

- (UIButton *)cleanCacheButton {
    if (!_cleanCacheButton) {
        _cleanCacheButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cleanCacheButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _cleanCacheButton.backgroundColor = [UIColor orangeColor];
        _cleanCacheButton.layer.cornerRadius = 8;
        _cleanCacheButton.layer.masksToBounds = YES;
        [_cleanCacheButton setTitle:@"清除缓存" forState:UIControlStateNormal];
        [_cleanCacheButton addTarget:self action:@selector(clickCleanjCacheButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanCacheButton;
}

@end
