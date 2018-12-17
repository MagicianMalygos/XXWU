//
//  ZCPButtonCell.m
//  Apartment
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 zcp. All rights reserved.
//

#import "ZCPButtonCell.h"

@implementation ZCPButtonCell

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize button      = _button;
@synthesize delegate    = _delegate;

// ----------------------------------------------------------------------
#pragma mark - setup
// ----------------------------------------------------------------------
- (void)setupContentView {
    [super setupContentView];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
}

- (void)setObject:(id<ZCPTableViewCellItemBasicProtocol>)object {
    if (object && [object isKindOfClass:[ZCPButtonCellItem class]]) {
        [super setObject:object];
        
        ZCPButtonCellItem *item = (ZCPButtonCellItem *)self.object;
        
        self.delegate   = item.delegate;
        self.button.tag = item.tag;
        
        // 标题
        [self.button setTitle:item.buttonTitle forState:UIControlStateNormal];
        
        // 背景颜色
        if (item.buttonBackgroundColor) {
            self.button.backgroundColor = item.buttonBackgroundColor;
        }
        // 背景图片
        if (item.buttonBackgroundImageNormal) {
            [self.button setBackgroundImage:item.buttonBackgroundImageNormal forState:UIControlStateNormal];
        }
        if (item.buttonBackgroundImageHighlighted) {
            [self.button setBackgroundImage:item.buttonBackgroundImageHighlighted forState:UIControlStateHighlighted];
        }
        if (item.buttonBackgroundImageDisabled) {
            [self.button setBackgroundImage:item.buttonBackgroundImageDisabled forState:UIControlStateDisabled];
        }
        // 标题颜色
        if (item.buttonTitleColorNormal) {
            [self.button setTitleColor:item.buttonTitleColorNormal forState:UIControlStateNormal];
        }
        if (item.buttonTitleColorHighlighted) {
            [self.button setTitleColor:item.buttonTitleColorHighlighted forState:UIControlStateHighlighted];
        }
        // 标题字体
        if (item.buttonTitleFont) {
            [self.button.titleLabel setFont:item.buttonTitleFont];
        }
        // 按钮初始状态
        if (item.state == ZCPButtonInitStateDisabled) {
            self.button.enabled = NO;
        }
        else if(item.state == ZCPButtonInitStateNormal) {
            self.button.enabled = YES;
        }
        // 配置块
        if (item.buttonConfigBlock) {
            item.buttonConfigBlock(self.button);
        }
    }
}

// ----------------------------------------------------------------------
#pragma mark - layout
// ----------------------------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _button.frame = CGRectMake(15, 0, self.width - 15 * 2, self.height);
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 5.0f;
}

// ----------------------------------------------------------------------
#pragma mark - Action Handler
// ----------------------------------------------------------------------
- (void)buttonClicked:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonCell:buttonClicked:)]) {
        [self.delegate buttonCell:self buttonClicked:button];
    }
}

@end


@implementation ZCPButtonCellItem

// ----------------------------------------------------------------------
#pragma mark - synthesize
// ----------------------------------------------------------------------
@synthesize buttonTitle                         = _buttonTitle;
@synthesize buttonTitleColorNormal              = _buttonTitleColorNormal;
@synthesize buttonTitleColorHighlighted         = _buttonTitleColorHighlighted;
@synthesize buttonTitleFont                     = _buttonTitleFont;
@synthesize buttonBackgroundColor               = _buttonBackgroundColor;
@synthesize buttonBackgroundImageNormal         = _buttonBackgroundImageNormal;
@synthesize buttonBackgroundImageHighlighted    = _buttonBackgroundImageHighlighted;
@synthesize buttonBackgroundImageDisabled       = _buttonBackgroundImageDisabled;
@synthesize tag                                 = _tag;
@synthesize state                               = _state;
@synthesize delegate                            = _delegate;
@synthesize buttonConfigBlock                   = _buttonConfigBlock;

// ----------------------------------------------------------------------
#pragma mark - instancetype
// ----------------------------------------------------------------------
- (instancetype)init {
    if (self = [super init]) {
        self.cellClass                      = [ZCPButtonCell class];
        self.cellHeight                     = @45.0f;
        self.cellType                       = [ZCPButtonCell cellIdentifier];
        self.state                          = ZCPButtonInitStateNormal;
        self.buttonTitleFont                = [UIFont systemFontOfSize:15.0f];
        self.buttonTitleColorHighlighted    = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:239.0/255 alpha:0.5];
    }
    return self;
}
- (instancetype)initWithDefault {
    if (self = [super initWithDefault]) {
        self.cellClass                      = [ZCPButtonCell class];
        self.cellHeight                     = @45.0f;
        self.cellType                       = [ZCPButtonCell cellIdentifier];
        self.state                          = ZCPButtonInitStateNormal;
        self.buttonBackgroundColor          = [UIColor colorFromHexRGB:@"ff8447"];
        self.buttonTitleColorNormal         = [UIColor blackColor];
        self.buttonTitleFont                = [UIFont systemFontOfSize:15.0f];
        self.buttonTitleColorHighlighted    = [UIColor colorWithRed:236.0/255 green:237.0/255 blue:239.0/255 alpha:0.5];
    }
    return self;
}

@end
