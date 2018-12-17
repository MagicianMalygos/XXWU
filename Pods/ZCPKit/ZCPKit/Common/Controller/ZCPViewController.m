//
//  ZCPViewController.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPViewController.h"

@implementation ZCPViewController

@synthesize tap                         = _tap;
@synthesize needsTapToDismissKeyboard   = _needsTapToDismissKeyboard;

// ----------------------------------------------------------------------
#pragma mark - life cycle
// ----------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 键盘点击隐藏事件
    self.needsTapToDismissKeyboard = @YES;
    if ([self isHideLeftBarButton] == NO) {
        [self setBackBarButton];
    }
    // 添加键盘响应事件
    [self registerKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc {
    // 移除键盘事件监听
    [self breakdown];
}

// ----------------------------------------------------------------------
#pragma mark - keyboard
// ----------------------------------------------------------------------
/**
 添加键盘监听
 */
- (void)registerKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

/**
 移除键盘监听
 */
- (void)breakdown {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

/**
 缩回键盘
 */
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if ([self.needsTapToDismissKeyboard boolValue]) {
        [self.view addGestureRecognizer:self.tap];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_tap) {
        [self.view removeGestureRecognizer:self.tap];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
}

// ----------------------------------------------------------------------
#pragma mark - Action Handler
// ----------------------------------------------------------------------
- (void)selfViewTapped:(UITapGestureRecognizer *)tap {
    if (tap.view == self.view) {
        // 让键盘消失
        [self dismissKeyboard];
    }
}

// ----------------------------------------------------------------------
#pragma mark - navigation bar
// ----------------------------------------------------------------------

- (BOOL)isHideLeftBarButton {
    return NO;
}

- (void)initNavigationBar {
}

//返回上级视图
- (void)backTo {
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.tabBarController.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]){
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setBackBarButton {
}

// ----------------------------------------------------------------------
#pragma mark - getter / setter
// ----------------------------------------------------------------------
- (UITapGestureRecognizer *)tap {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapped:)];
        _tap.cancelsTouchesInView = YES;
    }
    return _tap;
}

@end
