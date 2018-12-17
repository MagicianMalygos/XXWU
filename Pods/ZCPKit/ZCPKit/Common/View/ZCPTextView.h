//
//  ZCPTextView.h
//  Apartment
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

// ----------------------------------------------------------------------
#pragma mark - 自定义TextView
// ----------------------------------------------------------------------
// 扩展UITextView，使其具有placeholder功能
@interface ZCPTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;          // Placeholder
@property (nonatomic, strong) UIColor *placeholderColor;    // Placeholder颜色

@end
