//
//  ZCPTableViewCell.m
//  Apartment
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewCell.h"

/*
    方法执行顺序 tableView:rowHeightForObject: -> setupContentView -> setObject: ->layoutSubViews
               返回cell高度                       初始化子视图         设置属性       设置frame
 */

@implementation ZCPTableViewCell

// ----------------------------------------------------------------------
#pragma mark - 返回cell高度
// ----------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    if (object && [object conformsToProtocol:@protocol(ZCPTableViewCellItemBasicProtocol)] && [object respondsToSelector:@selector(cellHeight)]) {
        return [object.cellHeight floatValue];
    }
    return 0;
}

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType  = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置空白透明
        [self clearBackgroundColor];
        
        // 初始化contentView
        [self setupContentView];
    }
    return self;
}

// ----------------------------------------------------------------------
#pragma mark - setup
// ----------------------------------------------------------------------
- (void)setupContentView {
}

- (void)setObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    _object = object;
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
}

// ----------------------------------------------------------------------
#pragma mark - 返回cell的重用标识
// ----------------------------------------------------------------------
+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
