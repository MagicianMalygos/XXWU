//
//  ZCPSectionCell.h
//  Apartment
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPBlankCell.h"

// sectiontitlelabel位置
typedef NS_ENUM(NSInteger, ZCPSectionTitlePosition) {
    ZCPSectionTitleNonePosition     = 1 << 0, // 无
    ZCPSectionTitleMiddlePosition   = 1 << 1, // 中
    ZCPSectionTitleTopPosition      = 1 << 2, // 上
    ZCPSectionTitleBottomPosition   = 1 << 3, // 下
    ZCPSectionTitleLeftPosition     = 1 << 4, // 左
    ZCPSectionTitleRightPosition    = 1 << 5  // 右
};

// ----------------------------------------------------------------------
#pragma mark - Section Cell
// ----------------------------------------------------------------------
// 用作Section的Cell
@interface ZCPSectionCell : ZCPBlankCell

@property (nonatomic, strong)   UILabel                 *sectionTitleLabel;     // section标题标签

@end

// ----------------------------------------------------------------------
#pragma mark - Section CellItem
// ----------------------------------------------------------------------
@interface ZCPSectionCellItem : ZCPTableViewCellDataModel

@property (nonatomic, copy)     NSString                *sectionTitle;          // section标题
@property (nonatomic, strong)   UIFont                  *sectionTitleFont;      // section字体
@property (nonatomic, strong)   NSAttributedString      *sectionAttrTitle;      // section富文本标题
@property (nonatomic, assign)   UIEdgeInsets            sectionTitleEdgeInset;  // section标题边距
@property (nonatomic, assign)   ZCPSectionTitlePosition sectionTitlePosition;   // section文本位置

@end
