//
//  ZCPCoreDataManager.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/5/7.
//

#import <Foundation/Foundation.h>
#import "ZCPGlobal.h"

FOUNDATION_EXPORT NSErrorDomain _Nullable const ZCPCoreDataErrorDomain;

/**
 错误码
 */
typedef NS_ENUM(NSInteger, ZCPCoreDataErrorCode) {
    /// 参数为空
    ZCPCoreDataParamNullError           = 1,
    /// 查询结果为空
    ZCPCoreDataRetrieveResultNullError  = 2,
};

/// CoreData管理者
@interface ZCPCoreDataManager : NSObject

DEF_SINGLETON

/**
 初始化
 */
+ (void)setupCoreDataStack;
+ (void)setupCoreDataStackWithInMemoryStore;
+ (void)setupAutoMigratingCoreDataStack;

+ (void)setupCoreDataStackWithStoreNamed:(nonnull NSString *)storeName;
+ (void)setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(nonnull NSString *)storeName;

@end
