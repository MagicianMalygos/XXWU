//
//  ZCPViewController+Router.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/7/31.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPViewController+Router.h"

static NSString *kZCPViewController_routerHelper = @"kZCPViewController_routerHelper";

@implementation ZCPViewController (Router)

// ----------------------------------------------------------------------
#pragma mark - ZCPNavigatorProtocol
// ----------------------------------------------------------------------
- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
    }
    return self;
}

- (UIViewController<ZCPNavigatorProtocol> *)formerViewController {
    return self.routerHelper.formerViewController;
}

- (void)setFormerViewController:(UIViewController<ZCPNavigatorProtocol> *)formerViewController {
    self.routerHelper.formerViewController = formerViewController;
}

- (UIViewController<ZCPNavigatorProtocol> *)latterViewController {
    return self.routerHelper.latterViewController;
}

- (void)setLatterViewController:(UIViewController<ZCPNavigatorProtocol> *)latterViewController {
    self.routerHelper.latterViewController = latterViewController;
}

// ----------------------------------------------------------------------
#pragma mark - jump / back
// ----------------------------------------------------------------------
- (void)presentViewController:(UIViewController<ZCPNavigatorProtocol> *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    self.latterViewController                           = viewControllerToPresent;
    if ([viewControllerToPresent conformsToProtocol:@protocol(ZCPNavigatorProtocol)]) {
        viewControllerToPresent.formerViewController    = self;
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    self.formerViewController.latterViewController  = nil;
    [super dismissViewControllerAnimated:flag completion:completion];
}

// ----------------------------------------------------------------------
#pragma mark - getters and setters
// ----------------------------------------------------------------------

- (ZCPViewControllerRouterHelper *)routerHelper {
    id object = objc_getAssociatedObject(self, &kZCPViewController_routerHelper);
    if (!object) {
        object = [[ZCPViewControllerRouterHelper alloc] init];
        self.routerHelper = object;
    }
    return object;
}

- (void)setRouterHelper:(ZCPViewControllerRouterHelper *)routerHelper {
    objc_setAssociatedObject(self, &kZCPViewController_routerHelper, routerHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation ZCPViewControllerRouterHelper

@synthesize formerViewController    = _formerViewController;
@synthesize latterViewController    = _latterViewController;

// just fix warning
- (instancetype)initWithQuery:(NSDictionary *)query {
    return nil;
}

@end
