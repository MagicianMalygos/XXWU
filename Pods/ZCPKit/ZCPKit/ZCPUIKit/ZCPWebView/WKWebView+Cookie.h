//
//  WKWebView+Cookie.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ZCPGlobal.h"

@interface WKWebView (Cookie)

- (NSArray *)getHaofangCookieParamsWithURL:(NSURL *)url;
- (NSString *)getCookieString:(NSHTTPCookie *)cookie;
- (NSString *)getHeaderCookie;

@end


@interface PAWKSharedProcessPool : WKProcessPool

DEF_SINGLETON

@end
