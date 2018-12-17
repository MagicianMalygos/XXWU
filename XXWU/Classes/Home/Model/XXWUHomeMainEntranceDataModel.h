//
//  XXWUHomeMainEntranceDataModel.h
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import <ZCPTableViewCellDataModel.h>

NS_ASSUME_NONNULL_BEGIN

/**
 首页主入口跳转类型

 - XXWUHomeMainEntranceJumpTypeNative: 本地跳转
 - XXWUHomeMainEntranceJumpTypeH5: H5跳转
 */
typedef NS_ENUM(NSInteger, XXWUHomeMainEntranceJumpType) {
    XXWUHomeMainEntranceJumpTypeNative = 1,
    XXWUHomeMainEntranceJumpTypeH5 = 2
};

@interface XXWUHomeMainEntranceDataModel : ZCPTableViewCellDataModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) XXWUHomeMainEntranceJumpType type;
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
