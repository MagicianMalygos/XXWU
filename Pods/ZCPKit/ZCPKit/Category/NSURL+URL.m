//
//  NSURL+Category.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/10/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "NSURL+URL.h"

#pragma mark - URL

@implementation NSURL (Category)

- (BOOL)isWebURL {
    return ([self.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame)
    || ([self.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)
    || ([self.scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame)
    || ([self.scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame)
    || ([self.scheme caseInsensitiveCompare:@"data"] == NSOrderedSame)
    || ([self.scheme caseInsensitiveCompare:@"file"] == NSOrderedSame);
}

#pragma mark 获取url里面的参数
- (NSDictionary *)getURLParams {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    NSArray *params = [self.query componentsSeparatedByString:@"&"];
    for (NSString *param in params) {
        NSArray *param_key_value = [param componentsSeparatedByString:@"="];
        if (param_key_value.count == 2) {
            NSString *key = [param_key_value objectAtIndex:0];
            NSString *value = [param_key_value objectAtIndex:1];
            [paramDic setObject:[value stringByRemovingPercentEncoding] forKey:[key stringByRemovingPercentEncoding]];
        }
    }
    return paramDic;
}
@end

