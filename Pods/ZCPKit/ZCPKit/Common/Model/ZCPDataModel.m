//
//  ZCPDataModel.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPDataModel.h"

@implementation ZCPDataModel

+ (instancetype)modelFromDictionary:(NSDictionary *)dictionary {
    return [[ZCPDataModel alloc] init];
}

- (instancetype)initWithDefault {
    return [[ZCPDataModel alloc] init];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
    }
    return self;
}

- (NSDictionary *)dictionaryValue {
    return @{};
}

@end
