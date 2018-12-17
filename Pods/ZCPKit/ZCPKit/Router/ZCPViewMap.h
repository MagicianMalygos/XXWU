//
//  ZCPViewMap.h
//  Apartment
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 zcp. All rights reserved.
//

#ifndef ZCPViewMap_h
#define ZCPViewMap_h

// ----------------------------------------------------------------------
#pragma mark - host
// ----------------------------------------------------------------------

#define APPURL_HOST_VIEW                        @"view"
#define APPURL_HOST_SERVICE                     @"service"

// ----------------------------------------------------------------------
#pragma mark - param
// ----------------------------------------------------------------------

// 参数，是否回溯
#define APPURL_PARAM_RETROSPECT                 @"_retrospect"
// 参数，是否需要切换效果
#define APPURL_PARAM_ANIMATED                   @"_animated"
// 参数，url打开方式
#define APPURL_PARAM_OPENWITH                   @"_openWith"

// ----------------------------------------------------------------------
#pragma mark - view
// ----------------------------------------------------------------------

#pragma mark common

// 视图控制器
#define APPURL_VIEW_IDENTIFIER_VIEW             @"view"             // ZCPViewController
// 列表视图控制器
#define APPURL_VIEW_IDENTIFIER_TABLEVIEW        @"tableview"        // ZCPTableViewController
// 导航视图控制器
#define APPURL_VIEW_IDENTIFIER_NAVIGATIONVIEW   @"navigationview"   // ZCPNavigationController
// 选项卡视图控制器
#define APPURL_VIEW_IDENTIFIER_TABBARVIEW       @"tabbarview"       // ZCPTabBarController
// 浏览器视图控制器
#define APPURL_VIEW_IDENTIFIER_WEBVIEW          @"webview"          // ZCPWebViewController

#endif /* ZCPViewMap_h */

