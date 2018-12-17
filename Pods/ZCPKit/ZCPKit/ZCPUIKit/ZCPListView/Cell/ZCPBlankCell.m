//
//  ZCPBlankCell.m
//  Apartment
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPBlankCell.h"
#import "ZCPTableViewCell+BackgroundColor.h"

@implementation ZCPBlankCell

// ----------------------------------------------------------------------
#define mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    ZCPTableViewCellDataModel *item = (ZCPTableViewCellDataModel *)self.object;
    
    // 设置cell背景颜色
    UIColor *bgColor = item.cellBgColor ? item.cellBgColor : [UIColor whiteColor];
    self.customBackgroundColor = bgColor;
}

@end
