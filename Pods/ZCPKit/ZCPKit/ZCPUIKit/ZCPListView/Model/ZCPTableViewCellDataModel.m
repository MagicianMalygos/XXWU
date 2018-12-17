//
//  ZCPCellDataModel.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewCellDataModel.h"

@implementation ZCPTableViewCellDataModel

// ----------------------------------------------------------------------
#pragma mark - @synthesize
// ----------------------------------------------------------------------
@synthesize cellClass           = _cellClass;
@synthesize cellType            = _cellType;
@synthesize cellHeight          = _cellHeight;
@synthesize cellSelResponse     = _cellSelResponse;
@synthesize showAccessory       = _showAccessory;
@synthesize topLineWidth        = _topLineWidth;
@synthesize topLineLeftInset    = _topLineLeftInset;
@synthesize topLineColor        = _topLineColor;
@synthesize bottomLineWidth     = _bottomLineWidth;
@synthesize bottomLineLeftInset = _bottomLineLeftInset;
@synthesize bottomLineColor     = _bottomLineColor;
@synthesize cellBgColor         = _cellBgColor;
@synthesize cellTag             = _cellTag;
@synthesize groupedCellPosition = _groupedCellPosition;
@synthesize eventBlock          = _eventBlock;
@synthesize useNib              = _useNib;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
+ (instancetype)modelFromDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDefault {
    if (self = [super init]) {
        self.groupedCellPosition    = ZCPGroupedCellPositionNone;
        self.topLineWidth           = APPLICATIONWIDTH;
        self.bottomLineWidth        = APPLICATIONWIDTH;
        self.cellTag                = INT_MAX;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return nil;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    ZCPTableViewCellDataModel *model    = [[[self class] alloc] init];
    model.idString                      = self.idString;
    model.eventBlock                    = [self.eventBlock copy];
    model.cellClass                     = self.cellClass;
    model.cellHeight                    = self.cellHeight;
    model.cellType                      = self.cellType;
    model.cellSelResponse               = self.cellSelResponse;
    model.cellTag                       = self.cellTag;
    model.groupedCellPosition           = self.groupedCellPosition;
    model.showAccessory                 = self.showAccessory;
    model.topLineWidth                  = self.topLineWidth;
    model.topLineLeftInset              = self.topLineLeftInset;
    model.topLineColor                  = self.topLineColor;
    model.bottomLineWidth               = self.bottomLineWidth;
    model.bottomLineLeftInset           = self.bottomLineLeftInset;
    model.bottomLineColor               = self.bottomLineColor;
    model.useNib                        = self.useNib;
    return model;
}

@end
