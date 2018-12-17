//
//  ZCPListTableViewAdaptor.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPListTableViewAdaptor.h"
#import "ZCPTableViewCell.h"

@implementation ZCPListTableViewAdaptor

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

/// 返回section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsWithSection:section];
}

/// 返回section下cell个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self numberOfSections];
}

/// 返回indexpath对应的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<ZCPTableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    
    NSString *identifier  = [self identifierForCellAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        // 生成cell
        cell = [self generateCellForObject:object indexPath:indexPath identifier:identifier];
    }
    
    if (!cell) {
        NSLog(@"Catch up a bug!!! row: %tu", indexPath.row);
    }
    
    // 设置cell
    if ([cell isKindOfClass:[ZCPTableViewCell class]]) {
        [(ZCPTableViewCell *)cell setObject:object];
    }
    
    // 通过delegate在外部补充设置
    if ([self.delegate respondsToSelector:@selector(tableView:didSetObject:cell:)]) {
        [self.delegate tableView:tableView didSetObject:object cell:cell];
    }
    return cell;
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

/// 返回指定indexPath的cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height      = 0;
    if (self.tableView == nil) {
        self.tableView  = tableView;
    }
    height              = [self heightForRowAtIndexPath:indexPath];
    return height;
}
/// 点击cell事件回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id<ZCPTableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectObject:rowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectObject:object rowAtIndexPath:indexPath];
    }
}

/// 返回是否能左滑编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
        return [self.delegate tableView:self.tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

/// 返回左滑编辑按钮样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

/// 点击左滑编辑按钮事件回调
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.delegate tableView:self.tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

/// 返回左滑编辑标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]) {
        return [self.delegate tableView:self.tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return @"删除";
}

// ----------------------------------------------------------------------
#pragma mark - help method
// ----------------------------------------------------------------------

/**
 根据cell model生成cell

 @param object cell model
 @param indexPath 索引
 @param identifier 重用标识
 @return cell
 */
- (ZCPTableViewCell *)generateCellForObject:(id<ZCPTableViewCellItemBasicProtocol>)object indexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier {
    if (!object) {
        return nil;
    }
    
    ZCPTableViewCell *cell  = nil;
    Class cellClass         = [self cellClassForObject:object];
    
    if (object.useNib == YES) {
        UINib *nib  = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil];
        cell        = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    } else {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

/**
 返回cell高度

 @param indexPath 索引
 @return cell高度
 */
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight       = 0;
    
    UITableView * tableView = self.tableView;
    id object               = [self objectForRowAtIndexPath:indexPath];
    
    Class cellClass         = [self cellClassForIndexPath:indexPath];
    rowHeight               = [cellClass tableView:tableView rowHeightForObject:object];
    
    return rowHeight;
}

/**
 返回section个数
 */
- (NSInteger)numberOfSections {
    return 1;
}

/**
 返回cell个数
 */
- (NSInteger)numberOfRowsWithSection:(NSInteger)section {
    return self.items.count;
}

/**
 通过cell model获得cell class

 @param object cell model
 @return cell class
 */
- (Class)cellClassForObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    Class cellClass = nil;
    if (object && [object respondsToSelector:@selector(cellClass)]) {
        cellClass   = [object cellClass];
    }
    return cellClass;
}

/**
 通过索引获得cell class

 @param indexPath 索引
 @return cell class
 */
- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = nil;
    id<ZCPTableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    cellClass       = [self cellClassForObject:object];
    return cellClass;
}

/**
 通过索引获取cell model

 @param indexPath 索引
 @return cell model
 */
- (id<ZCPTableViewCellItemBasicProtocol>)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object   = nil;
    if (self.items.count > indexPath.row) {
        object  = [self.items objectAtIndex:indexPath.row];
    }
    return object;
}

/**
 通过索引获取cell type

 @param indexPath 索引
 @return cell type
 */
- (NSString *)cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType  = nil;
    id<ZCPTableViewCellItemBasicProtocol> object = [self objectForRowAtIndexPath:indexPath];
    if (object) {
        cellType        = [object cellType];
    }
    return cellType;
}

/**
 通过索引获取cell identifier

 @param indexPath 索引
 @return cell identifier
 */
- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier    = nil;
    identifier              = [self cellTypeAtIndexPath:indexPath];
    return identifier;
}

// ----------------------------------------------------------------------
#pragma mark - setter / getter
// ----------------------------------------------------------------------

- (NSMutableArray *)items {
    if (_items == nil) {
        self.items = [NSMutableArray array];
    }
    return _items;
}

@end
