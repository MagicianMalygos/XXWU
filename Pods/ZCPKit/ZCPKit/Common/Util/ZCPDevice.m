//
//  ZCPDevice.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/1.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPDevice.h"
#import "ZCPOpenUDID.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AVFoundation/AVFoundation.h>
#import <AdSupport/AdSupport.h>

#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <net/if_dl.h>
#import <sys/utsname.h>

@implementation ZCPDevice

// ----------------------------------------------------------------------
#pragma mark - statistics
// ----------------------------------------------------------------------

/// 国家
+ (NSString *)countryString {
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale objectForKey:NSLocaleCountryCode];
    return country;
}

/// 语言
+ (NSString *)languageString {
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSArray *languages          = [defaults objectForKey:@"AppleLanguages"];
    NSString *language          = [languages objectAtIndex:0];
    return language;
}

/// 系统版本
+ (NSString *)osVersionString {
    NSString *version = [UIDevice currentDevice].systemVersion;
    return version;
}

/// 时区
+ (NSString *)timezoneString {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    return zone.name;
}

/// 分辨率
+ (NSString *)resolutionString {
    float width     = [UIScreen mainScreen].bounds.size.width;
    float height    = [UIScreen mainScreen].bounds.size.height;
    return [NSString stringWithFormat:@"%fx%f", width, height];
}

/// 运营商
+ (NSString *)carrierString {
    CTTelephonyNetworkInfo *info    = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier              = info.subscriberCellularProvider;
    // 获取MCC(移动国家码)
    NSString *mcc = [carrier mobileCountryCode];
    // 获取MNC(移动网络码)
    NSString *mnc = [carrier mobileNetworkCode];
    // 判断运营商
    if ([[mcc substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"460"]) {
        NSInteger MNC = [[mnc substringWithRange:NSMakeRange(0, 2)] intValue];
        switch (MNC) {
            case 00:
            case 02:
            case 07:
                return @"China Mobile";
            case 01:
            case 06:
                return @"China Unicom";
            case 03:
            case 05:
                return @"China Telecom";
            case 20:
                return @"China Tietong";
            default:
                break;
        }
    }
    return @"未知";
}

// ----------------------------------------------------------------------
#pragma mark - permission
// ----------------------------------------------------------------------

+ (BOOL)isCameraAvailable {
    NSArray* videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

+ (BOOL)hasAuthorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return authStatus != AVAuthorizationStatusDenied;
}

+ (BOOL)isQRCodeScanAvailable {
    // Device
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    NSError* error = nil;
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    // Output
    AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc] init];
    // Session
    AVCaptureSession* session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    NSArray* array = output.availableMetadataObjectTypes;
    for (NSString* objectType in array) {
        if ([objectType isEqualToString:AVMetadataObjectTypeQRCode]) {
            return YES;
        }
    }
    return NO;
}

// ----------------------------------------------------------------------
#pragma mark - baseinfo
// ----------------------------------------------------------------------

/**
 openudid
 */
+ (NSString *)getDeviceOpenUDID {
    NSString *openUDID = [ZCPOpenUDID value];
    return openUDID;
}

/**
 设备型号
 */
+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return device;
}

/**
 是否ipad
 */
+ (BOOL)isIpad {
    BOOL isIpad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    return isIpad;
}

/**
 是否是 iphone plus
 */
+ (BOOL)isIphonePlus {
    BOOL isIphonePlus = [[UIScreen mainScreen] scale] == 3.0;
    return isIphonePlus;
}

/**
 设备mac地址，iOS 7以后获取不到
 */
+ (NSString *)deviceMacAddressString {
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        free(msgBuffer);
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

/**
 应用广告标示
 */
+ (NSString *)appIdentfierForAdvert {
    NSString *ifa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return ifa;
}
+ (NSString *)appIdentfierForVendor {
    NSString *ifv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return ifv;
}

// ----------------------------------------------------------------------
#pragma mark - security
// ----------------------------------------------------------------------

/**
 判断App是否被破解
 */
+ (BOOL)isPirated {
    
    /*
     通过对比正版ipa文件与破解的ipa文件，发现破解后的主要区别有两点：
     1.SC_Info目录被移除，该目录包含两个文件：
     (1)appname.sinf为metadata文件
     (2)appname.supp为解密可执行文件的密钥
     2.iTunesMetadata.plist文件被移除，该文件用来记录app的基本信息，例如购买者的appleID，app购买时间、app支持的设备体系结构，app的版本、app标识符
     */
    BOOL isPirated                  = NO;
    
    NSString * bundlePath           = [[NSBundle mainBundle] bundlePath];
    
    // SC_Info
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/SC_Info",bundlePath]]) {
        isPirated                   = YES;
    }
    // iTunesMetadata.​plist
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/iTunesMetadata.​plist",bundlePath]]) {
        isPirated                   = YES;
    }
    
    return isPirated;
}

/**
 判断设备是否越狱
 */
+ (BOOL)isJailbroken {
    // 根据 apt和Cydia.app的path来判断
    BOOL isJailbroken       = NO;
    
    NSString * cydiaPath    = @"/Applications/Cydia.app";
    NSString * aptPath      = @"/private/var/lib/apt/";//Cydia各个源下载的package，里面是补丁和Cydia市场中的软件信息
    NSString * dylibPath    = @"/Library/MobileSubstrate/MobileSubstrate.dylib";//越狱后挂载的动态🔗库
    NSString * etcApt       = @"/etc/apt";//Cydia添加的源地址和信任的配置文件
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        isJailbroken        = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        isJailbroken        = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) {
        isJailbroken        = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:etcApt]) {
        isJailbroken        = YES;
    }
    
    return isJailbroken;
}

@end
