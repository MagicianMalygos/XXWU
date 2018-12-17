//
//  ZCPListDataModel.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPListDataModel.h"

@implementation ZCPListDataModel

#pragma mark - Public Method

// 获取列表中对应下标的对象
- (id)objectAtIndex:(NSUInteger)index {
    if (index < [self.items count]) {
        return [self.items objectAtIndex:index];
    }
    return nil;
}

#pragma mark - getter / setter

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
