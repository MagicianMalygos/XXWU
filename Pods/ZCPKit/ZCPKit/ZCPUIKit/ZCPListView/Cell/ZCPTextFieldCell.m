//
//  ZCPTextFieldCell.m
//  Apartment
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTextFieldCell.h"

@implementation ZCPTextFieldCell

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize textField   = _textField;

- (void)dealloc {
    // 移除通知和观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.textField removeObserver:self forKeyPath:@"text"];
}

// ----------------------------------------------------------------------
#pragma mark - 返回cell高度
// ----------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    ZCPTextFieldCellItem *item = (ZCPTextFieldCellItem *)object;
    return [item.cellHeight floatValue];
}

// ----------------------------------------------------------------------
#pragma mark - Setup Cell
// ----------------------------------------------------------------------
- (void)setupContentView {
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    
    // 监听键盘输入造成的text改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // 监听setText造成的text改变
    [self.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.contentView addSubview:self.textField];
}
- (void)setObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    if ([object isKindOfClass:[ZCPTextFieldCellItem class]]) {
        [super setObject:object];
        
        ZCPTextFieldCellItem *item = (ZCPTextFieldCellItem *)self.object;
        // 设置属性
        self.textField.text = item.textInputValue;
        if (item.textFieldConfigBlock) {
            item.textFieldConfigBlock(self.textField);
        }
    }
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    ZCPTextFieldCellItem *item  = (ZCPTextFieldCellItem *)self.object;
    CGFloat cellHeight          = [item.cellHeight floatValue];
    
    self.textField.frame        = CGRectMake(4, 8, self.width - 4 * 2, cellHeight - 8 * 2);
}

// ----------------------------------------------------------------------
#pragma mark - Action Handler
// ----------------------------------------------------------------------
// 监听键盘输入造成的text改变
- (void)textDidChanged:(NSNotification *)notification {
    ZCPTextFieldCellItem *item  = (ZCPTextFieldCellItem *)self.object;
    item.textInputValue         = self.textField.text;
}
// 监听setText造成的text改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    ZCPTextFieldCellItem *item  = (ZCPTextFieldCellItem *)self.object;
    item.textInputValue         = [change valueForKey:@"new"];
}

@end

@implementation ZCPTextFieldCellItem

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize textInputValue          = _textInputValue;
@synthesize textFieldConfigBlock    = _textFieldConfigBlock;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)init {
    if (self = [super init]) {
        self.cellClass              = [ZCPTextFieldCell class];
        self.cellType               = [ZCPTextFieldCell cellIdentifier];
    }
    return self;
}
- (instancetype)initWithDefault {
    if (self = [super initWithDefault]) {
        self.cellClass              = [ZCPTextFieldCell class];
        self.cellType               = [ZCPTextFieldCell cellIdentifier];
        self.cellHeight             = @46;
    }
    return self;
}

@end

@implementation ZCPLabelTextFieldCell

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize label       = _label;

// ----------------------------------------------------------------------
#pragma mark - 返回cell高度
// ----------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    ZCPLabelTextFieldCellItem *item = (ZCPLabelTextFieldCellItem *)object;
    return [item.cellHeight floatValue];
}

// ----------------------------------------------------------------------
#pragma mark - Setup Cell
// ----------------------------------------------------------------------
- (void)setupContentView {
    [super setupContentView];
    
    self.label                      = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 0, 30)];
    self.label.numberOfLines        = 1;
    self.label.font                 = [UIFont boldSystemFontOfSize:15.0f];
    self.label.backgroundColor      = [UIColor clearColor];
    self.textField.backgroundColor  = [UIColor whiteColor];
    
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.textField];
}
- (void)setObject:(ZCPDataModel<ZCPTableViewCellItemBasicProtocol> *)object {
    if (object && [object isKindOfClass:[ZCPLabelTextFieldCellItem class]]) {
        [super setObject:object];
        
        ZCPLabelTextFieldCellItem *item = (ZCPLabelTextFieldCellItem *)object;
        
        // 设置label文字
        self.label.text = item.labelText;
        
        if (item.textFieldConfigBlock) {
            item.textFieldConfigBlock(self.textField);
        }
    }
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label sizeToFit];
    // 根据label宽度设置textField的frame
    self.textField.frame = CGRectMake(self.label.right + 8
                                      , 8
                                      , self.width - 8 * 2 - 8 - self.label.width
                                      , 30);
    // 设置label中心的y值
    self.label.center = CGPointMake(self.label.center.x, self.textField.center.y);
}

@end

@implementation ZCPLabelTextFieldCellItem

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize labelText   = _labelText;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)init {
    if (self = [super init]) {
        self.cellClass  = [ZCPLabelTextFieldCell class];
        self.cellType   = [ZCPLabelTextFieldCell cellIdentifier];
    }
    return self;
}
- (instancetype)initWithDefault {
    if (self = [super initWithDefault]) {
        self.cellClass  = [ZCPLabelTextFieldCell class];
        self.cellType   = [ZCPLabelTextFieldCell cellIdentifier];
        self.cellHeight = @46;
    }
    return self;
}
@end
