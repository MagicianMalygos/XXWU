//
//  ZCPControllerFactory+Category.m
//  XXWU
//
//  Created by zcp on 2018/12/17.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "ZCPControllerFactory+Category.h"

@implementation ZCPControllerFactory  (Category)

- (UINavigationController *)generateCustomStack {
    
    // root viewcontrollers
    NSArray *vcIdentifiers = @[APPURL_VIEW_IDENTIFIER_HOME,
                               APPURL_VIEW_IDENTIFIER_VIEW];
    NSArray *titles = @[@"Home", @"Reserved"];
    NSArray *images = @[];
    NSArray *selectedImages = @[];
    
    // 初始化tab
    ZCPTabBarController *tabbarController = [[ZCPTabBarController alloc] init];
    tabbarController.viewControllers = [[ZCPControllerFactory sharedInstance] generateVCsWithIdentifiers:vcIdentifiers];
    [tabbarController setTabBarItemTitles:titles normalImages:images selectedImages:selectedImages];
    
    // 初始化nav
    ZCPNavigationController *navigationController = [[ZCPNavigationController alloc] initWithRootViewController:tabbarController];
    navigationController.navigationBar.translucent = NO;
    
    // 初始化状态栏
    [navigationController preferredStatusBarStyle];
    
    // 组成栈
    return navigationController;
}


/// 根据一组id生成一组vc对象
- (NSArray *)generateVCsWithIdentifiers:(NSArray *)identifiers {
    NSMutableArray *vcs             = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < identifiers.count; i++) {
        if (i > 5) {
            break;
        }
        NSString *vcIdentifier      = [identifiers objectAtIndex:i];
        ZCPVCDataModel *vcDataModel = [[ZCPControllerFactory sharedInstance] generateVCModelWithIdentifier:vcIdentifier];
        UIViewController *vc        = [[ZCPControllerFactory sharedInstance] generateVCWithVCModel:vcDataModel];
        if (vc && [vc isKindOfClass:[UIViewController class]]) {
            [[ZCPControllerFactory sharedInstance] configController:vc withVCDataModel:vcDataModel shouldCallInitMethod:YES];
            [vcs addObject:vc];
        }
    }
    return vcs;
}

@end
