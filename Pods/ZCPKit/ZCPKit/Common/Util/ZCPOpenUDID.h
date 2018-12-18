//
//  ZCPOpenUDID.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/1.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2

@interface ZCPOpenUDID : NSObject

+ (NSString *)value;
+ (NSString *)valueWithError:(NSError**)error;
+ (void)setOptOut:(BOOL)optOutValue;

@end
