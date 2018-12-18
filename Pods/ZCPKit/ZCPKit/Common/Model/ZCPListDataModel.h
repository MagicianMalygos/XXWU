//
//  ZCPListDataModel.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPDataModel.h"

// ----------------------------------------------------------------------
#pragma mark - 列表模型
// ----------------------------------------------------------------------
@interface ZCPListDataModel : ZCPDataModel

// 数据数组
@property (nonatomic, strong) NSMutableArray *items;
// 当前页码
@property (nonatomic, strong) NSNumber *page;
// 当前页面数据数量
@property (nonatomic, strong) NSNumber *rows;
// 是否有更多
@property (nonatomic, assign) BOOL hasMore;
// 页面起始位置标记
@property (nonatomic, assign) NSInteger start;
// 每次服务器返回的最大数据数量
@property (nonatomic, assign) NSInteger max;
// 总数量
@property (nonatomic, assign) NSInteger totalRecords;

// 获取列表中对应下标的对象
- (id)objectAtIndex:(NSUInteger)index;

@end
