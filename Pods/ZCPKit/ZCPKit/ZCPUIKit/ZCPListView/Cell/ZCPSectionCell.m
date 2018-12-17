//
//  ZCPSectionCell.m
//  Apartment
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPSectionCell.h"

@implementation ZCPSectionCell

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize sectionTitleLabel   = _sectionTitleLabel;

// ----------------------------------------------------------------------
#pragma mark - 返回cell高度
// ----------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    CGFloat cellHeight = 0;
    if (object && [object isKindOfClass:[ZCPSectionCellItem class]]) {
        if ([object cellHeight]) {
            cellHeight = [[object cellHeight] floatValue];
        }
    }
    return cellHeight;
}

#pragma mark - setup
- (void)setupContentView {
    [super setupContentView];
    
    // 初始化section label
    _sectionTitleLabel                  = [[UILabel alloc] init];
    _sectionTitleLabel.backgroundColor  = [UIColor clearColor];
    _sectionTitleLabel.numberOfLines    = 1;
    [self.contentView addSubview:_sectionTitleLabel];
}

- (void)setObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    if (object && [object isKindOfClass:[ZCPSectionCellItem class]]) {
        [super setObject:object];
        
        ZCPSectionCellItem *item = (ZCPSectionCellItem *)object;
        
        if (![item.sectionAttrTitle length]) {
            // 使用普通文本
            _sectionTitleLabel.font     = item.sectionTitleFont;
            _sectionTitleLabel.text     = item.sectionTitle;
        } else {
            // 使用富文本
            _sectionTitleLabel.attributedText = item.sectionAttrTitle;
        }
    }
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    ZCPSectionCellItem *item = (ZCPSectionCellItem *)self.object;
    
    // 处理section边距
    UIEdgeInsets insets = item.sectionTitleEdgeInset;
    if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        self.sectionTitleLabel.frame = CGRectMake(MARGIN_HORIZONTAL, insets.top, self.width - MARGIN_HORIZONTAL * 2, self.height - insets.top - insets.bottom);
    } else {
        self.sectionTitleLabel.frame = CGRectMake(insets.left, insets.top, self.width - insets.left - insets.right, self.height - insets.top - insets.bottom);
    }
    
    CGFloat midPosiHeight = self.sectionTitleLabel.height;
    CGFloat wordHeight = self.sectionTitleLabel.font.lineHeight;
    CGFloat labelHeight = (wordHeight < midPosiHeight)? wordHeight: midPosiHeight;
    
    // 处理section位置
    if (item.sectionTitlePosition & ZCPSectionTitleNonePosition) {
    }
    if (item.sectionTitlePosition & ZCPSectionTitleMiddlePosition) {
        self.sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (item.sectionTitlePosition & ZCPSectionTitleTopPosition) {
        self.sectionTitleLabel.height = labelHeight;
        self.sectionTitleLabel.top = insets.top;
    }
    if (item.sectionTitlePosition & ZCPSectionTitleBottomPosition) {
        self.sectionTitleLabel.height = labelHeight;
        self.sectionTitleLabel.bottom = self.height - insets.bottom;
    }
    if (item.sectionTitlePosition & ZCPSectionTitleLeftPosition) {
        self.sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    if (item.sectionTitlePosition & ZCPSectionTitleRightPosition) {
        self.sectionTitleLabel.textAlignment = NSTextAlignmentRight;
    }
}

@end


@implementation ZCPSectionCellItem

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize sectionTitle            = _sectionTitle;
@synthesize sectionTitleFont        = _sectionTitleFont;
@synthesize sectionAttrTitle        = _sectionAttrTitle;
@synthesize sectionTitleEdgeInset   = _sectionTitleEdgeInset;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)init {
    if (self = [super init]) {
        self.cellClass              = [ZCPSectionCell class];
        self.cellType               = [ZCPSectionCell cellIdentifier];
        self.sectionTitleEdgeInset  = UIEdgeInsetsZero;
        self.sectionTitlePosition   = ZCPSectionTitleMiddlePosition;
    }
    return self;
}
- (instancetype)initWithDefault {
    if (self = [super initWithDefault]) {
        self.cellClass              = [ZCPSectionCell class];
        self.cellType               = [ZCPSectionCell cellIdentifier];
        self.sectionTitleFont       = [UIFont systemFontOfSize:14.0f];
        self.sectionTitlePosition   = ZCPSectionTitleMiddlePosition;
        self.sectionTitleEdgeInset  = UIEdgeInsetsZero;
        self.cellHeight             = @20;
    }
    return self;
}

@end
