//
//  ZCPURLHelper.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPURLHelper.h"
#import "ZCPServiceHandler.h"
#import "ZCPViewMap.h"
#import "ZCPVCDataModel.h"
#import "ZCPControllerFactory.h"
#import "ZCPNavigator.h"
#import "ZCPCategory.h"

// ----------------------------------------------------------------------
#pragma mark - 打开url
// ----------------------------------------------------------------------
BOOL openURL(NSString * url) {
    BOOL handles = [[ZCPURLHelper sharedInstance] openURL:url];
    return handles;
}

static NSString *scheme;
static NSString *host;
static NSString *path;
static NSString *query;
static NSString *fragment;
static NSDictionary *params;

// ----------------------------------------------------------------------
#pragma mark - url工具类
// ----------------------------------------------------------------------
@interface ZCPURLHelper ()

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSURL *URL;

@end

@implementation ZCPURLHelper

IMP_SINGLETON

- (BOOL)openURL:(NSString *)url {
    BOOL handles = NO;
    
    // setup
    self.urlString       = url;
    if (!self.urlString) {
        return handles;
    }
    self.URL    = [NSURL URLWithString:self.urlString];
    scheme      = self.URL.scheme;
    host        = self.URL.host;
    path        = self.URL.path;
    query       = self.URL.query;
    fragment    = self.URL.fragment;
    params      = [ZCPURLHelper getURLParams:self.URL];
    
    // url是app url
    if ([ZCPURLHelper isAppUrl:url]) {
        [self handleAppURL];
    // url是web url
    } else if ([ZCPURLHelper getUrlParams:url]) {
        [self handleWebURL];
    // url是debug url
    } else if ([scheme isEqualToString:ZCPDebugURLScheme]) {
        [self handleDebugVCURL];
    // 是browser url
    } else {
        [self handleBrowserURL];
    }
    
    handles = YES;
    return handles;
}

// ----------------------------------------------------------------------
#pragma mark - Handler
// ----------------------------------------------------------------------

#pragma mark 处理app url
// 例如：%APP_SCHEME%://..
- (void)handleAppURL {
    // 去除path前的“/”字符
    if (path && path.length) {
        path = [path substringFromIndex:1];
    }
    
    // App View
    if ([host isEqualToString:APPURL_HOST_VIEW]) {
        [self handleAppViewURL];
    // App Service
    } else if ([host isEqualToString:APPURL_HOST_SERVICE]) {
        [self handleAppServiceURL];
    }
}

#pragma mark 处理web url
// 例如：http://world.huanqiu.com/article/2016-10/9564696.html?from=bdwz
- (void)handleWebURL {
    
    // 对url判断，并进行相关处理，比如是否使用webview打开，还是使用safari打开，
    // 若在webview中打开，那么可以一些配置，比如title，是否需要导航栏等
    // 默认使用webview打开
    NSString *openWith              = [params objectForKey:@"_openWith"];
    NSString *title                 = [params objectForKey:@"_title"];
    NSString *needsNavigationBar    = [params objectForKey:@"_needsNavigationBar"];
    
    // 移除参数
    self.urlString                  = [self.urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@=%@", @"_openWith", openWith] withString:@""];
    self.urlString                  = [self.urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@=%@", @"_title", title] withString:@""];
    self.urlString                  = [self.urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@=%@", @"_needsNavigationBar",needsNavigationBar] withString:@""];
    
    if (openWith && [openWith isEqualToString:@"browser"]) {
        [self handleBrowserURL];
    } else {
        [self handleWebViewURL];
    }
}

#pragma mark 处理 appview url
// 例如：simblog://view/..
- (void)handleAppViewURL {
    
    NSString        *vcIdentifier               = path;
    NSString        *retrospect                 = [params objectForKey:APPURL_PARAM_RETROSPECT];
    NSString        *animated                   = [params objectForKey:APPURL_PARAM_ANIMATED];
    BOOL            shouldRetrospect            = retrospect ? [retrospect boolValue] : NO;
    BOOL            shouldAnaimate              = animated ? [animated boolValue] : YES;
    
    // app url - webview
    if ([vcIdentifier isEqualToString:APPURL_VIEW_IDENTIFIER_WEBVIEW]) {
        NSString * url                          = [params objectForKey:@"_url"];
        NSString * openWith                     = [params objectForKey:@"_openWith"];
        
        // 使用浏览器打开url
        if (openWith && [openWith isEqualToString:@"browser"]) {
            self.urlString                      = url;
            [self handleBrowserURL];
        // 使用webview加载url
        } else {
            self.urlString                      = url;
            shouldRetrospect                    = retrospect ? [retrospect boolValue] : ((openWith && [openWith isEqualToString:@"webview_keep"]) ? YES : NO);
            ZCPVCDataModel * vcDataModel        = [[ZCPControllerFactory sharedInstance] generateVCModelWithIdentifier:vcIdentifier];
            vcDataModel.queryForInitMethod     = [NSMutableDictionary dictionaryWithDictionary:params];
            [[ZCPNavigator sharedInstance] pushViewControllerWithViewDataModel:vcDataModel retrospect:shouldRetrospect animated:shouldAnaimate];
        }
        
    // app url - view
    } else {
        ZCPVCDataModel *vcDataModel         = [[ZCPControllerFactory sharedInstance] generateVCModelWithIdentifier:vcIdentifier];
        vcDataModel.queryForInitMethod     = [NSMutableDictionary dictionaryWithDictionary:params];
        [[ZCPNavigator sharedInstance] pushViewControllerWithViewDataModel:vcDataModel retrospect:shouldRetrospect animated:shouldAnaimate];
    }
}

#pragma mark 处理webview url
// 例如：http://world.huanqiu.com/article/2016-10/9564696.html?from=bdwz&_openWith=webView_Blank&_needsNavigationBar=true
- (void)handleWebViewURL {
    
    NSString *vcIdentifier                  = APPURL_VIEW_IDENTIFIER_WEBVIEW;
    NSString *retrospect                    = [params objectForKey:APPURL_PARAM_RETROSPECT];
    NSString *animated                      = [params objectForKey:APPURL_PARAM_ANIMATED];
    NSString *openWith                      = [params objectForKey:APPURL_PARAM_OPENWITH];
    
    BOOL shouldRetrospect                   = retrospect ? [retrospect boolValue] : ((openWith && [openWith isEqualToString:@"webview_keep"]) ? YES : NO);
    BOOL shouldAnaimate                     = animated ? [animated boolValue] : YES;
    
    [[ZCPNavigator sharedInstance] gotoViewWithIdentifier:vcIdentifier
                                             queryForInit:params
                                       propertyDictionary:@{@"urlString": self.urlString}
                                               retrospect:shouldRetrospect
                                                 animated:shouldAnaimate];
}

#pragma mark 处理service url
// 例如：simblog://service/..
- (void)handleAppServiceURL {
    NSString * function                 = path;
    NSDictionary * params               = [ZCPURLHelper getUrlParams:query];
    
    SEL selector                        = NSSelectorFromString([NSString stringWithFormat:@"%@:",function]);
    
    if (!selector) {
        return;
    }
    
    ZCPServiceHandler *serviceHandler = [ZCPServiceHandler sharedInstance];
    if ([serviceHandler respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
            [serviceHandler performSelector:selector withObject:params];
        );
    } else if ([self respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
            [self performSelector:selector withObject:params];
        );
    }
}

#pragma mark 处理debugvc url
// 例如：debugvc://ZCPViewController
- (void)handleDebugVCURL {
    UIViewController *controller = [[NSClassFromString(host) alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [navi.navigationBar setCustomBackgroundColor:[UIColor whiteColor]];
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [root presentViewController:navi animated:YES completion:NULL];
}

#pragma mark 处理browser url
// 例如：http://world.huanqiu.com/article/2016-10/9564696.html?from=bdwz&_openWith=browser
- (void)handleBrowserURL {
    if (iOS10Upper) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString] options:@{} completionHandler:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlString]];
#pragma clang diagnostic pop
    }
}

// app url协议
+ (NSString *)appURLScheme {
    return ZCPAppURLScheme;
}

// 设置app协议
+ (void)setAppURLScheme:(NSString *)appURLScheme {
    ZCPAppURLScheme = appURLScheme;
}

// 是否是app url
+ (BOOL)isAppUrl:(NSString *)url {
    if (!url || url.length <= 0) {
        return NO;
    }
    NSURL *URL = [NSURL URLWithString:url];
    return [ZCPURLHelper isAppURL:URL];
}

// 是否app url
+ (BOOL)isAppURL:(NSURL *)URL {
    NSString *appScheme = [ZCPURLHelper appURLScheme];
    BOOL flag = ([URL.scheme caseInsensitiveCompare:appScheme] == NSOrderedSame);
    return flag;
}

/// 获取url里面的参数
+ (NSDictionary *)getUrlParams:(NSString *)url {
    return [ZCPURLHelper getURLParams:[NSURL URLWithString:url]];
}

/// 是否web url
+ (BOOL)isWebUrl:(NSString *)url {
    return [url isWebURL];
}

/// 是否web url
+ (BOOL)isWebURL:(NSURL *)URL {
    return [URL isWebURL];
}

/// 获取url里面的参数
+ (NSDictionary *)getURLParams:(NSURL *)URL {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSArray *params = [URL.query componentsSeparatedByString:@"&"];
    for (NSString *param in params) {
        NSArray *param_key_value = [param componentsSeparatedByString:@"="];
        if (param_key_value.count == 2) {
            NSString *key = [param_key_value objectAtIndex:0];
            NSString *value = [param_key_value objectAtIndex:1];
            [paramDic setObject:[value stringByRemovingPercentEncoding] forKey:[key stringByRemovingPercentEncoding]];
        }
    }
    return paramDic;
}

@end
