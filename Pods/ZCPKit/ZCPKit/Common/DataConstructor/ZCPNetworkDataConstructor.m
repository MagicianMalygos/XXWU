//
//  ZCPNetworkDataConstructor.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPNetworkDataConstructor.h"
#import "ZCPDataModel.h"

@interface ZCPNetworkDataConstructor ()

// 代理类Class
@property (nonatomic, strong) Class delegateClass;

@end

@implementation ZCPNetworkDataConstructor

#pragma mark - synthesize
@synthesize delegate        = _delegate;
@synthesize delegateClass   = _delegateClass;
@synthesize loading         = _loading;

#pragma mark - getter / setter
- (void)setDelegate:(id<ZCPNetworkDataConstructorDelegate>)delegate {
    _delegate = delegate;
    if (_delegate) {
        self.delegateClass = object_getClass(_delegate);
    }
    else {
        self.delegateClass = nil;
    }
}

#pragma mark - functions
- (BOOL)isDelegateValid {
    return (_delegate && object_getClass(_delegate) == _delegateClass);
}
- (BOOL)isLoading {
    return _loading;
}

#pragma mark - public method
- (void)loadData {
}
- (void)didStartLoadData {
}
- (void)didFinishLoadData:(ZCPDataModel *)dataModel {
    _loading = NO;
}
- (void)didFinishLoadData:(ZCPDataModel *)dataModel request:(id)request {
}
- (void)didFinishLoadData:(ZCPDataModel *)dataModel operation:(id)operation {
}
- (void)didFailLoadData:(ZCPDataModel *)errorModel {
    _loading = NO;
}
- (void)didFailLoadData:(ZCPDataModel *)errorModel request:(id)request {
}
- (void)didFailLoadData:(ZCPDataModel *)errorModel operation:(id)operation {
}
- (void)resetData {
}
- (BOOL)hasNoMore {
    return YES;
}
- (NSInteger)allItemCount {
    return 0;
}

@end
