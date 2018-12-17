//
//  ZCPGroupListTableViewAdaptor.h
//  Aspects-iOS11.0
//
//  Created by 朱超鹏 on 2018/7/30.
//

#import "ZCPListTableViewAdaptor.h"
#import "ZCPTableViewGroupItemBasicProtocol.h"
#import "ZCPGroupListTableViewAdaptorDelegate.h"

// ----------------------------------------------------------------------
#pragma mark - 多Section Tableview适配器
// ----------------------------------------------------------------------
@interface ZCPGroupListTableViewAdaptor : ZCPListTableViewAdaptor

/// section model数组。每个元素必须实现ZCPTableViewGroupItemBasicProtocol协议
@property (nonatomic, strong, nonnull) NSMutableArray    *items;
/// delegate
@property (nonatomic, weak, nullable) id<ZCPGroupListTableViewAdaptorDelegate> delegate;

@end
