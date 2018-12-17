//
//  ZCPListTableViewAdaptorDelegate.h
//  Pods
//
//  Created by 朱超鹏 on 2018/7/30.
//

#import <Foundation/Foundation.h>
#import "ZCPTableViewCellItemBasicProtocol.h"

// ----------------------------------------------------------------------
#pragma mark - 单SectionTableView适配器回调
// ----------------------------------------------------------------------
@protocol ZCPListTableViewAdaptorDelegate <NSObject>

@optional

/**
 cell初始化设置回调
 
 @param tableView cell所属tableview
 @param object cell model
 @param cell cell
 */
- (void)tableView:(nonnull UITableView *)tableView didSetObject:(nonnull id<ZCPTableViewCellItemBasicProtocol>)object cell:(nonnull UITableViewCell *)cell;

/**
 点击cell事件回调

 @param tableView cell所属tableview
 @param object cell model
 @param indexPath 索引
 */
- (void)tableView:(nonnull UITableView *)tableView didSelectObject:(nonnull id<ZCPTableViewCellItemBasicProtocol>)object rowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 返回cell是否可进行编辑

 @param tableView cell所属tableview
 @param indexPath 索引
 @return cell是否可进行编辑
 */
- (BOOL)tableView:(nonnull UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 返回cell左滑编辑按钮样式

 @param tableView cell所属tableview
 @param indexPath 索引
 @return cell是否可进行编辑
 */
- (UITableViewCellEditingStyle)tableView:(nonnull UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 返回cell左滑编辑按钮标题
 
 @param tableView cell所属tableview
 @param indexPath 索引
 @return cell左滑编辑按钮标题
 */
- (nullable NSString *)tableView:(nonnull UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 点击编辑按钮事件回调

 @param tableView cell所属tableview
 @param editingStyle 编辑按钮样式
 @param indexPath 索引
 */
- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
