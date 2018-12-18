//
//  ZCPPickerView.m
//  Apartment
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPPickerView.h"
#import "ZCPGlobal.h"

@interface ZCPPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation ZCPPickerView

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize pickerView          = _pickerView;
@synthesize optionsArr          = _optionsArr;
@synthesize selectedValues      = _selectedValues;
@synthesize bindingTextField    = _bindingTextField;

// ----------------------------------------------------------------------
#pragma mark - init
// ----------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加PickerView
        self.pickerView = [[UIPickerView alloc] initWithFrame:frame];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
    }
    return self;
}

// ----------------------------------------------------------------------
#pragma mark - getter / setter
// ----------------------------------------------------------------------
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.selectedValues = [NSMutableArray array];  // 重置数组
    
    for (int i = 0; i < self.optionsArr.count; i++) {
        NSInteger row = [self.pickerView selectedRowInComponent:i];
        if (self.optionsArr[i] && [(NSArray *)self.optionsArr[i] count]) {
            [self.selectedValues addObject:self.optionsArr[i][row]];
        } else {
            [self.selectedValues addObject:@""];
        }
    }
    
    [self setBindingText];
}

// ----------------------------------------------------------------------
#pragma mark - UIPickerView Delegate & DataSource
// ----------------------------------------------------------------------
/**
 *  滚动视图的数目
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.optionsArr.count;
}
/**
 *  滚动视图中选项的数目
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.optionsArr objectAtIndex:component] count];
}
/**
 *  选项名
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.optionsArr objectAtIndex:component] objectAtIndex:row];
}

/**
 *  picker值发生改变
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *newValue = @"";
    if (self.optionsArr[component] && [(NSArray *)self.optionsArr[component] count]) {
        newValue = [[self.optionsArr objectAtIndex:component] objectAtIndex:row];
    }
    [self.selectedValues replaceObjectAtIndex:component withObject:newValue];
    
    [self setBindingText];
}

// ----------------------------------------------------------------------
#pragma mark - private method
// ----------------------------------------------------------------------
// 设置绑定文本输入框的内容
- (void)setBindingText {
    NSString *text = @"";
    for (int i = 0; i < self.selectedValues.count; i++) {
        text = [text stringByAppendingString:self.selectedValues[i]];
        if (i != self.selectedValues.count - 1) {
            text = [text stringByAppendingString:@" "];
        }
    }
    self.bindingTextField.text = text;
}

@end

/**
 *  获取自定义选择器
 */
ZCPPickerView *getPicker(NSArray *componentArray) {
    ZCPPickerView *pickerView = [[ZCPPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    
    NSMutableArray *tempComponentArray = [NSMutableArray array];
    for (NSArray *array in componentArray) {
        if (array && [array isKindOfClass:[NSArray class]]) {
            [tempComponentArray addObject:[array mutableCopy]];
        }
    }
    pickerView.optionsArr = tempComponentArray;
    return pickerView;
}
