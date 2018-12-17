//
//  WKWebView+JSAPI.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "WKWebView+JSAPI.h"
#import "WKWebView+Cookie.h"
#import "ZCPWebViewController.h"
#import <objc/runtime.h>

NSString * const kWebViewJavaScriptMessageAppSharing = @"appShare";
NSString * const kWebViewJavaScriptMessageAppLink = @"appLink";
NSString * const kWebViewJavaScriptMessageAppMultipleItems = @"setRightItems";
NSString * const kWebViewJavaScriptMessageTriggerNativeShareModule = @"tiggerNativeShare";

@implementation PAWKScriptMessageDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.bridgeDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@implementation WKWebView (JSAPI)

@dynamic wkScriptMessageHandler;
@dynamic controller;

- (void)setWkScriptMessageHandler:(PAWKScriptMessageDelegate *)delegate
{
    objc_setAssociatedObject(self, @selector(wkScriptMessageHandler), delegate, OBJC_ASSOCIATION_RETAIN);
}


- (PAWKScriptMessageDelegate *)wkScriptMessageHandler
{
    PAWKScriptMessageDelegate *scriptHandler = objc_getAssociatedObject(self, _cmd);
    if(!scriptHandler) {
        scriptHandler = [PAWKScriptMessageDelegate new];
        objc_setAssociatedObject(self, _cmd, scriptHandler, OBJC_ASSOCIATION_RETAIN);
    }
    return scriptHandler;
}

- (ZCPWebViewController *)controller{
    ZCPWebViewController *controller = objc_getAssociatedObject(self, _cmd);
    if (!controller) {
        controller = [ZCPWebViewController new];
        objc_setAssociatedObject(self, @selector(controller), nil, OBJC_ASSOCIATION_ASSIGN);
    }
    return controller;
}
- (void)setController:(ZCPWebViewController *)controller{
    objc_setAssociatedObject(self, @selector(controller), controller, OBJC_ASSOCIATION_ASSIGN);
}

- (void)addAllScriptMsgHandlers {
    [self addAllUserScripts];
    self.wkScriptMessageHandler = [PAWKScriptMessageDelegate new];
    self.wkScriptMessageHandler.bridgeDelegate = self;
    [self.configuration.userContentController addScriptMessageHandler:self.wkScriptMessageHandler name:kWebViewJavaScriptMessageAppLink];
    [self.configuration.userContentController addScriptMessageHandler:self.wkScriptMessageHandler name:kWebViewJavaScriptMessageAppSharing];
    [self.configuration.userContentController addScriptMessageHandler:self.wkScriptMessageHandler name:kWebViewJavaScriptMessageAppMultipleItems];
    [self.configuration.userContentController addScriptMessageHandler:self.wkScriptMessageHandler name:kWebViewJavaScriptMessageTriggerNativeShareModule];
    
}

- (void)addAllUserScripts{
    [self cookieInjectionOnUserScript];
    
    [self jsInjectionOnUserScript];
}

- (void)jsInjectionOnUserScript{
    NSMutableString *script = [[NSMutableString alloc] init];//[UIDevice currentDevice].model,
    
    
    [script appendString:[self getJsPahaofangInstanceScript]];
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.configuration.userContentController addUserScript:userScript];
}

// JS API 接口， 用于给H5提供 基础信息
- (NSString *)getJsPahaofangInstanceScript{
    
    //pahaofang javascript instance creation
    // 设备信息 注入
    NSString *jsFuncDeviceModel = [self jsFunctionInstance:@"deviceModel" params:@"" blockFunc:[self returnFunction:[UIDevice currentDevice].model]];
    // 版本信息 注入
    NSString *jsFuncOsVersion = [self jsFunctionInstance:@"osVersion" params:@"" blockFunc:[self returnFunction:[UIDevice currentDevice].systemVersion]];
    // 右导航栏按钮设置 - 支持 link 和 分享
    NSString *jsFuncSetRightItem = [self jsFunctionInstance:@"setRightItem" params:@"type, json" blockFunc:[NSString stringWithFormat:@"if (type == 'link'){%@}else if(type == 'share'){%@}", [self actionPackage:kWebViewJavaScriptMessageAppLink params:@"json"], [self actionPackage:kWebViewJavaScriptMessageAppSharing params:@"json"]]];
    // 右导更多航栏按钮设置  - 支持 更多 和 分享
    NSString *jsFuncSetRightItems = [self jsFunctionInstance:kWebViewJavaScriptMessageAppMultipleItems params:@"json" blockFunc:[NSString stringWithFormat:@"{%@}", [self actionPackage:kWebViewJavaScriptMessageAppMultipleItems params:@"json"]]];
    
    // 触发 native 分享组件
    NSString *jsFuncTriggerNativeShareModule = [self jsFunctionInstance:kWebViewJavaScriptMessageTriggerNativeShareModule params:@"json" blockFunc:[NSString stringWithFormat:@"{%@}", [self actionPackage:kWebViewJavaScriptMessageTriggerNativeShareModule params:@"json"]]];
    
    return [NSString stringWithFormat:@"var pahaofang = {%@, %@, %@, %@, %@};",
            jsFuncDeviceModel, jsFuncOsVersion, jsFuncSetRightItem,
            jsFuncSetRightItems, jsFuncTriggerNativeShareModule];
}

#pragma mark - Cookie related
- (void)cookieInjectionOnUserScript{
    NSMutableString *script = [[NSMutableString alloc] init];
    ;
    NSArray *tem = [self getHaofangCookieParamsWithURL:[NSURL URLWithString:@".pinganfang.com"]];
    for (NSHTTPCookie* cookie in tem) {
        [script appendString:[NSString stringWithFormat:@"document.cookie=\'%@\';",[self getCookieString:cookie]]];
        
    }
    
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.configuration.userContentController addUserScript:userScript];
}

- (void)removeAllScriptMsgHandlers{
    [self.configuration.userContentController removeAllUserScripts];
    [self.configuration.userContentController removeScriptMessageHandlerForName:kWebViewJavaScriptMessageAppLink];
    [self.configuration.userContentController removeScriptMessageHandlerForName:kWebViewJavaScriptMessageAppSharing];
    [self.configuration.userContentController removeScriptMessageHandlerForName:kWebViewJavaScriptMessageAppMultipleItems];
    [self.configuration.userContentController removeScriptMessageHandlerForName:kWebViewJavaScriptMessageTriggerNativeShareModule];
    
}


#pragma mark - WKScriptMessageHandler
//处理handler委托。ViewController实现WKScriptMessageHandler委托的func
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self internalJSCallbackHandlerByIdentifier:message.name message:message.body];
}

- (void)internalJSCallbackHandlerByIdentifier:(NSString *)identifier message:(id)message{
    if([identifier isEqualToString:kWebViewJavaScriptMessageAppLink]) {
        // 点击按钮设置
        [self.controller jsConfiguredLinkItem:message];
    }else if([identifier isEqualToString:kWebViewJavaScriptMessageAppSharing]) {
        // 分享按钮设置由JS 出发
        [self.controller jsConfiguredShareItem:message];
    }else if([identifier isEqualToString:kWebViewJavaScriptMessageAppMultipleItems]){
        // 设置多个右导航按钮 暂时支持 分享按钮和更多按钮
        [self.controller jsCongiuredMutipleRightItems:message];
    }else if([identifier isEqualToString:kWebViewJavaScriptMessageTriggerNativeShareModule]){
        // H5 触发 native 分享组件
        [self.controller jsTriggerNativeSharePopView:message];
    }
}

#pragma mark - JS interaction
//禁止用户选择
- (void)banUserSelect{
    [self evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id result, NSError *error) {
        
    }];
}

// 禁用长按弹出框
- (void)banTouchCallout{
    [self evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id result, NSError *error) {
        
    }];
}

// 调用JS发送POST请求
- (void)postRequestWithJS:(NSDictionary *)postParams url:(NSString *)urlString {
    // 请求的页面地址
    // 拼装成调用JavaScript的字符串
    
    // NSLog(@"Javascript: %@", jscript);
    NSMutableString *mutableString = [NSMutableString new];
    for (NSString *key in postParams) {
        [mutableString appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key, [postParams objectForKey:key]]];
    }
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 1, 1)];
    NSString *jscript = [NSString stringWithFormat:@"post('%@', {%@});", urlString, mutableString];
    
    // 调用JS代码
    [self evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}

// 给H5传递人脸识别通过状态
- (void)setFaceChecked:(BOOL)isCheck token:(NSString *)token callBackFuncName:(NSString *)callBackFuncName {
    [self evaluateJavaScript:[NSString stringWithFormat:@"%@({\"result\":%d, \"token\":\"%@\"})", callBackFuncName, isCheck, token] completionHandler:^(id result, NSError *error) {
    }];
}

- (NSString *)jsFunctionInstance:(NSString *)name params:(NSString *)params blockFunc:(NSString *)blockFunc {
    return [NSString stringWithFormat:@"'%@': function (%@) { %@ }", name, params, blockFunc];
}

- (NSString *)actionPackage: (NSString *)actionName params:(id) obj {
    return [NSString stringWithFormat:@"window.webkit.messageHandlers.%@.postMessage(%@);", actionName, obj];
}

- (NSString *)returnFunction:(NSString *)returnValue{
    return [NSString stringWithFormat:@"return '%@';", returnValue];
    
}
@end
