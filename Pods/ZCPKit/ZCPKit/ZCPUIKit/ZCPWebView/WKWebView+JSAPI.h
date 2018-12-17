//
//  WKWebView+JSAPI.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/9.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <WebKit/WebKit.h>
@class ZCPWebViewController;

@interface PAWKScriptMessageDelegate: NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> bridgeDelegate;

@end

@interface WKWebView (JSAPI) <WKScriptMessageHandler>

extern NSString * const kWebViewJavaScriptMessageAppSharing;
extern NSString * const kWebViewJavaScriptMessageAppLink;
extern NSString * const kWebViewJavaScriptMessageAppMultipleItems;
extern NSString * const kWebViewJavaScriptMessageTriggerNativeShareModule;

@property (nonatomic, unsafe_unretained) ZCPWebViewController *controller;
@property (nonatomic, strong) PAWKScriptMessageDelegate *wkScriptMessageHandler;

- (void)addAllScriptMsgHandlers;
- (void)removeAllScriptMsgHandlers;

//禁止用户选择
- (void)banUserSelect;
// 禁用长按弹出框
- (void)banTouchCallout;
// 调用JS发送POST请求
- (void)postRequestWithJS:(NSDictionary *)postParams url:(NSString *)urlString;
// 给H5传递人脸识别通过状态
- (void)setFaceChecked:(BOOL)isCheck token:(NSString *)token callBackFuncName:(NSString *)callBackFuncName;

@end
