//
//  ZCPTextFieldCell.h
//  Apartment
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTableViewWithLineCell.h"

// ----------------------------------------------------------------------
#pragma mark - 只有一个TextField的Cell
// ----------------------------------------------------------------------
@interface ZCPTextFieldCell : ZCPTableViewWithLineCell

@property (nonatomic, strong) UITextField *textField;           // 输入框

@end

@interface ZCPTextFieldCellItem : ZCPTableViewCellDataModel

@property (nonatomic, copy) NSString *textInputValue;                       // 文本框输入内容
@property (nonatomic, copy) ZCPTextFieldConfigBlock textFieldConfigBlock;   // 输入框配置块

@end


// ----------------------------------------------------------------------
#pragma mark - Label + TextField
// ----------------------------------------------------------------------
@interface ZCPLabelTextFieldCell : ZCPTextFieldCell

@property (nonatomic, strong) UILabel *label;

@end

@interface ZCPLabelTextFieldCellItem : ZCPTextFieldCellItem

@property (nonatomic, copy) NSString *labelText;

@end
