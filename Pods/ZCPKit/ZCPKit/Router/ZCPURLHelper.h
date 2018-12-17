//
//  ZCPURLHelper.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCPGlobal.h"

static NSString * ZCPAppURLScheme = @"zcp";
static NSString * ZCPDebugURLScheme = @"debugvc";

/**
 打开一个url，该url可以是以下几种情况
 1.web url：打开一个web url。          例如https://www.baidu.com
 2.app url：打开一个app url。          例如simblog://view/view，simblog://view/webview?_url=https%3a%2f%2fwww.baidu.com
 3.app service：执行一个app service。  例如simblog://service/gotoTop
 4.debug url：debug vc。              例如debug://login
 
 相关参数：web url和app url的view/webview可加以下参数
 _title：跳转到webview时显示的title，如：_title=SimBlog测试Title
 _needsNavigationBar：是否显示导航栏，可选参数有：true(默认)/false，如：_needsNavigationBar=true
 _openWith：使用何种方式打开url，可选参数有：
    browser：使用手机浏览器打开链接
    webview_blank(默认)：使用webview打开链接，使用一个新的webview打开链接
    webview_keep：使用webview打开链接，使用已有的webview打开链接，如果不存在则同webView_blank
 如：_openWith=browser
 
 注意事项：
 1.url中不能存在空格
 2.url中不能存在中文，需要URLEncode
 3.webview的_url参数需要进行URLEncode
 
 @param url 提供的url

 @return 是否成功打开
 */
BOOL openURL(NSString *url);

// ----------------------------------------------------------------------
#pragma mark - url工具类
// ----------------------------------------------------------------------

@interface ZCPURLHelper : NSObject

DEF_SINGLETON


/**
 打开一个url

 @param url url
 */
- (BOOL)openURL:(NSString *)url;

/**
 应用url协议
 */
+ (NSString *)appURLScheme;

/**
 设置app协议
 
 @param appURLScheme app协议字符串
 */
+ (void)setAppURLScheme:(NSString *)appURLScheme;

/**
 是否app url
 */
+ (BOOL)isAppUrl:(NSString *)url;

/**
 是否app url
 */
+ (BOOL)isAppURL:(NSURL *)URL;

/**
 是否web url
 */
+ (BOOL)isWebUrl:(NSString *)url;

/**
 是否web url
 */
+ (BOOL)isWebURL:(NSURL *)URL;

/**
 获取url里面的参数
 */
+ (NSDictionary *)getUrlParams:(NSString *)url;

/**
 获取url里面的参数
 */
+ (NSDictionary *)getURLParams:(NSURL *)URL;

@end
