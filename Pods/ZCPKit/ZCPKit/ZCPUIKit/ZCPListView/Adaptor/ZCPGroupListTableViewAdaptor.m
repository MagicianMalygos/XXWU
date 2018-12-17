//
//  ZCPGroupListTableViewAdaptor.m
//  Aspects-iOS11.0
//
//  Created by 朱超鹏 on 2018/7/30.
//

#import "ZCPGroupListTableViewAdaptor.h"
#import <objc/runtime.h>
#import "ZCPTableViewCell.h"

@implementation ZCPGroupListTableViewAdaptor

@synthesize items       = _items;
@synthesize delegate    = _delegate;

// ----------------------------------------------------------------------
#pragma mark - UITableViewDataSource
// ----------------------------------------------------------------------

/// 返回section下cell个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

// ----------------------------------------------------------------------
#pragma mark - UITableViewDelegate
// ----------------------------------------------------------------------

/// 返回指定section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = [self objectForSection:section];
    if (sectionItem.sectionHeaderClass) {
        Method fringeHeightMethod = class_getClassMethod(sectionItem.sectionHeaderClass, @selector(sectionFringeHeightForObject:));
        if (fringeHeightMethod) {
            return [sectionItem.sectionHeaderClass sectionFringeHeightForObject:sectionItem.sectionHeaderData];
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:objectForHeader:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSection:section objectForHeader:sectionItem.sectionHeaderData];
    }
    return 0;
}

/// 返回指定section头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = [self objectForSection:section];
    UIView *headerView  = nil;
    Class headerClass   = sectionItem.sectionHeaderClass;
    if (headerClass) {
        headerView = [[headerClass alloc] init];
        if ([headerView respondsToSelector:@selector(configSectionFringeWithObject:)]) {
            [headerView performSelector:@selector(configSectionFringeWithObject:) withObject:sectionItem.sectionHeaderData];
        }
    } else if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:objectForHeader:)]) {
        headerView = [self.delegate tableView:tableView viewForHeaderInSection:section objectForHeader:sectionItem.sectionHeaderData];
    }
    return headerView;
}

/// 返回指定section脚部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = [self objectForSection:section];
    if (sectionItem.sectionFooterClass) {
        Method fringeHeightMethod = class_getClassMethod(sectionItem.sectionFooterClass, @selector(sectionFringeHeightForObject:));
        if (fringeHeightMethod) {
            return [sectionItem.sectionFooterClass sectionFringeHeightForObject:sectionItem.sectionFooterData];
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:objectForFooter:)]) {
        return [self.delegate tableView:tableView heightForFooterInSection:section objectForFooter:sectionItem.sectionFooterData];
    }
    return 0;
}

/// 返回指定section脚部view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = [self objectForSection:section];
    UIView *footerView  = nil;
    Class footerClass   = sectionItem.sectionFooterClass;
    if (footerClass) {
        footerView = [[footerClass alloc] init];
        if ([footerView respondsToSelector:@selector(configSectionFringeWithObject:)]) {
            [footerView performSelector:@selector(configSectionFringeWithObject:) withObject:sectionItem.sectionFooterData];
        }
    } else if ([self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:objectForFooter:)]) {
        footerView = [self.delegate tableView:tableView viewForFooterInSection:section objectForFooter:sectionItem.sectionFooterData];
    }
    return footerView;
}

// ----------------------------------------------------------------------
#pragma mark - help method
// ----------------------------------------------------------------------

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
    return self.items.count;
}

/**
 返回指定section下的cell个数

 @param section 指定section
 @return cell个数
 */
- (NSInteger)numberOfRowsWithSection:(NSInteger)section {
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = [self objectForSection:section];
    if (!sectionItem.sectionCellItems || ![sectionItem.sectionCellItems isKindOfClass:[NSArray class]]) {
        return 0;
    }
    return sectionItem.sectionCellItems.count;
}

/**
 通过section获取section model
 */
- (id<ZCPTableViewGroupItemBasicProtocol>)objectForSection:(NSInteger)section {
    if(section >= self.items.count)  {
        return nil;
    }
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = self.items[section];
    return sectionItem;
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
    id<ZCPTableViewGroupItemBasicProtocol> sectionItem = [self objectForSection:indexPath.section];
    if (sectionItem.sectionCellItems.count > indexPath.row) {
        object  = [sectionItem.sectionCellItems objectAtIndex:indexPath.row];
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

// ----------------------------------------------------------------------
#pragma mark - getters and setters
// ----------------------------------------------------------------------

- (id<ZCPGroupListTableViewAdaptorDelegate>)delegate {
    return _delegate;
}

- (void)setDelegate:(id<ZCPGroupListTableViewAdaptorDelegate>)delegate {
    _delegate = delegate;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

@end
