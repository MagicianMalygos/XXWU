//
//  WKWebView+Cookie.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "WKWebView+Cookie.h"
#import "ZCPPackageInfo.h"
#import "ZCPDevice.h"

@implementation WKWebView (Cookie)


- (NSArray *)getHaofangCookieParamsWithURL:(NSURL *)url{
    NSString *domain = [url host];// [cookDic objectForKey:NSHTTPCookieDomain]?:@"";
    domain = domain?domain:@"";
    NSString *oriUrl = [url absoluteString]; //[cookDic objectForKey:NSHTTPCookieOriginURL]?:@"";
    NSMutableArray *haofangCookies = [NSMutableArray new];
    // APP Source
    [haofangCookies addObject:[NSHTTPCookie cookieWithProperties:[self generateAppSourcePropertiesWithDomain:domain originalUrl:oriUrl]]];
    // APP VERSION
    [haofangCookies addObject:[NSHTTPCookie cookieWithProperties:[self generateAppVersionPropertiesWithDomain:domain originalUrl:oriUrl]]];
    // DEVICE ID
    [haofangCookies addObject:[NSHTTPCookie cookieWithProperties:[self generateDeviceIDPropertiesWithDomain:domain originalUrl:oriUrl]]];
    // APP Type
    [haofangCookies addObject:[NSHTTPCookie cookieWithProperties:[self generateAppTypePropertiesWithDomain:domain originalUrl:oriUrl]]];
    // APP Channel
    [haofangCookies addObject:[NSHTTPCookie cookieWithProperties:[self generateAppChannelPropertiesWithDomain:domain originalUrl:oriUrl]]];
    
    return haofangCookies;
}

- (NSMutableDictionary *)generateTokenPropertiesWithDomain:(NSString *)domain originalUrl:(NSString *)oriUrl{
    NSString *userToken = @"";// get a token
    NSMutableDictionary *tokenProperties = [NSMutableDictionary dictionary];
    [tokenProperties setObject:@"haofang_token" forKey:NSHTTPCookieName];
    [tokenProperties setObject:userToken?userToken:@"" forKey:NSHTTPCookieValue];
    [tokenProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [tokenProperties setObject:domain forKey:NSHTTPCookieDomain];
    [tokenProperties setObject:oriUrl forKey:NSHTTPCookieOriginURL];
    [tokenProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    return tokenProperties;
}

- (NSMutableDictionary *)generateAppSourcePropertiesWithDomain:(NSString *)domain originalUrl:(NSString *)oriUrl{
    NSMutableDictionary *appIDProperties = [NSMutableDictionary dictionary];
    [appIDProperties setObject:@"app_source" forKey:NSHTTPCookieName];
    [appIDProperties setObject:@"I" forKey:NSHTTPCookieValue];
    [appIDProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [appIDProperties setObject:domain forKey:NSHTTPCookieDomain];
    [appIDProperties setObject:oriUrl forKey:NSHTTPCookieOriginURL];
    [appIDProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    return appIDProperties;
}

- (NSMutableDictionary *)generateAppVersionPropertiesWithDomain:(NSString *)domain originalUrl:(NSString *)oriUrl{
    NSString *appVersion = [ZCPPackageInfo appVersionString];
    NSMutableDictionary *appVersionProperties = [NSMutableDictionary dictionary];
    [appVersionProperties setObject:@"app_version" forKey:NSHTTPCookieName];
    [appVersionProperties setObject:appVersion?:@"" forKey:NSHTTPCookieValue];
    [appVersionProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [appVersionProperties setObject:domain forKey:NSHTTPCookieDomain];
    [appVersionProperties setObject:oriUrl forKey:NSHTTPCookieOriginURL];
    [appVersionProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    return appVersionProperties;
}

- (NSMutableDictionary *)generateAppChannelPropertiesWithDomain:(NSString *)domain originalUrl:(NSString *)oriUrl{
    NSMutableDictionary *appVersionProperties = [NSMutableDictionary dictionary];
    [appVersionProperties setObject:@"app_channel" forKey:NSHTTPCookieName];
    [appVersionProperties setObject:[NSString stringWithFormat:@"%d",PAAppChannelAppStore] forKey:NSHTTPCookieValue];
    [appVersionProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [appVersionProperties setObject:domain forKey:NSHTTPCookieDomain];
    [appVersionProperties setObject:oriUrl forKey:NSHTTPCookieOriginURL];
    [appVersionProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    return appVersionProperties;
}

- (NSMutableDictionary *)generateAppTypePropertiesWithDomain:(NSString *)domain originalUrl:(NSString *)oriUrl{
    NSMutableDictionary *appVersionProperties = [NSMutableDictionary dictionary];
    [appVersionProperties setObject:@"app_type" forKey:NSHTTPCookieName];
    [appVersionProperties setObject:@"hf" forKey:NSHTTPCookieValue];
    [appVersionProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [appVersionProperties setObject:domain forKey:NSHTTPCookieDomain];
    [appVersionProperties setObject:oriUrl forKey:NSHTTPCookieOriginURL];
    [appVersionProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    return appVersionProperties;
}

- (NSMutableDictionary *)generateDeviceIDPropertiesWithDomain:(NSString *)domain originalUrl:(NSString *)oriUrl{
    NSString *deviceID = [ZCPDevice getDeviceOpenUDID];
    NSMutableDictionary *deviceIDProperties = [NSMutableDictionary dictionary];
    [deviceIDProperties setObject:@"app_deviceID" forKey:NSHTTPCookieName];
    [deviceIDProperties setObject:deviceID?:@"" forKey:NSHTTPCookieValue];
    [deviceIDProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [deviceIDProperties setObject:domain forKey:NSHTTPCookieDomain];
    [deviceIDProperties setObject:oriUrl forKey:NSHTTPCookieOriginURL];
    [deviceIDProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    return deviceIDProperties;
}

- (NSString *)getCookieString:(NSHTTPCookie *)cookie {
    
    NSString *string = [NSString stringWithFormat:@"%@=%@;path=%@;sessionOnly=%@;isSecure=%@",
                        cookie.name,
                        cookie.value,
                        cookie.path ?: @"/",
                        cookie.isSecure ? @"TRUE":@"FALSE",
                        cookie.sessionOnly ? @"TRUE":@"FALSE"];
    
    return string;
}

- (NSString *)getHeaderCookie{
    NSArray *tem = [self getHaofangCookieParamsWithURL:[NSURL URLWithString:@".pinganfang.com"]];
    NSArray *cookiesFromStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSMutableArray *cookiesList = [NSMutableArray arrayWithArray:cookiesFromStorage];
    [cookiesList addObjectsFromArray:tem];
    
    //to override storage cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary new];
    for (NSHTTPCookie *cookie in cookiesList){
        if ([cookie.name isKindOfClass:[NSString class]]) {
            [cookieDic setObject:cookie.value forKey:cookie.name];
        }
    }
    
    //append cookie string
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    for (NSString *key in [cookieDic allKeys]) {
        [cookieString appendFormat:@"%@=%@;",key,[cookieDic objectForKey:key]];
    }
    //删除最后一个“；”
    [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    
    return cookieString;
}
@end

@implementation PAWKSharedProcessPool

IMP_SINGLETON

@end

