//
//  ZCPTextField.m
//  Apartment
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTextField.h"

@implementation ZCPTextField

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    UIColor *color = [UIColor lightGrayColor];
    [color set];    // 设置线条颜色
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1.0f;
    
    aPath.lineCapStyle = kCGLineCapRound;   // 线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  // 终点处理
    
    // 设置开始点
    [aPath moveToPoint:CGPointMake(0, rect.size.height)];
    // 下一个点
    [aPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    
    // 根据坐标点连线
    [aPath stroke];
}

@end
