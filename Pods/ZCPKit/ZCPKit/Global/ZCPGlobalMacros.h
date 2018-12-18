//
//  ZCPGlobalMacros.h
//  ZCPKit
//
//  Created by zhuchaopeng on 16/9/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#ifndef ZCPGlobalMacros_h
#define ZCPGlobalMacros_h

#pragma mark - - - - - - - - - - - system - - - - - - - - - -

// 当前系统版本号
#define SYSTEM_VERSION                  [[UIDevice currentDevice] systemVersion].floatValue
// 当前软件版本号
#define APP_VERSION                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

// 判断系统版本是否为iOS 8及以上
#define iOS8Upper                       @available(iOS 8.0, *)
// 判断系统版本是否为iOS 9及以上
#define iOS9Upper                       @available(iOS 9.0, *)
// 判断系统版本是否为iOS 10及以上
#define iOS10Upper                      @available(iOS 10.0, *)
// 判断系统版本是否为iOS 11及以上
#define iOS11Upper                      @available(iOS 11.0, *)
// 判断系统版本是否为iOS 12及以上
#define iOS12Upper                      @available(iOS 12.0, *)

// 判断是不是iPhone
#define iPhone                          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是不是iPhone plus
#define iPhonePlus                      (iPhone && [[UIScreen mainScreen] scale] == 3.0)
// 设备是否ipad
#define iPad                            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// 判断是不是iPhone 4/4s     的3.5寸屏幕
#define iPhone4                         (iPhone && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是不是iPhone 5/5c/5s  的4.0寸屏幕
#define iPhone5                         (iPhone && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是不是iPhone 6        的4.7寸屏幕
#define iPhone6                         (iPhone && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1344), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是不是iPhone 6 plus   的5.5寸屏幕
#define iPhone6Plus                     (iPhone && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否是高清屏
#define Retina                          ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))

// 设备是否支持打开相机/应用是否允许打开相机
#define PHOTO_LIBRARY_AVAILABLE         [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
// 设备是否支持打开相册/应用是否允许打开相册
#define CAMERA_AVAILABLE                [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]


#pragma mark - - - - - - - - - - - frame - - - - - - - - - -

// 屏幕高度
#define SCREENHEIGHT                    [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREENWIDTH                     [[UIScreen mainScreen] bounds].size.width
// 状态栏高度
#define Height_StatusBar                (iPhoneX?44:20)
// 导航栏高度
#define Height_NavigationBar            44
// TabBar高度
#define Height_TabBar                   (iPhoneX?83:49)
// 默认水平边距
#define MARGIN_HORIZONTAL               16


#pragma mark - - - - - - - - - - - util - - - - - - - - - -

// 时间性能测量用，单位为微妙
// 结束时间除以CLOCKS_PER_SEC得到耗时秒数
#define START_COUNT_TIME(start)         clock_t start = clock()
#define END_COUNT_TIME(start)           (clock() - start)

#define START_COUNT_TIME2(start)        CFTimeInterval start = CFAbsoluteTimeGetCurrent()
#define END_COUNT_TIME2(start)          ((CFAbsoluteTimeGetCurrent() - start) * 1000000)

#define START_COUNT_TIME3(start)        NSTimeInterval start = [[NSDate date] timeIntervalSince1970]
#define END_COUNT_TIME3(start)          ([[NSDate date] timeIntervalSince1970] - start) * 1000000)

#define START_COUNT_TIME4(start)        CFTimeInterval start = CACurrentMediaTime()
#define END_COUNT_TIME4(start)          (CACurrentMediaTime() - start) * 1000000)

// 一像素对应数值
// 设置宽(高)时，x(y)值需要减 OnePixelOffset
#define OnePixel                        (1 / [UIScreen mainScreen].scale)
#define OnePixelOffset                  ((1 / [UIScreen mainScreen].scale) / 2)

// 控制台打印
// 非DEBUG环境下不打印
#ifdef DEBUG
#define DEBUGPF(xx, ...)                NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define ZCPLog(FORMAT, ...)             fprintf(stderr,"%s:%d\n%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DEBUGPF(xx, ...)                ((void)0)
#define ZCPLog(xx, ...)                 ((void)0)
#endif

// Block循环引用
#define weakify(obj) autoreleasepool{} __weak typeof(obj) weak ## obj   = obj;
#define strongify(obj) autoreleasepool{} __strong typeof(obj) obj = weak ## obj;

// 从hex string获得uicolor
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                         blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// RGB色值
#define RGB(r,g,b,a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]


// 忽略PerformSelectorleak警告宏
/*
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    Stuff;
    #pragma clang diagnostic pop
*/
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - - - - - - - - - - - random - - - - - - - - - -

// 生成a-b范围内的随机整数
#define RANDOM(a, b)                    (((NSInteger)arc4random() % ((b) - (a) + 1)) + a)
// 生成a~b范围内的随机浮点数（该宏存在缺陷，当a或b的值乘以 RANDOM_PRECISION 之后如果超出NSInteger的范围，则会出现异常）
#define RANDOM_PRECISION                1000000
#define RANDOMF(a, b)                   (RANDOM((NSInteger)((a) * RANDOM_PRECISION), (NSInteger)((b) * RANDOM_PRECISION)) / (CGFloat)RANDOM_PRECISION)

// 生成随机颜色
#define RANDOM_COLOR                    [UIColor colorWithRed:RANDOMF(0, 1) green:RANDOMF(0, 1) blue:RANDOMF(0, 1) alpha:1.0f]

#endif /* ZCPGlobalMacros_h */
