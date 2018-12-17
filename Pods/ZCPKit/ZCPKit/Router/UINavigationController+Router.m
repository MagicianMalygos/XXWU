//
//  UINavigationController+Router.m
//  Pods-ZCPKitExample
//
//  Created by 朱超鹏 on 2017/12/21.
//

#import "UINavigationController+Router.h"
#import "ZCPNavigator.h"
#import "Aspects.h"

@implementation UINavigationController (Router)

+ (void)load {
    NSError *error = nil;
    
    [UINavigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UINavigationController *nav = aspectInfo.instance;
        NSArray *arguments          = aspectInfo.arguments;
        [nav aop_pushViewController:arguments[0] animated:[arguments[1] boolValue]];
    } error:&error];
    
    if (error) NSLog(@"[zcp log] %@", error.localizedDescription);
    
    [UINavigationController aspect_hookSelector:@selector(popViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UINavigationController *nav = aspectInfo.instance;
        NSArray *arguments          = aspectInfo.arguments;
        [nav aop_popViewControllerAnimated:[arguments[0] boolValue]];
    } error:&error];
    
    if (error) NSLog(@"[zcp log] %@", error.localizedDescription);
    
    [UINavigationController aspect_hookSelector:@selector(popToViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UINavigationController *nav = aspectInfo.instance;
        NSArray *arguments          = aspectInfo.arguments;
        [nav aop_popToViewController:arguments[0] animated:[arguments[1] boolValue]];
    } error:&error];
    
    if (error) NSLog(@"[zcp log] %@", error.localizedDescription);
    
    [UINavigationController aspect_hookSelector:@selector(popToRootViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        UINavigationController *nav = aspectInfo.instance;
        NSArray *arguments          = aspectInfo.arguments;
        [nav aop_popToRootViewControllerAnimated:[arguments[0] boolValue]];
    } error:&error];
    
    if (error) NSLog(@"[zcp log] %@", error.localizedDescription);
}

// ----------------------------------------------------------------------
#pragma mark - aop
// ----------------------------------------------------------------------

- (void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topViewController = self.topViewController;
    if (!topViewController) {
        return;
    }
    if ([topViewController conformsToProtocol:@protocol(ZCPNavigatorProtocol)] &&
        [viewController conformsToProtocol:@protocol(ZCPNavigatorProtocol)]) {
        UIViewController<ZCPNavigatorProtocol> *topvc = (UIViewController<ZCPNavigatorProtocol> *)topViewController;
        UIViewController<ZCPNavigatorProtocol> *vc    = (UIViewController<ZCPNavigatorProtocol> *)viewController;
        topvc.latterViewController  = vc;
        vc.formerViewController     = topvc;
        vc.viewJumpModel            = ZCPViewNavJumpMode;
    }
}

- (void)aop_popViewControllerAnimated:(BOOL)animated {
    UIViewController *topViewController = self.topViewController;
    if (!topViewController) {
        return;
    }
    if ([topViewController conformsToProtocol:@protocol(ZCPNavigatorProtocol)]) {
        UIViewController<ZCPNavigatorProtocol> *topVC = (UIViewController<ZCPNavigatorProtocol> *)topViewController;
        topVC.formerViewController.latterViewController = nil;
    }
}

- (void)aop_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController<ZCPNavigatorProtocol> *vc = (UIViewController<ZCPNavigatorProtocol> *)viewController;
    vc.latterViewController = nil;
}

- (void)aop_popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController<ZCPNavigatorProtocol> *vc = (UIViewController<ZCPNavigatorProtocol> *)[self.viewControllers firstObject];
    vc.latterViewController = nil;
}

// ----------------------------------------------------------------------
#pragma mark - getters and setter
// ----------------------------------------------------------------------

- (ZCPBaseNavigator *)navigator {
    id object = objc_getAssociatedObject(self, "kZCPNavigationController_navigator");
    return object;
}

- (void)setNavigator:(ZCPBaseNavigator *)navigator {
    objc_setAssociatedObject(self, "kZCPNavigationController_navigator", navigator, OBJC_ASSOCIATION_ASSIGN);
}

@end
