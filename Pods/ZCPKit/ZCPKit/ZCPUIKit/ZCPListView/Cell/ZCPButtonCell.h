//
//  ZCPButtonCell.h
//  Apartment
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPBlankCell.h"
@protocol ZCPButtonCellDelegate;

// 按钮初始状态枚举
typedef NS_ENUM(NSInteger, ZCPButtonInitState) {
    ZCPButtonInitStateNormal        = 1,
    ZCPButtonInitStateHighlighted   = 2,
    ZCPButtonInitStateDisabled      = 3
};

// ----------------------------------------------------------------------
#pragma mark - 只有一个Button的Cell
// ----------------------------------------------------------------------
@interface ZCPButtonCell : ZCPBlankCell

@property (nonatomic, strong) UIButton *button;                             // 按钮
@property (nonatomic, weak) id<ZCPButtonCellDelegate> delegate;             // delegate

@end

@interface ZCPButtonCellItem : ZCPTableViewCellDataModel

@property (nonatomic, copy)     NSString            *buttonTitle;                       // 按钮标题
@property (nonatomic, strong)   UIColor             *buttonTitleColorNormal;            // 按钮标题颜色(正常)
@property (nonatomic, strong)   UIColor             *buttonTitleColorHighlighted;       // 按钮标题颜色(高亮)
@property (nonatomic, strong)   UIFont              *buttonTitleFont;                   // 按钮标题字体
@property (nonatomic, strong)   UIColor             *buttonBackgroundColor;             // 按钮背景颜色
@property (nonatomic, strong)   UIImage             *buttonBackgroundImageNormal;       // 按钮背景图片(正常)
@property (nonatomic, strong)   UIImage             *buttonBackgroundImageHighlighted;  // 按钮背景图片(高亮)
@property (nonatomic, strong)   UIImage             *buttonBackgroundImageDisabled;     // 按钮背景图片(不可用)
@property (nonatomic, assign)   NSInteger           tag;                                // 按钮标识
@property (nonatomic, assign)   ZCPButtonInitState  state;                              // 按钮初始状态
@property (nonatomic, weak)     id<ZCPButtonCellDelegate> delegate;                     // delegate
@property (nonatomic, copy)     ZCPButtonConfigBlock buttonConfigBlock;                 // 按钮配置块

@end

@protocol ZCPButtonCellDelegate <NSObject>

// 按钮点击事件
- (void)buttonCell:(ZCPTableViewCell *)cell buttonClicked:(UIButton *)button;

@end
