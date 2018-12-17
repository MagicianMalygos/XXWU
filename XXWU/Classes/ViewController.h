//
//  ViewController.h
//  XXWU
//
//  Created by 朱超鹏 on 2017/8/23.
//  Copyright © 2017年 zcp. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZCPGenerateURLDelegate;

// 生成url控制器
@interface ViewController : UIViewController

@property (nonatomic, copy) NSString *defaultUrl;
@property (nonatomic, weak) id<ZCPGenerateURLDelegate> delegate;

@end

@protocol ZCPGenerateURLDelegate <NSObject>

- (void)generateUrl:(NSString *)url;

@end
