//
//  ZCPTableViewCellItemBasicProtocol.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 cell所在的位置。用于辅助控制cell的上下边线显示

 - ZCPGroupedCellPositionNone:      默认
 - ZCPGroupedCellPositionFirst:     首位
 - ZCPGroupedCellPositionMiddle:    中间
 - ZCPGroupedCellPositionLast:      末位
 */
typedef NS_ENUM(NSUInteger, ZCPGroupedCellPosition) {
    ZCPGroupedCellPositionNone,
    ZCPGroupedCellPositionFirst,
    ZCPGroupedCellPositionMiddle,
    ZCPGroupedCellPositionLast
};

typedef void(^ZCPEventBlock)(id object);

// ----------------------------------------------------------------------
#pragma mark - cell model适配协议
// ----------------------------------------------------------------------
@protocol ZCPTableViewCellItemBasicProtocol <NSObject>

/// cell的类
@property (nonatomic, strong)   Class           cellClass;
/// cell类型
@property (nonatomic, copy)     NSString        *cellType;
/// cell高度
@property (nonatomic, strong)   NSNumber        *cellHeight;
/// cell响应对象
@property (nonatomic, weak)     id              cellSelResponse;

// 上边线属性
/// 上边线尺寸，默认为0
@property (nonatomic, assign)   CGFloat         topLineWidth;
/// 上边线左侧缩进值，默认为0
@property (nonatomic, assign)   CGFloat         topLineLeftInset;
/// 上边线颜色，默认为白色
@property (nonatomic, strong)   UIColor         *topLineColor;
// 下边线属性
/// 下边线尺寸，默认为0
@property (nonatomic, assign)   CGFloat         bottomLineWidth;
/// 下边线左侧缩进值，默认为0
@property (nonatomic, assign)   CGFloat         bottomLineLeftInset;
/// 下边线颜色，默认为白色
@property (nonatomic, strong)   UIColor         *bottomLineColor;

/// 是否显示右侧小箭头图标
@property (nonatomic, assign)   BOOL            showAccessory;
/// cell背景颜色
@property (nonatomic, strong)   UIColor         *cellBgColor;
/// cell 标识
@property (nonatomic, assign)   int             cellTag;
/// cell的位置
@property (nonatomic, assign)   ZCPGroupedCellPosition groupedCellPosition;
/// 事件块
@property (nonatomic, copy)     ZCPEventBlock   eventBlock;
/// 是否使用nib
@property (nonatomic, assign)   BOOL            useNib;

@end
