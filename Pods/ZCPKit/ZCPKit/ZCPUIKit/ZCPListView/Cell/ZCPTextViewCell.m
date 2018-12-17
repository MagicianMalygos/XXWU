//
//  ZCPTextViewCell.m
//  Apartment
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPTextViewCell.h"

@implementation ZCPTextViewCell

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize textView    = _textView;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// ----------------------------------------------------------------------
#pragma mark - 返回cell高度
// ----------------------------------------------------------------------
+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    ZCPTextViewCellItem *item = (ZCPTextViewCellItem *)object;
    return [item.cellHeight floatValue];
}

// ----------------------------------------------------------------------
#pragma mark - Setup Cell
// ----------------------------------------------------------------------
- (void)setupContentView {
    
    self.textView                   = [[ZCPTextView alloc] init];
    self.textView.backgroundColor   = [UIColor whiteColor];
    self.textView.font              = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    [self.contentView addSubview:self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setObject:(ZCPDataModel<ZCPTableViewCellItemBasicProtocol> *)object {
    if (object && [object isKindOfClass:[ZCPTextViewCellItem class]]) {
        [super setObject:object];
        
        ZCPTextViewCellItem *item   = (ZCPTextViewCellItem *)self.object;
        // 设置属性
        self.textView.placeholder   = item.placeholder;
        self.textView.delegate      = item.delegate;
    }
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    ZCPTextViewCellItem *item = (ZCPTextViewCellItem *)self.object;
    [self.textView setHeight:[item.cellHeight floatValue]];
    self.textView.frame = CGRectMake(item.textEdgeInset.left
                                     , item.textEdgeInset.top
                                     , self.width - item.textEdgeInset.left - item.textEdgeInset.right
                                     , [item.cellHeight floatValue] - item.textEdgeInset.top - item.textEdgeInset.bottom);
}

// ----------------------------------------------------------------------
#pragma mark - Action Handler
// ----------------------------------------------------------------------
- (void)textDidChange:(NSNotification *)notification {
    ZCPTextViewCellItem *item = (ZCPTextViewCellItem *)self.object;
    item.textInputValue = self.textView.text;
}

@end

@implementation ZCPTextViewCellItem

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize placeholder     = _placeholder;
@synthesize textEdgeInset   = _textEdgeInset;
@synthesize textInputValue  = _textInputValue;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)init {
    if (self = [super init]) {
        self.cellClass      = [ZCPTextViewCell class];
        self.cellType       = [ZCPTextViewCell cellIdentifier];
    }
    return self;
}
- (instancetype)initWithDefault {
    if (self = [super initWithDefault]) {
        self.cellClass      = [ZCPTextViewCell class];
        self.cellType       = [ZCPTextViewCell cellIdentifier];
        self.cellHeight     = @80;
        self.textEdgeInset  = UIEdgeInsetsMake(4, 4, 4, 4);
    }
    return self;
}

@end
