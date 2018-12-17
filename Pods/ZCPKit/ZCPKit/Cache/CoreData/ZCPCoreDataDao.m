//
//  ZCPCoreDataDao.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/5/6.
//

#import "ZCPCoreDataDao.h"
#import "ZCPCoreDataManager.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation ZCPCoreDataDao

#pragma mark - 增加(Create)

/// 新增数据
- (void)createData:(nonnull NSObject *)dataModel completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion {
    
    if (!dataModel) {
        [self handleError:ZCPCoreDataParamNullError completion:completion];
        return;
    }
    
    // private -> root
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSString *entityName = [self entityName];
        assert(entityName != nil);
        
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:localContext];
        if ([self respondsToSelector:@selector(mappingDataModel:toManagedObject:)]) {
            [self mappingDataModel:dataModel toManagedObject:managedObject];
        }
    } completion:completion];
}

#pragma mark - 读取查询(Retrieve)

- (nullable NSArray *)retrieveAllData {
    NSArray *resultArray    = nil;
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:[self predicateFormatForRetrieveAllData]];
    resultArray             = [self retrieveDataWithPredicate:predicate];
    return resultArray;
}

- (nullable NSArray *)retrieveDataWithID:(nonnull NSString *)idString {
    NSArray *resultArray    = nil;
    if (!idString || idString.length == 0) {
        return nil;
    }
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:[self predicateFormatForRetrieveDataWithID:idString]];
    resultArray             = [self retrieveDataWithPredicate:predicate];
    return resultArray;
}

- (nullable NSArray *)retrieveDataWithPredicate:(nonnull NSPredicate *)predicate {
    NSArray *resultArray    = nil;
    NSArray *transformArray = nil;
    
    NSString *entityName    = [self entityName];
    assert(entityName != nil);
    
    // retrieve
    NSManagedObject *mo     = [[NSClassFromString(entityName) alloc] init];
    if (predicate) {
        resultArray         = [[mo class] MR_findAllWithPredicate:predicate];
    } else {
        resultArray         = [[mo class] MR_findAll];
    }
    
    // transform
    if (resultArray) {
        transformArray      = [self transformManagedObjects:resultArray];
    }
    
    return transformArray;
}

- (nullable NSArray *)retrieveDataWithOffset:(NSUInteger)offset limit:(NSUInteger)limit {
    NSArray *resultArray    = nil;
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:[self predicateFormatForRetrieveAllData]];
    resultArray             = [self retrieveDataWithPredicate:predicate offset:offset limit:limit];
    return resultArray;
}

- (nullable NSArray *)retrieveDataWithPredicate:(nonnull NSPredicate *)predicate offset:(NSUInteger)offset limit:(NSUInteger)limit {
    NSArray *resultArray        = nil;
    NSArray *transformArray     = nil;
    
    NSString *entityName        = [self entityName];
    assert(entityName != nil);
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:limit];
    [fetchRequest setFetchOffset:offset];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    resultArray                 = [self retrieveDataWithFetchRequest:fetchRequest];
    if (resultArray) {
        transformArray          = [self transformManagedObjects:resultArray];
    }
    
    return transformArray;
}

- (nullable NSArray *)retrieveDataWithFetchRequest:(nonnull NSFetchRequest *)fetchRequest {
    NSArray *resultArray    = nil;
    
    NSString *entityName    = [self entityName];
    assert(entityName != nil);
    
    if (fetchRequest) {
        NSManagedObject *mo = [[NSClassFromString(entityName) alloc] init];
        resultArray         = [[mo class] MR_executeFetchRequest:fetchRequest];
    }
    return resultArray;
}

- (NSUInteger)retrieveDataCount {
    NSString *entityName        = [self entityName];
    assert(entityName != nil);
    
    NSPredicate *predicate      = [NSPredicate predicateWithFormat:[self predicateFormatForRetrieveAllData]];
    
    NSManagedObject *mo         = [[NSClassFromString(entityName) alloc] init];
    NSUInteger count            = [[mo class] MR_countOfEntitiesWithPredicate:predicate];
    return count;
}

- (BOOL)isDataExists:(NSString *)idString {
    BOOL exists                 = NO;
    NSArray *resultArray        = nil;
    
    NSString *predicateFormat   = [self predicateFormatForRetrieveDataWithID:idString];
    NSPredicate *predicate      = [NSPredicate predicateWithFormat:predicateFormat];
    resultArray                 = [self retrieveDataWithPredicate:predicate];
    
    if (resultArray && resultArray.count) {
        exists                  = YES;
    }
    
    return exists;
}

#pragma mark - 更新(Update)

/// 更新数据
- (void)updateData:(NSObject *)dataModel withID:(nonnull NSString *)idString completion:(void (^ _Nullable)(BOOL, NSError * _Nullable))completion {
    
    if (!dataModel || !idString || idString.length == 0) {
        [self handleError:ZCPCoreDataParamNullError completion:completion];
        return;
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        // search
        NSString *entityName    = [self entityName];
        assert(entityName != nil);
        NSManagedObject *mo     = [[NSClassFromString(entityName) alloc] init];
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:[self predicateFormatForRetrieveDataWithID:idString]];
        NSArray *resultArray    = [[mo class] MR_findAllWithPredicate:predicate inContext:localContext];
        // update
        for (NSManagedObject *mo in resultArray) {
            [self mappingDataModel:dataModel toManagedObject:mo];
        }
    } completion:completion];
}

#pragma mark - 删除(Delete)

- (void)deleteAllData:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion {
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:[self predicateFormatForDeleteAllData]];
    [self deleteDataWithPredicate:predicate completion:completion];
}

- (void)deleteDataWithPredicate:(nonnull NSPredicate *)predicate completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion {
    // private -> root
    NSManagedObjectContext *savingContext  = [NSManagedObjectContext MR_rootSavingContext];
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextWithParent:savingContext];
    
    // search
    NSString *entityName    = [self entityName];
    assert(entityName != nil);
    NSManagedObject *mo     = [[NSClassFromString(entityName) alloc] init];
    NSArray *resultArray    = nil;
    if (predicate) {
        resultArray         = [[mo class] MR_findAllWithPredicate:predicate inContext:localContext];
    } else {
        resultArray         = [[mo class] MR_findAllInContext:localContext];
    }
    if (!resultArray || resultArray.count == 0) {
        [self handleError:ZCPCoreDataRetrieveResultNullError completion:completion];
        return;
    }
    
    [localContext performBlock:^{
        [localContext MR_setWorkingName:NSStringFromSelector(@selector(saveWithBlock:completion:))];
        // delete
        [localContext MR_deleteObjects:resultArray];
        [localContext MR_saveWithOptions:MRSaveParentContexts completion:completion];
    }];
}

- (void)deleteDataWithID:(nonnull NSString *)idString completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion {
    if (!idString || idString.length == 0) {
        [self handleError:ZCPCoreDataParamNullError completion:completion];
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[self predicateFormatForDeleteDataWithID:idString]];
    [self deleteDataWithPredicate:predicate completion:completion];
}

- (void)deleteDataWithDataModel:(nonnull NSObject *)dataModel completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion {
    if (!dataModel) {
        [self handleError:ZCPCoreDataParamNullError completion:completion];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[self predicateFormatForDeleteDataWithDataModel:dataModel]];
    [self deleteDataWithPredicate:predicate completion:completion];
}

#pragma mark - transform

- (nullable NSArray *)transformManagedObjects:(nullable NSArray *)array {
    if (!array || array.count == 0) {
        return nil;
    }
    
    NSMutableArray *transformArray = [NSMutableArray array];
    
    for (NSManagedObject *managedObject in array) {
        Class  dataModelClass   = [self dataModelClass];
        NSObject *dataModel     = [[dataModelClass alloc] init];
        if ([self respondsToSelector:@selector(mappingManagedObject:toDataModel:)]) {
            [self mappingManagedObject:managedObject toDataModel:dataModel];
            [transformArray addObject:dataModel];
        }
    }
    return transformArray;
}

// MARK: 子类需要覆盖这些方法

- (void)mappingDataModel:(NSObject *)dataModel toManagedObject:(NSManagedObject *)managedObject {
}

- (void)mappingManagedObject:(NSManagedObject *)managedObject toDataModel:(NSObject *)dataModel {
}

- (nonnull NSString *)entityName {
    return @"";
}

- (nonnull Class)dataModelClass {
    return [NSObject class];
}

#pragma mark - fetch format

- (nullable NSString *)predicateFormatForRetrieveAllData {
    NSString *predicate = nil;
    return predicate;
}

- (nullable NSString *)predicateFormatForRetrieveDataWithID:(nonnull NSString *)idString {
    NSString *predicate = nil;
    return predicate;
}

- (nullable NSString *)predicateFormatForDeleteAllData {
    NSString *predicate = nil;
    return predicate;
}

- (nullable NSString *)predicateFormatForDeleteDataWithID:(nonnull NSString *)idString {
    NSString *predicate = nil;
    return predicate;
}

- (nullable NSString *)predicateFormatForDeleteDataWithDataModel:(nonnull NSObject *)dataModel {
    NSString *predicate = nil;
    return predicate;
}

#pragma mark - private

- (void)handleError:(ZCPCoreDataErrorCode)errorCode completion:(void(^ _Nullable)(BOOL contextDidSave, NSError * _Nullable error))completion {
    NSError *error = nil;
    if (errorCode == ZCPCoreDataParamNullError) {
        error = [NSError errorWithDomain:ZCPCoreDataErrorDomain code:ZCPCoreDataParamNullError userInfo:@{NSLocalizedDescriptionKey:@"传入参数不能为空"}];
    } else if (errorCode == ZCPCoreDataRetrieveResultNullError) {
        error = [NSError errorWithDomain:ZCPCoreDataErrorDomain code:ZCPCoreDataParamNullError userInfo:@{NSLocalizedDescriptionKey:@"查询结果为空"}];
    }
    if (completion) {
        completion(NO, error);
    }
}

@end

