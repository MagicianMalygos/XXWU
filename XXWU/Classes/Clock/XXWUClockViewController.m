//
//  XXWUClockViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUClockViewController.h"

@interface XXWUClockViewController ()

@end

@implementation XXWUClockViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  监听推送通知，收到了就放音乐
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"闹钟管理";
}

#pragma mark - getters and setters



@end
