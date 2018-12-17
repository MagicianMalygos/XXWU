//
//  XXWUHomeViewController.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUHomeViewController.h"
#import "XXWUHomeMainEntranceDataModel.h"

@interface XXWUHomeViewController ()

@property (nonatomic, strong) NSMutableArray *mainEntranceModelArr;

@end

@implementation XXWUHomeViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
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
    for (XXWUHomeMainEntranceDataModel *model in self.mainEntranceModelArr) {
        ZCPSectionCellItem *item = [[ZCPSectionCellItem alloc] initWithDefault];
        item.sectionTitlePosition   = ZCPSectionTitleLeftPosition;
        item.sectionTitleFont       = [UIFont systemFontOfSize:20.0f];
        item.cellHeight             = @(50.0f);
        item.sectionTitle           = model.text;
        [items addObject:item];
    }
    self.tableViewAdaptor.items = items;
    [self.tableView reloadData];
}

#pragma mark - ZCPListTableViewAdaptorDelegate

- (void)tableView:(UITableView *)tableView didSelectObject:(id<ZCPTableViewCellItemBasicProtocol>)object rowAtIndexPath:(NSIndexPath *)indexPath {
    XXWUHomeMainEntranceDataModel *model = self.mainEntranceModelArr[indexPath.row];
    NSLog(@"%@", model.url);
    openURL(model.url);
}

#pragma mark - getters and setters

- (NSMutableArray *)mainEntranceModelArr {
    if (!_mainEntranceModelArr) {
        _mainEntranceModelArr = [NSMutableArray array];
    }
    return _mainEntranceModelArr;
}

@end
