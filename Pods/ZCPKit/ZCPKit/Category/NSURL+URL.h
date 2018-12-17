//
//  NSURL+Category.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/10/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - URL

@interface NSURL (URL)

/**
 是否web url
 
 @return BOOL
 */
- (BOOL)isWebURL;

/**
 获取url里面的参数
 
 @return 参数集
 */
- (NSDictionary *)getURLParams;

@end
