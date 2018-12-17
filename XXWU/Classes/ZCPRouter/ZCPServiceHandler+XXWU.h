//
//  ZCPServiceHandler+XXWU.h
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "ZCPServiceHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCPServiceHandler (XXWU)

/**
 用户登陆

 @param query 参数
 */
- (void)login:(NSDictionary *)query;

@end

NS_ASSUME_NONNULL_END
