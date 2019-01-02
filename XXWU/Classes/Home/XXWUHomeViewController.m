//
//  XXWUHomeViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUHomeViewController.h"
#import "XXWUHomeMainEntranceDataModel.h"
#import "XXWUHomeMainEntranceCell.h"

@interface XXWUHomeViewController ()

/// 首页主入口模型列表
@property (nonatomic, strong) NSMutableArray *mainEntranceModelArr;

@end

@implementation XXWUHomeViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"首页";
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - data

- (void)loadData {
    [[AFHTTPSessionManager manager] GET:@"https://api.xxwu.me/menu" parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)responseObject;
            for (NSDictionary *dict in arr) {
                XXWUHomeMainEntranceDataModel *model = [XXWUHomeMainEntranceDataModel yy_modelWithJSON:dict];
                [self.mainEntranceModelArr addObject:model];
            }
            [self reloadTableViewData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
    }];
}

- (void)reloadTableViewData {
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.mainEntranceModelArr.count; i+=2) {
        XXWUHomeMainEntranceCellItem *item = [[XXWUHomeMainEntranceCellItem alloc] initWithDefault];
        
        XXWUHomeMainEntranceDataModel *leftModel = self.mainEntranceModelArr[i];
        XXWUHomeMainEntranceDataModel *rightModel = nil;
        item.leftIcon = [self iconFromHexString:leftModel.icon];
        item.leftTitle = leftModel.text;
        item.leftBackgroundColor = [self randomColor];
        
        if (i+1 < self.mainEntranceModelArr.count) {
            rightModel = self.mainEntranceModelArr[i+1];
            item.rightIcon = [self iconFromHexString:leftModel.icon];
            item.rightTitle = rightModel.text;
            item.rightBackgroundColor = [self randomColor];
        }
        
        item.eventHandler = ^(BOOL isLeftView) {
            NSString *url = isLeftView ? leftModel.url : rightModel.url;
            DebugLog(@"app open url: %@", url);
            openURL(url);
        };
        
        [items addObject:item];
    }
    self.tableViewAdaptor.items = items;
    [self.tableView reloadData];
}

- (UIColor *)randomColor {
    NSInteger randomCase = [@[@1, @2, @3][RANDOM(0, 2)] integerValue];
    UIColor *color = nil;
    
    switch (randomCase) {
        case 1:{
            color = [UIColor colorWithRed:RANDOMF(0.7, 1) green:RANDOMF(0, 0.3) blue:RANDOMF(0, 0.3) alpha:1.0f];
        }
            break;
        case 2:{
            color = [UIColor colorWithRed:RANDOMF(0, 0.3) green:RANDOMF(0.7, 1) blue:RANDOMF(0, 0.3) alpha:1.0f];
        }
            break;
        case 3:{
            color = [UIColor colorWithRed:RANDOMF(0, 0.3) green:RANDOMF(0, 0.3) blue:RANDOMF(0.7, 1) alpha:1.0f];
        }
            break;
        default:
            break;
    }
    return color;
}

- (NSString *)iconFromHexString:(NSString *)hexString {
    
    hexString = hexString.lowercaseString;
    int  length = (int)hexString.length;
    unichar sum = 0;
    for (int i = length - 1; i >= 0; i--) {
        
        char c = (char)[hexString characterAtIndex:i];
        if (c >= '0' && c <= '9') {
            c = c - '0';
        } else if(c >= 'a' && c <= 'f') {
            c = c - 'a' + 10;
        }
        sum += c * (int)pow(16, length - 1 - i);
    }
    
    NSString *icon = [NSString stringWithCharacters:&sum length:1];
    return icon;
}

#pragma mark - getters and setters

- (NSMutableArray *)mainEntranceModelArr {
    if (!_mainEntranceModelArr) {
        _mainEntranceModelArr = [NSMutableArray array];
    }
    return _mainEntranceModelArr;
}

@end
