//
//  PALogSwitch.h
//  haofang
//
//  Created by Ryan on 2016/11/2.
//  Copyright © 2016年 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(uint32_t, PALogType) {
    PALogTypeError = 1 << 1,
    PALogTypeWarning = 1 << 2,
    PALogTypeInfo = 1 << 3,
    PALogTypeVerbose = 1 << 4,
    PALogType_WebRequest = 1 << 5,
    PALogType_SDK = 1 << 6,
    PALogType_Data = 1 << 7,
    PALogType_ObjectLife = 1 << 8,
    PALogType_UserRelated = 1 << 9,
    PALogType_OtherInfo = 1 << 10,
    PALogType_None = 1 << 11,
};
// If set to 0, disables .set to 1 enables
//Log总开关
#ifndef PADebugLoggingEnabled
#if DEBUG == 0
#define PADebugLoggingEnabled 0
#else
#define PADebugLoggingEnabled 1
#endif

//网络Log开关
#ifndef PADebugWebLoggingEnabled
#define PADebugWebLoggingEnabled 1
#endif

//SDKLog开关
#ifndef PADebugSDKLoggingEnabled
#define PADebugSDKLoggingEnabled 1
#endif

//数据操作Log开关
#ifndef PADebugDataLoggingEnabled
#define PADebugDataLoggingEnabled 1
#endif

//对象信息Log开关
#ifndef PADebugObjectLifeLoggingEnabled
#define PADebugObjectLifeLoggingEnabled 1
#endif

//用户登录信息Log开关
#ifndef PADebugUserRelatedLoggingEnabled
#define PADebugUserRelatedLoggingEnabled 1
#endif

//其他信息Log开关
#ifndef PADebugOtherInfoLoggingEnabled
#define PADebugOtherInfoLoggingEnabled 1
#endif

#endif
