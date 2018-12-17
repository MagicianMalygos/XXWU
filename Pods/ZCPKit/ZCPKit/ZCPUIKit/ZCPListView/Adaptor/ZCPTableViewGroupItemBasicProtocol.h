//
//  ZCPTableViewGroupItemBasicProtocol.h
//  Pods
//
//  Created by 朱超鹏 on 2018/7/30.
//

#import <UIKit/UIKit.h>
#import "ZCPTableViewCellItemBasicProtocol.h"
@protocol ZCPSectionalFringeProtocol;

// ----------------------------------------------------------------------
#pragma mark - section model适配协议
// ----------------------------------------------------------------------
@protocol ZCPTableViewGroupItemBasicProtocol <NSObject>

/// section 的cell 显示所需数据数组
@property (nonatomic, strong) NSMutableArray <id<ZCPTableViewCellItemBasicProtocol>> *sectionCellItems;
/// section 头部需要的数据
@property (nonatomic, assign) id                                sectionHeaderData;
/// section 头部的class 必须是UIView 的子类，否则头部返回为空
@property (nonatomic, assign) Class<ZCPSectionalFringeProtocol> sectionHeaderClass;
/// section 的尾部需要的数据
@property (nonatomic, assign) id                                sectionFooterData;
/// section 脚部的class 必须是UIView 的子类，否则头部返回为空
@property (nonatomic, assign) Class<ZCPSectionalFringeProtocol> sectionFooterClass;

@end

@protocol ZCPSectionalFringeProtocol <NSObject>

/**
 根据指定的数据源来设置section 的高度
 
 @param object 数据源
 @return 高度
 */
+ (CGFloat)sectionFringeHeightForObject:(id)object;

/**
 根据指定的数据源来配置section 头或者section 尾
 
 @param object 数据源
 */
- (void)configSectionFringeWithObject:(id)object;

@end
