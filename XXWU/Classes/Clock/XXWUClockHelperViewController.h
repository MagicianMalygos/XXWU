//
//  XXWUClockHelperViewController.h
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 闹钟摇一摇配置页
 */
@interface XXWUClockHelperViewController : ZCPViewController

@property (nonatomic, copy) dispatch_block_t callback;

@end

NS_ASSUME_NONNULL_END
