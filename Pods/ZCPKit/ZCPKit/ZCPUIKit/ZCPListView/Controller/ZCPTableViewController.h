//
//  ZCPTableViewController.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPViewController.h"
#import "ZCPListTableViewAdaptor.h"
#import "ZCPGroupListTableViewAdaptor.h"

// ----------------------------------------------------------------------
#pragma mark - 列表视图控制器基类
// ----------------------------------------------------------------------
@interface ZCPTableViewController : ZCPViewController <ZCPListTableViewAdaptorDelegate, ZCPGroupListTableViewAdaptorDelegate>

/// tableview
@property (nonatomic, strong) UITableView               *tableView;
/// 适配器
@property (nonatomic, strong) ZCPListTableViewAdaptor   *tableViewAdaptor;
/// 是否是多分组的tableview。默认为NO，如需要修改则在子类中重写该方法。
@property (nonatomic, assign, readonly, getter=isMultipleGroups) BOOL multipleGroups;

/**
 构造数据，给适配器items赋值
 */
- (void)constructData;

@end
