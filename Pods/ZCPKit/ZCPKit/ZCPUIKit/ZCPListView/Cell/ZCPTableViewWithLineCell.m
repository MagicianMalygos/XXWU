//
//  PATableViewWithLineCell.m
//  Apartment
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewWithLineCell.h"

@implementation ZCPTableViewWithLineCell

@synthesize lineUpper   = _lineUpper;
@synthesize lineLower   = _lineLower;

// ----------------------------------------------------------------------
#pragma mark - setup
// ----------------------------------------------------------------------
- (void)setupContentView {
    [super setupContentView];
    self.clipsToBounds              = NO;
    self.contentView.clipsToBounds  = NO;
    
    // 初始化上下边线
    _lineUpper = [[UIView alloc] init];
    _lineLower = [[UIView alloc] init];
    
    [self addSubview:_lineUpper];
    [self addSubview:_lineLower];
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    ZCPTableViewCellDataModel *model     = (ZCPTableViewCellDataModel *)self.object;
    
    // 设置上下边线
    CGFloat upperOffset         = model.topLineLeftInset;
    CGFloat lowerOffset         = model.bottomLineLeftInset;
    CGFloat upperWidth          = model.topLineWidth;
    CGFloat lowerWidth          = model.bottomLineWidth;
    UIColor *upperLineColor     = model.topLineColor ? model.topLineColor : [UIColor colorFromHexRGB:@"dfdfdf"];
    UIColor *lowerLineColor     = model.bottomLineColor ? model.bottomLineColor : [UIColor colorFromHexRGB:@"dfdfdf"];
    
    _lineUpper.frame = CGRectMake(upperOffset, 0, upperWidth, OnePixel);
    _lineLower.frame = CGRectMake(lowerOffset, self.height - OnePixel, lowerWidth, OnePixel);
    _lineUpper.backgroundColor  = upperLineColor;
    _lineLower.backgroundColor  = lowerLineColor;
    
    [self bringSubviewToFront:_lineUpper];
    [self bringSubviewToFront:_lineLower];
    
    // 设置bgView frame
    self.selectedBackgroundView.frame = self.bounds;
}

@end
