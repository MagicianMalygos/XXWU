//
//  ZCPSingleton.h
//  Apartment
//
//  Created by zhuchaopeng on 15/12/28.
//  Copyright © 2015年 zcp. All rights reserved.
//

#import <objc/runtime.h>

#ifndef ZCPSingleton_h
#define ZCPSingleton_h

#pragma mark - 单例宏

// 定义 define
#if __has_feature(objc_instancetype)

    // 定义
    #undef  DEF_SINGLETON
    #define DEF_SINGLETON \
        + (nonnull instancetype)sharedInstance;
    // 实现
    #undef  IMP_SINGLETON
    #define IMP_SINGLETON \
        + (nonnull instancetype)sharedInstance { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once(&once, ^{ \
                __singleton__ = [[self alloc] init]; \
            }); \
            return __singleton__; \
        } \

    // 定义（自定义方法名）
    #undef  DEF_SINGLETON_C
    #define DEF_SINGLETON_C(__methodName) \
        + (nonnull instancetype)__methodName;
    // 实现（自定义方法名）
    #undef  IMP_SINGLETON_C
    #define IMP_SINGLETON_C(__methodName) \
        + (nonnull instancetype)__methodName { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once(&once, ^{ \
                __singleton__ = [[self alloc] init]; \
            }); \
            return __singleton__; \
        } \

#else

    // 定义
    #undef	DEF_SINGLETON
    #define DEF_SINGLETON(__class) \
        + (nonnull __class *)sharedInstance;
    // 实现
    #undef  IMP_SINGLETON
    #define IMP_SINGLETON(__class) \
    \
    + (nonnull instancetype)sharedInstance { \
        static dispatch_once_t once; \
        static id __singleton__; \
        dispatch_once(&once, ^{ \
            __singleton__ = [[[self class] alloc] init]; \
        }); \
        return __singleton__; \
    } \

    // 定义（自定义方法名）
    #undef  DEF_SINGLETON_C
    #define DEF_SINGLETON_C(__class, __methodName) \
        + (nonnull __class *)__methodName;
    // 定义（自定义方法名）
    #undef  IMP_SINGLETON_C
    #define IMP_SINGLETON_C(__class, __methodName) \
    \
    + (nonnull __class *)__methodName { \
        static dispatch_once_t once; \
        static __class * __singleton__; \
        dispatch_once(&once, ^{ \
            __singleton__ = [[[self class] alloc] init]; \
        }); \
        return __singleton__; \
    } \

#endif

#endif /* ZCPSingleton_h */
