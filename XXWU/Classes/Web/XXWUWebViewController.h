//
//  XXWUWebViewController.h
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "ZCPWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 web容器页
 */
@interface XXWUWebViewController : ZCPWebViewController

- (void)loadUrl:(NSString *)url;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
