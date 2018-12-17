//
//  ZCPServiceHandler.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCPGlobal.h"
@class ZCPServiceResult;
@class ZCPServiceHandler;

typedef void (^ZCPServiceResultBlock)(void);

// ----------------------------------------------------------------------
#pragma mark - ZCPServiceHandlerDelegate
// ----------------------------------------------------------------------

@protocol ZCPServiceHandlerDelegate <NSObject>

// service处理后的回调协议
- (void)service:(ZCPServiceHandler *)handler finishedWithResult:(ZCPServiceResult *)result;

@end

// ----------------------------------------------------------------------
#pragma mark - 统一处理app service请求
// ----------------------------------------------------------------------

@interface ZCPServiceHandler : NSObject

DEF_SINGLETON

@end

// ----------------------------------------------------------------------
#pragma mark - service处理结果类
// ----------------------------------------------------------------------

@interface ZCPServiceResult : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) ZCPServiceResultBlock action;

@end
