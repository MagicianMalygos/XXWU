//
//  ZCPResponseDataModel.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPDataModel.h"

// ----------------------------------------------------------------------
#pragma mark - 服务器返回模型基类
// ----------------------------------------------------------------------
@interface ZCPResponseDataModel : ZCPDataModel

// 服务器返回数据
@property (nonatomic, strong) NSData        *responseData;
@property (nonatomic, copy  ) NSString      *responseString;
// 所有请求头
@property (nonatomic, strong) NSDictionary  *allHeadFields;
// 错误码
@property (nonatomic, strong) NSNumber      *errorCode;

@end
