//
//  ZCPNavigator.m
//  Apartment
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 zcp. All rights reserved.
//

#import "ZCPNavigator.h"
#import "ZCPControllerFactory.h"
#import "ZCPVCDataModel.h"

// ----------------------------------------------------------------------
#pragma mark - 自定义导航器
// ----------------------------------------------------------------------
@implementation ZCPNavigator

@synthesize rootViewController  = _rootViewController;
@synthesize topViewController   = _topViewController;

IMP_SINGLETON

#pragma mark - 初始化

// 读取viewMap文件中的控制器信息
+ (void)readViewControllerMapWithViewMapNamed:(NSString *)viewMapNamed {
    NSString *viewMapPath   = [[NSBundle mainBundle] pathForResource:viewMapNamed ofType:@"plist"];
    NSArray *viewMap        = [NSArray arrayWithContentsOfFile:viewMapPath];
    NSMutableDictionary *vcDataModelDict = [NSMutableDictionary dictionary];
    
    if (viewMapPath && viewMap.count) {
        for (NSDictionary *viewMapItem in viewMap) {
            NSString *className                 = [viewMapItem objectForKey:@"className"];
            NSString *identifier                = [viewMapItem objectForKey:@"identifier"];
            
            // 生成identifier:viewDataModel键值对，并加入视图模型字典
            if (className && className.length && identifier && identifier.length) {
                Class vcClass                   = NSClassFromString(className);
                SEL initMethod                  = @selector(initWithQuery:);
                
                // 创建ViewController 配置对象
                ZCPVCDataModel *vcDataModel     = [[ZCPVCDataModel alloc] init];
                vcDataModel.vcClass             = vcClass;
                vcDataModel.vcInitMethod        = [NSValue valueWithPointer:initMethod];
                
                [vcDataModelDict setObject:vcDataModel forKey:identifier];
            }
        }
    }
    [[ZCPControllerFactory sharedInstance] setVCDataModelDict:vcDataModelDict];
}

// 初始化根视图控制器
- (void)setupRootViewController:(UIViewController<ZCPNavigatorProtocol> *)rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)rootViewController;
        _rootViewController         = rootViewController;
        _topViewController          = (UIViewController<ZCPNavigatorProtocol> *)nav.topViewController;
    } else {
        _rootViewController         = rootViewController;
        _topViewController          = nil;
    }
}

#pragma mark - jump

// 根据配置参数进行页面跳转
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary {
    if (identifier) {
        ZCPVCDataModel * viewDataModel      = [[ZCPControllerFactory sharedInstance] generateVCModelWithIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.propertyDictionary    = propertyDictionary;
        [self pushViewControllerWithViewDataModel:viewDataModel animated:YES];
    }
}

// 根据配置参数进行页面跳转
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary
                    retrospect:(BOOL)retrospect
                      animated:(BOOL)animated {
    if (identifier) {
        ZCPVCDataModel * viewDataModel      = [[ZCPControllerFactory sharedInstance] generateVCModelWithIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.propertyDictionary    = propertyDictionary;
        [self pushViewControllerWithViewDataModel:viewDataModel retrospect:retrospect animated:animated];
    }
}

@end
