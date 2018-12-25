//
//  XXWUClockViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUClockViewController.h"

@interface XXWUClockViewController ()

@property (nonatomic, strong) UIButton *openButton;

@end

@implementation XXWUClockViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  监听推送通知，收到了就放音乐
    [self.view addSubview:self.openButton];
    self.openButton.frame = CGRectMake(100, 100, 100, 100);
    [self.openButton addTarget:self action:@selector(clickOpenButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"闹钟管理";
}

#pragma mark - event response

- (void)clickOpenButton {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertTitle = @"AlertTitle 1";
        notification.alertBody = @"AlertBody 1";
        notification.soundName = @"voice.mp3";
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"notification_1", @"id", nil];
        notification.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - getters and setters


- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.backgroundColor = [UIColor redColor];
        [_openButton setTitle:@"5s" forState:UIControlStateNormal];
    }
    return _openButton;
}

@end
