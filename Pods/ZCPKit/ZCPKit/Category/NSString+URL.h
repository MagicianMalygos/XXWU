//
//  NSString+URL.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2017/10/9.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 是否是web url
 */
- (BOOL)isWebURL;

/**
 获取url里面的参数
 */
- (NSDictionary *)getURLParams;

@end
