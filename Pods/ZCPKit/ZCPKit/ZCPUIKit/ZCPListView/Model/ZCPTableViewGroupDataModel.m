//
//  ZCPTableViewGroupDataModel.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/7/30.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPTableViewGroupDataModel.h"

@implementation ZCPTableViewGroupDataModel

// ----------------------------------------------------------------------
#pragma mark - @synthesize
// ----------------------------------------------------------------------
@synthesize sectionCellItems    = _sectionCellItems;
@synthesize sectionFooterClass  = _sectionFooterClass;
@synthesize sectionFooterData   = _sectionFooterData;
@synthesize sectionHeaderClass  = _sectionHeaderClass;
@synthesize sectionHeaderData   = _sectionHeaderData;

// ----------------------------------------------------------------------
#pragma mark - getters
// ----------------------------------------------------------------------
- (NSMutableArray *)sectionCellItems {
    if (!_sectionCellItems) {
        _sectionCellItems = [[NSMutableArray alloc] init];
    }
    return _sectionCellItems;
}

@end
