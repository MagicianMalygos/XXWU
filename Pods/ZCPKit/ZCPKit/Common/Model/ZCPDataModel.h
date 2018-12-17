//
//  ZCPDataModel.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCPGlobal.h"

// ----------------------------------------------------------------------
#pragma mark - 模型基类
// ----------------------------------------------------------------------
@interface ZCPDataModel : NSObject

+ (instancetype)modelFromDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDefault;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryValue;

@end
