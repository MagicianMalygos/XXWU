//
//  ZCPTableViewCellDataModel.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPDataModel.h"
#import "ZCPTableViewCellItemBasicProtocol.h"

// ----------------------------------------------------------------------
#pragma mark - cell模型基类
// ----------------------------------------------------------------------
@interface ZCPTableViewCellDataModel : ZCPDataModel <ZCPTableViewCellItemBasicProtocol, NSCopying>

// id
@property (nonatomic, copy) NSString *idString;

@end
