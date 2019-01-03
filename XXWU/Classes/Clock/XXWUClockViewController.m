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
#import "XXWUClockQuickToolView.h"

/// 时间格式
static NSString * const XXWUClockDateFormat = @"HH:mm:ss";
/// 本地通知名key
static NSString * const kLocalNotificationNameKey = @"kLocalNotificationName";
/// 闹钟本地通知名value
static NSString * const kClockNotificationName = @"kClockNotification";
/// 倒计时缓存key
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
/// 快捷工具视图
@property (nonatomic, strong) XXWUClockQuickToolView *toolView;

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
    [self setupData];
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.inputView.frame = CGRectMake(0, 200, self.view.width, 50);
    self.countdownView.frame = CGRectMake(0, 0, self.view.width, 150);
    self.startButton.frame = CGRectMake(40, self.countdownView.bottom + 40, 80, 80);
    self.stopButton.frame = CGRectMake(self.view.width - 120, self.countdownView.bottom + 40, 80, 80);
    self.startButton.layer.cornerRadius = 40;
    self.stopButton.layer.cornerRadius = 40;
    CGFloat toolViewHeight = [self.toolView sizeThatFits:CGSizeZero].height;
    self.toolView.frame = CGRectMake(0, self.view.height - toolViewHeight, self.view.width, toolViewHeight);
}

#pragma mark - setup

- (void)setupUI {
    // add sbuviews
    [self.view addSubview:self.countdownView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.toolView];
    
    // bind callback
    @weakify(self);
    void(^block)(NSInteger hour, NSInteger minute, NSInteger second) = ^(NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        if (self.isActive) {
            return;
        }
        NSString *dateStr = [NSString stringWithFormat:@"%.2li:%.2li:%.2li", hour, minute, second];
        NSDate *date = [NSDate dateFromString:dateStr withDateFormat:XXWUClockDateFormat];
        self.countdown = hour * 3600 + minute * 60 + second;
        self.currentTime = date;
        [self.countdownView setDate:date animated:YES];
    };
    self.pickerView.confirmBlock = block;
    self.toolView.responseBlock = block;
    
    // bind event
    [self.countdownView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCountDownView)]];
    [self.startButton addTarget:self action:@selector(clickStartButton) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton addTarget:self action:@selector(clickStopButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupData {
    NSDate *date = [self getCacheCountdownDate];
    NSTimeInterval countdown = [date timeIntervalSinceDate:[NSDate date]];
    if (countdown > 0) {
        self.active = YES;
        self.countdown = countdown;
        [self updateCountdownViewWithCountdown:self.countdown];
        [self startCountdown];
    }
    [self.toolView update];
    [self.view setNeedsLayout];
}

#pragma mark - private

- (void)addLocalNotification:(NSDate *)date {
    [self removeLocalNotification];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        NSDictionary *alertInfo = ReadUserDefaults(kClockLocationAlertKey);
        notification.fireDate = date;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertTitle = alertInfo[@"title"];
        notification.alertBody = alertInfo[@"body"];
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
    self.active = YES;
    [self updateTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)stopCountdown {
    self.active = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.currentTime = [NSDate dateFromString:@"00:00:00" withDateFormat:XXWUClockDateFormat];
    [self.countdownView setDate:self.currentTime animated:YES];
}

- (NSDate *)getCacheCountdownDate {
    NSDate *date = ReadUserDefaults(kCacheCountdownDateKey);
    if (date && [date isKindOfClass:[NSDate class]] && [[NSDate date] compare:date] == NSOrderedAscending) {
        return date;
    }
    return nil;
}

- (void)cacheCountdownDate:(NSDate *)date {
    SaveUserDefaults(date, kCacheCountdownDateKey);
    UserDefaultsSync();
}

- (void)cleanCountdownDate {
    RemoveUserDefaults(kCacheCountdownDateKey);
    UserDefaultsSync();
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

#pragma mark - motion

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [super motionBegan:motion withEvent:event];
    
    @weakify(self);
    dispatch_block_t block = ^(void) {
        [weakself.toolView update];
    };
    
    if ([[XXWUSettingsManager sharedInstance] isOpenShake]) {
        [[ZCPNavigator sharedInstance] gotoViewWithIdentifier:APPURL_VIEW_IDENTIFIER_CLOCK_HELPER queryForInit:@{@"_callback": block} propertyDictionary:nil];
    }
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

- (XXWUClockQuickToolView *)toolView {
    if (!_toolView) {
        _toolView = [[XXWUClockQuickToolView alloc] init];
        _toolView.layer.borderColor = [UIColor colorFromHexRGB:@"dfdfdf"].CGColor;
        _toolView.layer.borderWidth = 1;
    }
    return _toolView;
}

@end
