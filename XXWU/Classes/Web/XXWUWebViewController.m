//
//  XXWUWebViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUWebViewController.h"
#import "ViewController.h"

@interface XXWUWebViewController () <WKNavigationDelegate, WKUIDelegate, ZCPGenerateURLDelegate>

@end

@implementation XXWUWebViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNav];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

#pragma mark - setup

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(reload)];
}

#pragma mark - public

- (void)loadUrl:(NSString *)url {
    self.urlString = [self checkAndFixUrl:url];
    NSURLRequest *request = [self prepareToLoadUrl:self.urlString];
    [self.webView loadRequest:request];
    
    DebugLog(@"load %@", self.urlString);
}

- (void)reload {
    [self loadUrl:self.urlString];
}

#pragma mark <help method>

- (NSURLRequest *)prepareToLoadUrl:(NSString *)url {
    NSURL *URL                      = [NSURL URLWithString:url];
    NSTimeInterval timeout          = 30;
    NSMutableURLRequest *request    = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    [request setHTTPShouldHandleCookies:YES];
    request.mainDocumentURL         = URL;
    return request;
}

- (NSString *)checkAndFixUrl:(NSString *)url {
    if (!url) {
        return @"";
    }
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (url.length == 0) {
        return @"";
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    if (!URL) {
        return @"";
    }
    
    NSString *scheme = URL.scheme;
    if (!scheme || scheme.length == 0) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    return url;
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [[ZCPIndicator sharedInstance] showIndicator];
    self.title = @"加载中...";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [[ZCPIndicator sharedInstance] dismissIndicator];
    self.title = webView.title;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [[ZCPIndicator sharedInstance] dismissIndicator];
    self.title = @"加载失败";
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    
    NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

#pragma mark - ZCPGenerateURLDelegate

- (void)generateUrl:(NSString *)url {
    [self loadUrl:url];
}

#pragma mark - motion

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [super motionBegan:motion withEvent:event];
    if ([[[XXWUSettingsManager sharedInstance].preference objectForKey:SETTINGID_SHAKE] boolValue]) {
        ViewController *generator   = [[ViewController alloc] init];
        generator.delegate          = self;
        generator.defaultUrl        = self.urlString;
        [self.navigationController pushViewController:generator animated:YES];
    }
}

@end
