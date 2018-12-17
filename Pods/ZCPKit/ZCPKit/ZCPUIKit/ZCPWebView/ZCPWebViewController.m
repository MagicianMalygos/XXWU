//
//  ZCPWebViewController.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPWebViewController.h"
#import "WKWebView+JSAPI.h"
#import "WKWebView+Cookie.h"

#import "ZCPUtil.h"
#import "ZCPCategory.h"
#import "ZCPRouter.h"
#import "ZCPNetwork.h"

@interface ZCPWebViewController () <WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKUserContentController *userContentController;
@property (nonatomic, assign) BOOL needLoadJSPOST;
/// 是否首次加载
@property (nonatomic, assign) BOOL isFirstTimeLoaded;

/// js回调方法名
@property (nonatomic, copy)   NSString *callBackFuncName;


/// url中包含的参数
@property (nonatomic, strong) NSMutableDictionary  *urlParams;

/// 分享消息
/// 格式为：{title: "hello", message: "hello", link: "", imageURL: ""}
@property (nonatomic, strong) NSDictionary  *shareDic;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, copy) NSString *shareLink;

@end

@implementation ZCPWebViewController

// ----------------------------------------------------------------------
#pragma mark - init
// ----------------------------------------------------------------------

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
        // 参数解析
        if (!query || ![query isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        NSString *url           = [query objectForKey:@"_url"];
        self.urlString          = url;
        self.urlParams          = [url getURLParams].mutableCopy;
        self.postParams         = [query objectForKey:@"_postParams"];
        
        NSString *title         = [query objectForKey:@"_title"];
        self.title              = title;
        self.titleFromUrl       = title;
        
        self.delegate           = [query objectForKey:@"_delegate"];
        
        NSString *shareMessage  = [query objectForKey:@"_shareMessage"];
        if (shareMessage.length > 0) {
            [self.urlParams setObject:shareMessage forKey:@"_shareMessage"];
        }
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        if (url && [url isKindOfClass:[NSString class]]) {
            self.urlString  = url;
            self.urlParams  = [url getURLParams].mutableCopy;
        }
    }
    return self;
}

// ----------------------------------------------------------------------
#pragma mark - life cycle
// ----------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureJSAPI];
    [self loadURL:self.urlString];
    
    self.isFirstTimeLoaded = YES;
    self.webView.backgroundColor = [UIColor colorFromHexRGB:@"ececec"];
    [self initLoadingRightBarButton];
    
    // 预加载分享图片
    if ([self.urlParams objectForKey:@"_shareMessage"]){
        NSString *shareMessage = [self.urlParams objectForKey:@"_shareMessage"];
        self.shareDic = [shareMessage JSONObject];
        [self preDownloadTargetSharingImageUrl:[self.shareDic objectForKey:@"sImg"]];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.webView.width  = self.view.width;
    self.webView.height = self.view.height;
}

// ----------------------------------------------------------------------
#pragma mark - load
// ----------------------------------------------------------------------

/// 加载url
- (void)loadURL:(NSString *)url {
    if (self.postParams) {
        self.needLoadJSPOST = YES;
        // 获取JS所在的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JSPOST" ofType:@"html"];
        // 获得html内容
        NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        // 加载js
        [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    } else {
        NSURL *URL                      = [NSURL URLWithString:url];
        NSTimeInterval timeout          = 30;
        NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
        request.HTTPShouldHandleCookies = YES;
        request.mainDocumentURL         = URL;
        [self.webView loadRequest:request];
    }
}

/// 重加载
- (void)reload {
    self.isFirstTimeLoaded = YES;
    [self configureJSAPI];
    [self loadURL:self.urlString];
}

// ----------------------------------------------------------------------
#pragma mark - help method
// ----------------------------------------------------------------------

- (void)configureJSAPI {
    [self.webView removeAllScriptMsgHandlers];
    [self.webView addAllScriptMsgHandlers];
}

/// 判断当前加载的url是否是WKWebView不能打开的协议类型。例如：phone numbers, email address, maps等。
- (void)openGeneralUrl:(NSURL*)url {
    NSString *urlString = url.absoluteString;
    
    // 处理tel url
    if ([url.scheme isEqualToString:@"tel"]) {
        openURL(urlString);
        return;
    }
    
    // 处理app url
    if ([ZCPURLHelper isAppURL:url]) {
        openURL(urlString);
    } else {
        openURL(urlString);
    }
}

#pragma mark - WKNavigationDelegate

/// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *URL = navigationAction.request.URL;
    
    // backforward
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // 解析openwith参数，决定跳转方式
    NSDictionary *queryDict = [URL.query getURLParams];
    if (queryDict && [queryDict objectForKey:@"_openWith"]) {
        NSString *openWith = [queryDict objectForKey:@"_openWith"];
        // 如果开启新页面
        if ([openWith isEqualToString:@"webView_Blank"]) {
            [self openGeneralUrl:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        // 如果在当前页面加载
        if ([openWith isEqualToString:@"webView_Keep"]) {
        }
        
        // 如果在手机浏览器加载
        if ([openWith isEqualToString:@"browser"]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    // 如果不是web url
    if (![URL isWebURL]) {
        [self openGeneralUrl:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    // 如果有cookie
    if ((navigationAction.navigationType == WKNavigationTypeLinkActivated || self.isFirstTimeLoaded)
        && ![navigationAction.request.allHTTPHeaderFields.allKeys containsObject:@"Cookie"]
        && !self.postParams) {
        NSMutableURLRequest *request = navigationAction.request.mutableCopy;
        self.isFirstTimeLoaded = NO;
        [request setValue:[self.webView getHeaderCookie] forHTTPHeaderField:@"Cookie"];
        request.HTTPShouldHandleCookies = YES;
        [self.webView loadRequest:request];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

/// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    // 显示状态栏菊花
    [[ZCPIndicator sharedInstance] showIndicator];
    [self clearNavigationBar];
}

/// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (![webView.URL isWebURL]) {
        [self openGeneralUrl:webView.URL];
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    self.isFirstTimeLoaded = NO;
    request.URL = webView.URL;
    [request setValue:[self.webView getHeaderCookie] forHTTPHeaderField:@"Cookie"];
    request.HTTPShouldHandleCookies = YES;
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self.webView postRequestWithJS:self.postParams url:self.urlString];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    self.title = webView.title;
    
    // 隐藏状态栏菊花
    [[ZCPIndicator sharedInstance] dismissIndicator];
    [self configureNavigationBar];
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // Ignore NSURLErrorDomain error -999.
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) {
        return;
    }
    // Show exception view
    if ([error code] == NSURLErrorNotConnectedToInternet) {
    } else {
    }
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // Ignore NSURLErrorDomain error -999.
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) {
        return;
    }
    
    // 隐藏状态栏菊花
    [[ZCPIndicator sharedInstance] dismissIndicator];
    [self clearNavigationBar];
    self.title = @"加载失败";
}

/// 证书鉴权
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions    = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    
    NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}


// ----------------------------------------------------------------------
#pragma mark - WKUIDelegate
// ----------------------------------------------------------------------

/// js 里面的alert实现，如果不实现，网页的alert函数无效（单个按钮）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler {
    if (self.presentedViewController) {
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/// js 里面的alert实现，如果不实现，网页的alert函数无效（确认/取消两个按钮）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler {
    if (self.presentedViewController) {
        completionHandler(NO);
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

/// js 里面的alert实现，如果不实现，网页的alert函数无效（输入框和确认/取消两个按钮）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler {
    completionHandler(@"Client Not handler");
}

// ----------------------------------------------------------------------
#pragma mark - override
// ----------------------------------------------------------------------

- (void)backTo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidClickBackBarButton)]) {
        [self.delegate webViewDidClickBackBarButton];
        return;
    }
    [super backTo];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

// ----------------------------------------------------------------------
#pragma mark - event response
// ----------------------------------------------------------------------

- (void)clickBackBarButton:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self backTo];
    }
}

- (void)clickCloseBarButton:(id)sender {
    [self backTo];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // kvo监听document title
    if ([keyPath isEqualToString:@"title"]) {
        self.title = [change objectForKey:@"new"];
    }
}

// ----------------------------------------------------------------------
#pragma mark - getters and setters
// ----------------------------------------------------------------------
- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        _webViewConfiguration.preferences = [[WKPreferences alloc] init];
        // 默认为0
        _webViewConfiguration.preferences.minimumFontSize = 10;
        // 默认认为YES
        _webViewConfiguration.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        _webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        // 通过JS与webview内容交互
        _webViewConfiguration.userContentController = self.userContentController;
        _webViewConfiguration.selectionGranularity = WKSelectionGranularityCharacter;
        // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
        _webViewConfiguration.processPool = [PAWKSharedProcessPool sharedInstance];
    }
    return _webViewConfiguration;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:self.webViewConfiguration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate         = self;
        _webView.controller         = self;
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        if (@available(iOS 11.0, *)) {
            // iOS11 以后加载本地页面引起内容向下偏移问题
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if ([_webView respondsToSelector:@selector(setAllowsLinkPreview:)]) {
            // In iOS 10 and later, the default value is true; before that, the default value is false.
            _webView.allowsLinkPreview = NO;
        }
    }
    
    return _webView;
}

- (WKUserContentController *)userContentController {
    if(!_userContentController){
        _userContentController = [WKUserContentController new];
    }
    return _userContentController;
}

@end


@implementation ZCPWebViewController (NavigationBar)

- (void)clearNavigationBar {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)initLoadingRightBarButton {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = rightButton;
    [indicator startAnimating];
}

- (void)configureNavigationBar {
    UIBarButtonItem *backItem   = [UIBarButtonItem setBackItemWithTarget:self action:@selector(clickBackBarButton:)];
    UIBarButtonItem *closeItem  = [UIBarButtonItem rightBarItemWithTitle:@"+" font:[UIFont systemFontOfSize:24.0f] target:self action:@selector(clickCloseBarButton:)];
    
    if (self.postParams) {
        self.navigationItem.leftBarButtonItems = @[closeItem];
    } else if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
    } else {
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
}

- (void)initShareBarButton {
    self.navigationItem.rightBarButtonItem = [self generateShareBarItem];
}

- (UIBarButtonItem *)generateShareBarItem {
    UIBarButtonItem *rightButton = [UIBarButtonItem rightBarItemWithTitle:@"Share"
                                                               titleColor:@"333333"
                                                                     font:[UIFont systemFontOfSize:24.0]
                                                                   target:self
                                                                   action:@selector(shareButtonClicked:)];
    return rightButton;
}

- (UIBarButtonItem *)generateMoreBarItem {
    UIBarButtonItem *rightButton = [UIBarButtonItem rightBarItemWithTitle:@"More"
                                                               titleColor:@"333333"
                                                                     font:[UIFont systemFontOfSize:24.0]
                                                                   target:self
                                                                   action:@selector(moreButtonClicked:)];
    return rightButton;
}

#pragma mark - JS triggerd RightBarItem Initializer

- (void)jsConfiguredLinkItem:(NSString *)jsonStr{
    NSDictionary *dictionary = [jsonStr JSONObject];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.shareLink = [dictionary objectForKey:@"url"];
    UIBarButtonItem *rightButton = [UIBarButtonItem rightBarItemWithTitle:[dictionary objectForKey:@"name"]
                                                                     font:[UIFont systemFontOfSize:15.0]
                                                                   target:self
                                                                   action:@selector(openLink)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)jsCongiuredMutipleRightItems:(NSString *)jsonStr{
    NSDictionary *dictionary = [jsonStr JSONObject];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSMutableArray *items =  [NSMutableArray new];
    
    if([dictionary objectForKey:@"share"]) {
        [self configureJSShareDictionary:[dictionary objectForKey:@"share"]];
        [items addObject:[self generateShareBarItem]];
    }
    
    if (items.count > 0) {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)jsTriggerNativeSharePopView:(NSString *)jsonStr{
    NSDictionary *dictionary = [jsonStr JSONObject];
    [self configureJSShareDictionary:dictionary];
    [self shareButtonClicked:nil];
}

- (void)openLink{
    openURL(self.shareLink);
}

- (void)jsConfiguredShareItem:(NSString *)jsonShare{
    NSDictionary *dictionary = [jsonShare JSONObject];
    [self configureJSShareDictionary:dictionary];
    [self initShareBarButton];
}

- (void)configureJSShareDictionary:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if (![dict objectForKey:@"title"] || ![dict objectForKey:@"desc"] || ![dict objectForKey:@"shareUrl"] || ![dict objectForKey:@"imgUrl"]) {
        return;
    }
    NSMutableDictionary *temDict = [NSMutableDictionary new];
    [temDict setObject:[dict objectForKey:@"title"] forKey:@"sTitle"];
    [temDict setObject:[dict objectForKey:@"desc"] forKey:@"sMsg"];
    [temDict setObject:[dict objectForKey:@"shareUrl"] forKey:@"sUrl"];
    [temDict setObject:[dict objectForKey:@"imgUrl"] forKey:@"sImg"];
    
    if ([[dict objectForKey:@"success"] isKindOfClass:[NSString class]]) { // 分享成功 回调方法 名
        [temDict setObject:[dict objectForKey:@"success"] forKey:@"success"];
    }
    
    if ([[dict objectForKey:@"cancel"] isKindOfClass:[NSString class]]) { // 分享取消 回调方法 名
        [temDict setObject:[dict objectForKey:@"cancel"] forKey:@"cancel"];
    }
    
    self.shareDic = temDict;
    [self preDownloadTargetSharingImageUrl:[self.shareDic objectForKey:@"sImg"]];
}

- (void)preDownloadTargetSharingImageUrl:(NSString *)imageUrl {
//    if(imgUrl && [NSURL URLWithString:imgUrl]){
//        @weakify(self);
//        SDWebImageManager *manager      = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:imgUrl]
//                              options:SDWebImageRefreshCached progress:nil
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                weakself.shareImage         = image;
//                            }];
//    }
}

// ----------------------------------------------------------------------
#pragma mark - event response
// ----------------------------------------------------------------------
- (void)shareButtonClicked:(id)sender {
}

- (void)moreButtonClicked:(UIButton *)sender{
}

@end
