//
//  XXWUWebHelperViewController.h
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XXWUWebHelperDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 webview帮助页
 */
@interface XXWUWebHelperViewController : ZCPViewController

/// 默认url
@property (nonatomic, copy) NSString *defaultUrl;
/// 回调代理
@property (nonatomic, weak) id<XXWUWebHelperDelegate> delegate;

@end

/**
 回调协议
 */
@protocol XXWUWebHelperDelegate <NSObject>

/**
 生成url回调

 @param url 生成的url字符串
 */
- (void)helperCallbackGenerateUrl:(NSString *)url;

/**
 清除缓存回调
 */
- (void)helperCallbackCleanWebViewCache;

@end


NS_ASSUME_NONNULL_END
