//
//  ZCPTextView.m
//  Apartment
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTextView.h"
#import "ZCPCategory.h"

@interface ZCPTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation ZCPTextView

@synthesize placeholder         = _placeholder;
@synthesize placeholderColor    = _placeholderColor;
@synthesize placeholderLabel    = _placeholderLabel;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
/**
 *  init/initWithFrame/new 会执行此方法，initWithCoder不会执行此方法
 */
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [super awakeFromNib];
        self.font = [UIFont systemFontOfSize:15.0f];    // 设置默认字体大小
        self.placeholder = @"";                         // 设置默认placeholder
        [self addSubview:self.placeholderLabel];        // 添加placeholderLabel
        
        // 添加对text的监听
        // 使用KVO监听不到text值的变化
//        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
/**
 *  使用IB创建时
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont systemFontOfSize:15.0f];    // 设置默认字体大小
    self.placeholder = @"";                         // 设置默认placeholder
    [self addSubview:self.placeholderLabel];        // 添加placeholderLabel
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

// ----------------------------------------------------------------------
#pragma mark - life cycle
// ----------------------------------------------------------------------
- (void)dealloc {
    // 移除text监听
//    [self removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

// ----------------------------------------------------------------------
#pragma mark - getter / setter
// ----------------------------------------------------------------------
- (void)setText:(NSString *)text {
    [super setText:text];
    if ([text isEqualToString:@""]) {
        self.placeholderLabel.alpha = 1.0f;
    }
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    // 设置placeholderLabel的font并做自适应frame
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFitWithEdge:UIEdgeInsetsMake(8.5f, 0.0f, 8.5f, 0.0f)];
}
- (void)setPlaceholder:(NSString *)placeholder {
    if (_placeholder == placeholder) {
        return;
    }
    _placeholder = (placeholder)? [placeholder mutableCopy]: @"";
    // 设置placeholderLabel的font并做自适应frame
    self.placeholderLabel.text = _placeholder;
    [self.placeholderLabel sizeToFitWithEdge:UIEdgeInsetsMake(8.5f, 0.0f, 8.5f, 0.0f)];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (_placeholderColor == placeholderColor) {
        return;
    }
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (UILabel *)placeholderLabel {
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 0.0f, 0.0f)];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _placeholderLabel;
}

// ----------------------------------------------------------------------
#pragma mark - notification callback
// ----------------------------------------------------------------------
- (void)textDidChange:(NSNotification *)notification {
    if (self.placeholder.length == 0) {
        return;
    }
    if (self.text.length != 0) {
        self.placeholderLabel.alpha = 0.0f;
    }
    else {
        self.placeholderLabel.alpha = 1.0f;
    }
}

@end
