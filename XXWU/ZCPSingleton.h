//
//  ZCPSingleton.h
//  Apartment
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 zcp. All rights reserved.
//

#import <objc/runtime.h>

#ifndef ZCPSingleton_h
#define ZCPSingleton_h

#pragma mark - 单例宏

// 定义 define
#if __has_feature(objc_instancetype)

#undef  DEF_SINGLETON
#define DEF_SINGLETON \
    + (_Nullable instancetype)sharedInstance;

#undef  DEF_SINGLETON_P
#define DEF_SINGLETON_P(__methodName) \
    + (_Nullable instancetype)__methodName;

#else

#undef	DEF_SINGLETON
#define DEF_SINGLETON(__class) \
    + (__class *)sharedInstance;

#undef	DEF_SINGLETON_P
#define DEF_SINGLETON_P(__class, __methodName) \
+ (__class *)__methodName;

#endif

// 实现 implement
#undef  IMP_SINGLETON
#define IMP_SINGLETON(__class) \
    \
    + (instancetype)sharedInstance { \
        static dispatch_once_t once; \
        static id __singleton__; \
        dispatch_once(&once, ^{ \
            __singleton__ = [[super allocWithZone:NULL] init]; \
        }); \
        return __singleton__; \
    } \
    \
    + (instancetype)allocWithZone:(struct _NSZone *)zone { \
        return [__class sharedInstance]; \
    } \
    - (instancetype)copyWithZone:(struct _NSZone *)zone { \
        return [__class sharedInstance]; \
    } \
    - (instancetype)mutableCopyWithZone:(NSZone *)zone { \
        return [__class sharedInstance]; \
    }

#undef  IMP_SINGLETON_P
#define IMP_SINGLETON_P(__class, __methodName) \
    \
    + (instancetype)__methodName { \
        static dispatch_once_t once; \
        static id __singleton__; \
        dispatch_once(&once, ^{ \
            __singleton__ = [[super allocWithZone:NULL] init]; \
        }); \
        return __singleton__; \
    } \
    \
    + (instancetype)allocWithZone:(struct _NSZone *)zone { \
        return [__class __methodName]; \
    } \
    - (instancetype)copyWithZone:(struct _NSZone *)zone { \
        return [__class __methodName]; \
    } \
    - (instancetype)mutableCopyWithZone:(NSZone *)zone { \
        return [__class __methodName]; \
    }

#endif /* ZCPSingleton_h */
