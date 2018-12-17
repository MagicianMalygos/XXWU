//
//  ZCPNetworkDataConstructor.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPBasicDataConstructor.h"
@class ZCPDataModel;

@protocol ZCPNetworkDataConstructorDelegate;

// ----------------------------------------------------------------------
#pragma mark - 网络数据构造器协议
// ----------------------------------------------------------------------
@protocol ZCPNetworkDataConstructorDelegate <NSObject>

@optional
- (void)dataConstructorDidStartLoadData:(ZCPBasicDataConstructor *)dataConstructor;
- (void)dataConstructor:(ZCPBasicDataConstructor *)dataConstructor didFinishLoad:(ZCPDataModel *)dataModel;
- (void)dataConstructorDidFailLoadData:(ZCPBasicDataConstructor *)dataConstructor withError:(ZCPDataModel *)errorDataModel;

@end

// ----------------------------------------------------------------------
#pragma mark - 网络数据构造器
// ----------------------------------------------------------------------
@interface ZCPNetworkDataConstructor : ZCPBasicDataConstructor {
    BOOL _loading;
}

// delegate
@property (nonatomic, weak) id<ZCPNetworkDataConstructorDelegate> delegate;
// 数据加载状态
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

// ----------------------------------------------------------------------
#pragma mark 子类覆盖方法
// ----------------------------------------------------------------------

// 加载数据
- (void)loadData;

//开始加载数据
- (void)didStartLoadData;

// 数据加载完成
- (void)didFinishLoadData:(ZCPDataModel *)dataModel;
- (void)didFinishLoadData:(ZCPDataModel *)dataModel request:(id)request;
- (void)didFinishLoadData:(ZCPDataModel *)dataModel operation:(id)operation;

// 数据加载失败
- (void)didFailLoadData:(ZCPDataModel *)errorModel;
- (void)didFailLoadData:(ZCPDataModel *)errorModel request:(id)request;
- (void)didFailLoadData:(ZCPDataModel *)errorModel operation:(id)operation;

// 重置数据
- (void)resetData;

// 所有item个数
- (NSInteger)allItemCount;

// 是否还有更多数据
- (BOOL)hasNoMore;

@end
