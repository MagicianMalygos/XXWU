//
//  PALogger.m
//  haofang
//
//  Created by leo on 14/12/24.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "PALogger.h"
#import <objc/runtime.h>

static uint32_t log_types = PALOG_LEVEL_VERBOSE;

// 0 close  1 open
static NSInteger logInstanceName_flag = 1;

void set_log_types(uint32_t types)
{
    log_types = types;
}

uint32_t get_log_types(void)
{
    return log_types;
}

void log_content(uint32_t type, NSString *content)
{
    if (type & log_types) {
        NSLog(@"%@",content);
    }
}

#pragma mark - 设置对象名称

@implementation NSObject (PALogger)

// key as void
static void *kAssociatedKey = &kAssociatedKey;

- (void)setNameOfInstance:(NSString *)nameOfInstance {
    if (!nameOfInstance.length) {
        return;
    }
    objc_setAssociatedObject(self, kAssociatedKey, nameOfInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)nameOfInstance {
    id theObject = objc_getAssociatedObject(self, kAssociatedKey);
    if (!theObject) {
        return [NSString stringWithFormat:@"<%@: %p>", [self class], self];
    }
    return theObject;
}

- (instancetype)setNameWithFormat:(NSString *)format, ... {
	NSCParameterAssert(format != nil);

	va_list args;
	va_start(args, format);

	NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);

	self.nameOfInstance = str;
	return self;
}

- (void)logInstanceName {
    if (logInstanceName_flag) {
        NSString *theObject = objc_getAssociatedObject(self, kAssociatedKey);
        log_content(PALogTypeInfo, [NSString stringWithFormat:@"--><%@: %p>{ name: %@ }", [self class], self ,theObject]);
    }
}

- (void)logInstanceNameForDealloc {
    if (logInstanceName_flag) {
//        NSString *theObject = objc_getAssociatedObject(self, kAssociatedKey);
        PALogO(@"-->Free object <%@: %p>",[self class],self);
//        log_content(PALogTypeInfo, [NSString stringWithFormat:@"-->Free object <%@: %p>{ name: %@ }", [self class], self, theObject]);
    }
}

@end
