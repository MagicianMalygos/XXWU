//
//  UILabel+Category.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "UILabel+Category.h"
#import "UIView+EasyFrame.h"
#import "ZCPGlobal.h"

@implementation UILabel (Category)

/// 设置label行间距
- (void)setLineSpace:(CGFloat)height{
    if (SYSTEM_VERSION < 6.0) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height];
    
    NSMutableAttributedString *attributedString = nil;
    if (self.attributedText != nil) {
        attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
        self.attributedText = attributedString;
        [self sizeToFit];
        return;
    }
    if (self.text.length > 0) {
        attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
        self.attributedText = attributedString;
        [self sizeToFit];
    }
}

/// sizeToFit带边距方法
- (void)sizeToFitWithEdge:(UIEdgeInsets)edgeInsets {
    [self sizeToFit];
    self.width  = self.width + edgeInsets.right + edgeInsets.left;
    self.height = self.height + edgeInsets.top + edgeInsets.bottom;
}

@end
