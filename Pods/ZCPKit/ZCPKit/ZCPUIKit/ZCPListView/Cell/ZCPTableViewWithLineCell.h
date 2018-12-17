//
//  PATableViewWithLineCell.h
//  Apartment
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPBlankCell.h"

// 直接配置subview block
typedef void(^ZCPCellConfigBlock)(id subview);

// ----------------------------------------------------------------------
#pragma mark - 上下都有自定义边线的Cell
// ----------------------------------------------------------------------
@interface ZCPTableViewWithLineCell : ZCPBlankCell

// 上边线
@property (nonatomic, strong) UIView *lineUpper;
// 下边线
@property (nonatomic, strong) UIView *lineLower;

@end
