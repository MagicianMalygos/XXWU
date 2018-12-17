//
//  ZCPViewController+Router.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/7/31.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCPBaseNavigator.h"
#import "ZCPCommon.h"

@interface ZCPViewControllerRouterHelper : NSObject <ZCPNavigatorProtocol>

@end

@interface ZCPViewController (Router) <ZCPNavigatorProtocol>

@property (nonatomic, strong) ZCPViewControllerRouterHelper *routerHelper;

@end
