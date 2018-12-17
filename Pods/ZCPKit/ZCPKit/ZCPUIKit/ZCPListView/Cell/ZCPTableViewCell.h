//
//  ZCPTableViewCell.h
//  Apartment
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewCellDataModel.h"
#import "ZCPCategory.h"
#import "ZCPGlobal.h"

// 配置块声明
typedef void(^ZCPButtonConfigBlock)(UIButton *button);  // 按钮配置块
typedef void(^ZCPTextFieldConfigBlock)(UITextField *);  // textField配置块
typedef void(^ZCPImageViewConfigBlock)(UIImageView *);  // imageView配置块

// ----------------------------------------------------------------------
#pragma mark - Cell基类
// ----------------------------------------------------------------------
@interface ZCPTableViewCell : UITableViewCell

/// cell model
@property (nonatomic, strong) id<ZCPTableViewCellItemBasicProtocol> object;

/**
 返回根据cell model得出的cell高度
 
 @param tableView cell创建后所属的tableview
 @param object cell model
 @return cell高度
 */
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<ZCPTableViewCellItemBasicProtocol>)object;

/**
 返回cell的重用标识
 */
+ (NSString *)cellIdentifier;

/**
 初始化cell内容
 */
- (void)setupContentView;

@end
