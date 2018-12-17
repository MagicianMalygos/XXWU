//
//  ZCPListTableViewAdaptor.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewCellItemBasicProtocol.h"
#import "ZCPListTableViewAdaptorDelegate.h"

// ----------------------------------------------------------------------
#pragma mark - 单Section Tableview适配器
// ----------------------------------------------------------------------
@interface ZCPListTableViewAdaptor : NSObject <UITableViewDelegate, UITableViewDataSource>

/// 参与适配的tableview
@property (nonatomic, weak, nullable)   UITableView         *tableView;
/// cell model数组。每个元素必须实现ZCPTableViewCellItemBasicProtocol协议
@property (nonatomic, strong, nullable) NSMutableArray      *items;
/// delegate
@property (nonatomic, weak, nullable)   id<ZCPListTableViewAdaptorDelegate> delegate;

@end
