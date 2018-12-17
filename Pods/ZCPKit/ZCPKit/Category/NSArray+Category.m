//
//  NSArray+Category.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (id)safeObjectAtIndex:(NSUInteger)index {
    id obj = nil;
    
    if (self.count >= index) {
        obj = [self objectAtIndex:index];
    }
    return obj;
}

@end

@implementation NSMutableArray (Category)

- (void)safeAddObject:(id)anobject {
    if(anobject && ![anobject isKindOfClass:[NSNull class]]) {
        [self addObject:anobject];
    }
}

@end
