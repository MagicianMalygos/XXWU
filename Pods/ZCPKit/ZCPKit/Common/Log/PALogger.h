//
//  PALogger.h
//  haofang
//
//  Created by leo on 14/12/24.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PALogSwitch.h"

// log level
#define PALOG_LEVEL_ERROR (PALogTypeError)
#define PALOG_LEVEL_WARN (PALogTypeError|PALogTypeWarning)
#define PALOG_LEVEL_INFO (PALogTypeError|PALogTypeWarning|PALogTypeInfo)
#define PALOG_LEVEL_VERBOSE (PALogTypeError|PALogTypeWarning|PALogTypeInfo|PALogTypeVerbose|PALogType_ObjectLife|PALogType_WebRequest|PALogType_SDK|PALogType_UserRelated|PALogType_Data|PALogType_OtherInfo)

// log define
#if PADebugLoggingEnabled && DEBUG

#define PALogE(fmt, ...) log_content(PALogTypeError, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#define PALogW(fmt, ...) log_content(PALogTypeWarning, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#define PALogI(fmt, ...) log_content(PALogTypeInfo, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])

#if PADebugWebLoggingEnabled
#define PALogWB(fmt, ...) log_content(PALogType_WebRequest, [NSString stringWithFormat:@" " fmt, ##__VA_ARGS__])
#else
#define PALogWB(fmt, ...) log_content(PALogType_None, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#endif

#if PADebugSDKLoggingEnabled
#define PALogS(fmt, ...) log_content(PALogType_SDK, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#else
#define PALogS(fmt, ...) log_content(PALogType_None, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#endif

#if PADebugDataLoggingEnabled
#define PALogD(fmt, ...) log_content(PALogType_Data, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#else
#define PALogD(fmt, ...) log_content(PALogType_None, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#endif

#if PADebugObjectLifeLoggingEnabled
#define PALogO(fmt, ...) log_content(PALogType_ObjectLife, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#else
#define PALogO(fmt, ...) log_content(PALogType_None, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#endif

#if PADebugUserRelatedLoggingEnabled
#define PALogUS(fmt, ...) log_content(PALogType_UserRelated, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#else
#define PALogUS(fmt, ...) log_content(PALogType_None, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#endif

#if PADebugOtherInfoLoggingEnabled
#define PALogOT(fmt, ...) log_content(PALogType_OtherInfo, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#else
#define PALogOT(fmt, ...) log_content(PALogType_None, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])
#endif

#define PALogV(fmt, ...) log_content(PALogTypeVerbose, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__])

#define PALogC(definedSymBol, fmt, ...) while(0) {\
if(definedSymBol) \
log_content(PALogTypeInfo, [NSString stringWithFormat:@"<%s>[%d] " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]);\
}

#else

#define PALogE(fmt, ...)
#define PALogW(fmt, ...)
#define PALogI(fmt, ...)
#define PALogV(fmt, ...)

#define PALogWB(fmt, ...)
#define PALogS(fmt, ...)
#define PALogD(fmt, ...)
#define PALogO(fmt, ...)
#define PALogUS(fmt, ...)
#define PALogOT(fmt, ...)

#define PALogC(definedSymBol, fmt, ...)

#endif


#ifdef __cplusplus
extern "C" {
#endif

/**
 设置log类型

 @param types 类型，Error，Warning，Info，Verbose
 */
void set_log_types(uint32_t types);
/**
 获取log类型
 */
uint32_t get_log_types(void);

/**
 log打印

 @param type log类型
 @param content 内容
 */
void log_content(uint32_t type, NSString *content);


#pragma mark - 设置对象名称


@interface NSObject (PALogger)

/// The name of the instance. This is for debugging/human purposes only.
@property (copy) NSString *nameOfInstance;

/*!
 @brief  拷贝ReactiveCocoa中设置调试名的方法
 @return 返回自己
 */
- (instancetype)setNameWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

- (void)logInstanceName;

- (void)logInstanceNameForDealloc;

@end
    
#ifdef __cplusplus
}  // extern "C"
#endif
