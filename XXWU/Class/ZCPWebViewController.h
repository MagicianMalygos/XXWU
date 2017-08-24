//
//  ZCPWebViewController.h
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ZCPWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlString;

- (void)loadUrl:(NSString *)url;
- (void)reload;

@end


