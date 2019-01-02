//
//  XXWUClockPicker.h
//  XXWU
//
//  Created by zcp on 2019/1/2.
//  Copyright © 2019 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXWUClockPicker : UIView

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, copy) void(^confirmBlock)(NSInteger hour, NSInteger minute, NSInteger second);

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
