//
//  ZCPWebViewController.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPViewController.h"
#import <WebKit/WebKit.h>

// ----------------------------------------------------------------------
#pragma mark - webview返回事件代理
// ----------------------------------------------------------------------
@protocol PAWebViewControllerBackDelegate <NSObject>

/**
 webview返回按钮响应事件
 */
- (void)webViewDidClickBackBarButton;

@end

// ----------------------------------------------------------------------
#pragma mark - WebViewController 用来装载网页，并做响应处理
// ----------------------------------------------------------------------
@interface ZCPWebViewController : ZCPViewController <UIWebViewDelegate>

/// webview配置
@property (nonatomic, strong) WKWebViewConfiguration *webViewConfiguration;
/// webview
@property (nonatomic, strong) WKWebView *webView;

/// 访问地址
@property (nonatomic, copy) NSString *urlString;
/// post参数
@property (nonatomic, strong) NSDictionary *postParams;
/// 回调代理
@property (nonatomic, weak) id<PAWebViewControllerBackDelegate> delegate;

@property (nonatomic, copy)     NSString      *titleFromUrl;

/**
 加载url
 */
- (void)loadURL:(NSString *)url;

/**
 重新加载
 */
- (void)reload;

@end



@interface ZCPWebViewController (NavigationBar)

/**
 清除导航内容
 */
- (void)clearNavigationBar;

/**
 初始化右侧加载导航按钮
 */
- (void)initLoadingRightBarButton;

/**
 初始化右侧导航按钮
 */
- (void)configureNavigationBar;

/**
 初始化分享按钮
 */
- (void)initShareBarButton;

- (void)jsConfiguredLinkItem:(NSString *)jsonStr;
- (void)jsConfiguredShareItem:(NSString *)jsonShare;
- (void)jsCongiuredMutipleRightItems:(NSString *)jsonStr;
- (void)jsTriggerNativeSharePopView:(NSString *)jsonStr;

/**
 预加载分享图片

 @param imageUrl 分享图片链接
 */
- (void)preDownloadTargetSharingImageUrl:(NSString *)imageUrl;

@end
