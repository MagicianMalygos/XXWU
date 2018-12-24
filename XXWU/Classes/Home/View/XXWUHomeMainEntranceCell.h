//
//  XXWUHomeMainEntranceCell.h
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXWUHomeMainEntranceView;

NS_ASSUME_NONNULL_BEGIN

/**
 首页主入口cell
 */
@interface XXWUHomeMainEntranceCell : ZCPTableViewCell

/// 左侧view
@property (nonatomic, strong) XXWUHomeMainEntranceView *leftView;
/// 右侧view
@property (nonatomic, strong) XXWUHomeMainEntranceView *rightView;

@end

/**
 首页主入口cell item
 */
@interface XXWUHomeMainEntranceCellItem : ZCPTableViewCellDataModel

/// 左侧视图icon
@property (nonatomic, copy) NSString *leftIcon;
/// 左侧视图标题
@property (nonatomic, copy) NSString *leftTitle;
/// 左侧视图背景颜色
@property (nonatomic, strong) UIColor *leftBackgroundColor;
/// 右侧视图icon
@property (nonatomic, copy) NSString *rightIcon;
/// 右侧视图icon
@property (nonatomic, copy) NSString *rightTitle;
/// 右侧视图背景颜色
@property (nonatomic, strong) UIColor *rightBackgroundColor;
/// 点击处理
@property (nonatomic, copy) void(^eventHandler)(BOOL isLeftView);

@end

NS_ASSUME_NONNULL_END
