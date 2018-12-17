//
//  ZCPCoreDataManager.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/5/7.
//

#import "ZCPCoreDataManager.h"
#import <MagicalRecord/MagicalRecord.h>

NSErrorDomain const ZCPCoreDataErrorDomain = @"ZCPCoreDataErrorDomain";

@implementation ZCPCoreDataManager

IMP_SINGLETON

- (instancetype)init {
    if (self = [super init]) {
        [MagicalRecord setErrorHandlerTarget:self action:@selector(handleError:)];
    }
    return self;
}

+ (void)setupCoreDataStack {
    [MagicalRecord setupCoreDataStack];
}

+ (void)setupCoreDataStackWithInMemoryStore {
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

+ (void)setupAutoMigratingCoreDataStack {
    [MagicalRecord setupAutoMigratingCoreDataStack];
}

+ (void)setupCoreDataStackWithStoreNamed:(nonnull NSString *)storeName {
    [MagicalRecord setupCoreDataStackWithStoreNamed:storeName];
}

+ (void)setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(nonnull NSString *)storeName {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:storeName];
}

+ (void)setupCoreDataStackWithStoreAtURL:(nonnull NSURL *)storeURL {
    [MagicalRecord setupCoreDataStackWithStoreAtURL:storeURL];
}

+ (void)setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:(nonnull NSURL *)storeURL {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:storeURL];
}

- (void)handleError:(NSError *)error {
    
}

@end
