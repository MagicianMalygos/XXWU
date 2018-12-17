//
//  ZCPTableViewController.m
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/21.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewController.h"

@implementation ZCPTableViewController

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize tableView           = _tableView;
@synthesize tableViewAdaptor    = _tableViewAdaptor;

// ----------------------------------------------------------------------
#pragma mark - init
// ----------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

// ----------------------------------------------------------------------
#pragma mark - life cycle
// ----------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self initialize];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 调整tableview
    self.tableView.height = self.view.height;
}

// ----------------------------------------------------------------------
#pragma mark - functions
// ----------------------------------------------------------------------

/**
 初始化方法
 */
- (void)initialize {
    // 创建tableView 适配器
    [self createTableViewAdaptor];
    // 构造数据
    [self constructData];
    // 创建TableView
    [self createTableView];
}

/**
 创建适配器
 */
- (void)createTableViewAdaptor {
    if (self.isMultipleGroups) {
        self.tableViewAdaptor       = [[ZCPGroupListTableViewAdaptor alloc] init];
    } else {
        self.tableViewAdaptor       = [[ZCPListTableViewAdaptor alloc] init];
    }
    self.tableViewAdaptor.delegate  = self;
}

/**
 创建tableview
 */
- (void)createTableView {
    // 初始化tableview
    self.tableView                      = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.frame                = self.view.bounds;
    self.tableView.backgroundColor      = [UIColor clearColor];
    self.tableView.backgroundView       = nil;
    self.tableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource           = self.tableViewAdaptor;
    self.tableView.delegate             = self.tableViewAdaptor;
    self.tableView.scrollsToTop         = YES;
    
    self.tableViewAdaptor.tableView     = self.tableView;
    [self.view addSubview:self.tableView];
}

// ----------------------------------------------------------------------
#pragma mark - override
// ----------------------------------------------------------------------

/**
 构造数据，给适配器items赋值
 */
- (void)constructData {
}

/**
 返回是否是多分组的tableview
 */
- (BOOL)isMultipleGroups {
    return NO;
}

@end
