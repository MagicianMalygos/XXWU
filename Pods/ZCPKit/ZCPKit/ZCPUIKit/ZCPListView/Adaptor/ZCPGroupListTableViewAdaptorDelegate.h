//
//  ZCPGroupListTableViewAdaptorDelegate.h
//  Pods
//
//  Created by 朱超鹏 on 2018/7/30.
//

#import "ZCPListTableViewAdaptorDelegate.h"

// ----------------------------------------------------------------------
#pragma mark - 多SectionTableView适配器回调
// ----------------------------------------------------------------------
@protocol ZCPGroupListTableViewAdaptorDelegate <ZCPListTableViewAdaptorDelegate>

@optional

/**
 返回指定section头部高度

 @param tableView section所属tableview
 @param section section
 @param object section model
 @return 指定section头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section objectForHeader:(id)object;

/**
 返回指定section头部view

 @param tableView section所属tableview
 @param section section
 @param object section model
 @return 指定section头部view
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section objectForHeader:(id)object;

/**
 返回指定section脚部高度

 @param tableView section所属tableview
 @param section section
 @param object section model
 @return 指定section脚部高度
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section objectForFooter:(id)object;

/**
 返回指定section脚部view
 
 @param tableView section所属tableview
 @param section section
 @param object section model
 @return 指定section脚部view
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section objectForFooter:(id)object;

@end
