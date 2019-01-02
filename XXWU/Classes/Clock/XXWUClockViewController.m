//
//  XXWUClockViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUClockViewController.h"
#import "FoldClockView.h"
#import "XXWUClockPicker.h"

static NSString * const XXWUClockDateFormat = @"HH:mm:ss";
static NSString * const kLocalNotificationNameKey = @"kLocalNotificationName";
static NSString * const kClockNotificationName = @"kClockNotification";
static NSString * const kCacheCountdownDateKey = @"kCacheCountdownDateKey";

@interface XXWUClockViewController () <UITextFieldDelegate>

/// 时间选择器
@property (nonatomic, strong) XXWUClockPicker *pickerView;
/// 倒计时view
@property (nonatomic, strong) FoldClockView *countdownView;
/// 开始按钮
@property (nonatomic, strong) UIButton *startButton;
/// 停止按钮
@property (nonatomic, strong) UIButton *stopButton;

/// 计时器
@property (nonatomic, strong) NSTimer *timer;
/// 倒计时时间，格式为HH:mm:ss
@property (nonatomic, strong) NSDate *currentTime;
/// 倒计时时间，单位为秒
@property (nonatomic, assign) NSInteger countdown;

/// 是否正在倒计时
@property (nonatomic, assign, getter=isActive) BOOL active;

@end

@implementation XXWUClockViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    NSDate *date = [self getCacheCountdownDate];
    
    NSTimeInterval countdown = [date timeIntervalSinceDate:[NSDate date]];
    if (countdown > 0) {
        self.active = YES;
        self.countdown = countdown;
        [self updateCountdownViewWithCountdown:self.countdown];
        [self startCountdown];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"闹钟管理";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setupUI {
    [self.view addSubview:self.countdownView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    
    @weakify(self);
    self.pickerView.confirmBlock = ^(NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        NSString *dateStr = [NSString stringWithFormat:@"%.2li:%.2li:%.2li", hour, minute, second];
        NSDate *date = [NSDate dateFromString:dateStr withDateFormat:XXWUClockDateFormat];
        self.countdown = hour * 3600 + minute * 60 + second;
        self.currentTime = date;
        [self.countdownView setDate:date animated:NO];
    };
    [self.countdownView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCountDownView)]];
    [self.startButton addTarget:self action:@selector(clickStartButton) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self action:@selector(clickStopButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.inputView.frame = CGRectMake(0, 200, self.view.width, 50);
    self.countdownView.frame = CGRectMake(0, 0, self.view.width, 150);
    self.startButton.frame = CGRectMake(40, self.countdownView.bottom + 40, 80, 80);
    self.stopButton.frame = CGRectMake(self.view.width - 120, self.countdownView.bottom + 40, 80, 80);
    self.startButton.layer.cornerRadius = 40;
    self.stopButton.layer.cornerRadius = 40;
}

#pragma mark - private

- (void)addLocalNotification:(NSDate *)date {
    [self removeLocalNotification];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        notification.fireDate = date;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertTitle = @"⚠️警告⚠️";
        notification.alertBody = @"手机即将爆炸💥";
        notification.soundName = @"voice.mp3";
        NSDictionary *infoDict = @{kLocalNotificationNameKey: kClockNotificationName};
        notification.userInfo = infoDict;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)removeLocalNotification {
    NSArray *scheduledLocalNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in scheduledLocalNotifications) {
        if ([[notification.userInfo objectForKey:kLocalNotificationNameKey] isEqualToString:kClockNotificationName]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
}

- (void)startCountdown {
    [self updateTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)stopCountdown {
    [self.timer invalidate];
    self.timer = nil;
    self.currentTime = [NSDate dateFromString:@"00:00:00" withDateFormat:XXWUClockDateFormat];
    [self.countdownView setDate:self.currentTime animated:NO];
}

- (NSDate *)getCacheCountdownDate {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kCacheCountdownDateKey];
    
    if ([[NSDate date] compare:date] == NSOrderedDescending) {
        return nil;
    }
    return date;
}

- (void)cacheCountdownDate:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:kCacheCountdownDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanCountdownDate {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCacheCountdownDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateCountdownViewWithCountdown:(NSInteger)countdown {
    NSInteger hour = self.countdown / 3600;
    NSInteger minute = self.countdown % 3600 / 60;
    NSInteger second = self.countdown % 60;
    
    NSString *dateStr = [NSString stringWithFormat:@"%.2li:%.2li:%.2li", hour, minute, second];
    NSDate *date = [NSDate dateFromString:dateStr withDateFormat:XXWUClockDateFormat];
    self.currentTime = date;
    [self.countdownView setDate:date animated:YES];
}

#pragma mark - event response

- (void)tapCountDownView {
    if (!self.isActive) {
        [self.pickerView show];
    }
}

- (void)clickStartButton {
    if (!self.active) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:self.countdown];
        [self addLocalNotification:date];
        [self cacheCountdownDate:date];
        [self startCountdown];
    }
}

- (void)clickStopButton {
    [self stopCountdown];
    [self removeLocalNotification];
    [self cleanCountdownDate];
}

- (void)updateTime {
    self.countdown--;
    if (self.countdown < 0) {
        [self stopCountdown];
        return;
    }
    
    [self updateCountdownViewWithCountdown:self.countdown];
}

#pragma mark - getters and setters

- (XXWUClockPicker *)pickerView {
    if (!_pickerView) {
        _pickerView = [[XXWUClockPicker alloc] init];
    }
    return _pickerView;
}

- (FoldClockView *)countdownView {
    if (!_countdownView) {
        self.currentTime = [NSDate dateFromString:@"00:00:00" withDateFormat:@"HH:mm:ss"];
        _countdownView = [[FoldClockView alloc] initWithDate:self.currentTime];
    }
    return _countdownView;
}

- (UIButton *)startButton {
    if (!_startButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorFromHexRGB:@"66CD00"];
        button.layer.masksToBounds = YES;
        [button setTitle:@"开始" forState:UIControlStateNormal];
        _startButton = button;
    }
    return _startButton;
}

- (UIButton *)stopButton {
    if (!_stopButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorFromHexRGB:@"ff4040"];
        button.layer.masksToBounds = YES;
        [button setTitle:@"停止" forState:UIControlStateNormal];
        _stopButton = button;
    }
    return _stopButton;
}

@end
