//
//  ZCPCoreDataDaoProtocol.h
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/5/6.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 使用coredata进行数据库相关操作的约定
 */
@protocol ZCPCoreDataDaoProtocol <NSObject>

@optional

#pragma mark - 增加(Create)

/**
 新增数据

 @param dataModel 数据模型
 @param completion 完成block
 */
- (void)createData:(nonnull NSObject *)dataModel completion:(void(^_Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion;

#pragma mark - 读取查询(Retrieve)

/**
 查询数据
 */
- (nullable NSArray *)retrieveAllData;
- (nullable NSArray *)retrieveDataWithID:(nonnull NSString *)idString;
- (nullable NSArray *)retrieveDataWithPredicate:(nonnull NSPredicate *)predicate;
- (nullable NSArray *)retrieveDataWithOffset:(NSUInteger)offset limit:(NSUInteger)limit;
- (nullable NSArray *)retrieveDataWithPredicate:(nonnull NSPredicate *)predicate offset:(NSUInteger)offset limit:(NSUInteger)limit;
- (nullable NSArray *)retrieveDataWithFetchRequest:(nonnull NSFetchRequest *)fetchRequest;

/**
 查询数据总数
 */
- (NSUInteger)retrieveDataCount;

/**
 查询数据是否存在

 @param idString 查询的数据ID
 @return 0不存在 1存在
 */
- (BOOL)isDataExists:(nonnull NSString *)idString;

#pragma mark - 更新(Update)

/**
 更新指定数据

 @param dataModel 要更新的数据模型对象
 */
- (void)updateData:(nonnull NSObject *)dataModel withID:(nonnull NSString *)idString completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion;

#pragma mark - 删除(Delete)

/**
 删除数据
 */
- (void)deleteAllData:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion;
- (void)deleteDataWithPredicate:(nonnull NSPredicate *)predicate completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion;
- (void)deleteDataWithID:(nonnull NSString *)idString completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion;
- (void)deleteDataWithDataModel:(nonnull NSObject *)dataModel completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion;

#pragma mark - transform

/**
 将数据模型对象映射到托管对象
 
 @param dataModel 数据模型对象
 @param managedObject 托管对象
 */
- (void)mappingDataModel:(nonnull NSObject *)dataModel toManagedObject:(nonnull NSManagedObject *)managedObject;

/**
 将托管对象映射到数据模型对象
 
 @param managedObject 托管对象
 @param dataModel 数据模型对象
 */
- (void)mappingManagedObject:(nonnull NSManagedObject *)managedObject toDataModel:(nonnull NSObject *)dataModel;

/**
 将数组中的NSManagedObject转化成相应的PADataModel对象

 @param array 待转换的NSManagedObject对象数组
 @return 转化后的NSObject对象数组
 */
- (nullable NSArray *)transformManagedObjects:(nullable NSArray *)array;

#pragma mark - helper

/**
 获取datamodel对应的类
 */
- (nonnull Class)dataModelClass;

/**
 获取实体名称，即对应的xcdatamodel中的实体名称
 */
- (nonnull NSString *)entityName;

#pragma mark - fetch format

/**
 用于查询数据的筛选条件
 */
- (nullable NSString *)predicateFormatForRetrieveAllData;
- (nullable NSString *)predicateFormatForRetrieveDataWithID:(nonnull NSString *)idString;

/**
 用于删除数据的筛选条件
 */
- (nullable NSString *)predicateFormatForDeleteAllData;
- (nullable NSString *)predicateFormatForDeleteDataWithID:(nonnull NSString *)idString;
- (nullable NSString *)predicateFormatForDeleteDataWithDataModel:(nonnull NSObject *)dataModel;

@end

