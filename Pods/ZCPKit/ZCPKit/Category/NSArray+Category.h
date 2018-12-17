//
//  NSArray+Category.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)

/**
 安全获取index下的元素

 @param index 索引

 @return 索引对应元素
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (Category)

/**
 安全添加元素

 @param anobject 待添加元素
 */
- (void)safeAddObject:(id)anobject;

@end
