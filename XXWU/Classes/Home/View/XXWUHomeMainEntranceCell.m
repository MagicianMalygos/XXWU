//
//  XXWUHomeMainEntranceCell.m
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUHomeMainEntranceCell.h"
#import "XXWUHomeMainEntranceView.h"

@implementation XXWUHomeMainEntranceCell

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.rightView];
    [self.leftView addTarget:self action:@selector(clickLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.rightView addTarget:self action:@selector(clickRightView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(16, 16, (self.width - 42)/2, 90);
    self.rightView.frame = CGRectMake(self.leftView.right + 10, 16, (self.width - 42)/2, 90);
}

#pragma mark - event response

- (void)clickLeftView {
    XXWUHomeMainEntranceCellItem *item = (XXWUHomeMainEntranceCellItem *)self.object;
    if (item.eventHandler) {
        item.eventHandler(YES);
    }
}

- (void)clickRightView {
    XXWUHomeMainEntranceCellItem *item = (XXWUHomeMainEntranceCellItem *)self.object;
    if (item.eventHandler) {
        item.eventHandler(NO);
    }
}

#pragma mark - update data

- (void)setObject:(XXWUHomeMainEntranceCellItem *)object {
    [super setObject:object];
    
    // left
    self.leftView.iconLabel.text = object.leftIcon;
    self.leftView.nameLabel.text = object.leftTitle;
    self.leftView.backgroundColor = object.leftBackgroundColor;
    
    // right
    if (!object.rightIcon && !object.rightTitle) {
        self.rightView.hidden = YES;
    } else {
        self.rightView.hidden = NO;
        self.rightView.iconLabel.text = object.rightIcon;
        self.rightView.nameLabel.text = object.rightTitle;
        self.rightView.backgroundColor = object.rightBackgroundColor;
    }
}


#pragma mark - getters and setters

- (XXWUHomeMainEntranceView *)leftView {
    if (!_leftView) {
        _leftView = [[XXWUHomeMainEntranceView alloc] init];
    }
    return _leftView;
}

- (XXWUHomeMainEntranceView *)rightView {
    if (!_rightView) {
        _rightView = [[XXWUHomeMainEntranceView alloc] init];
    }
    return _rightView;
}

@end

@implementation XXWUHomeMainEntranceCellItem

- (instancetype)initWithDefault {
    if (self = [super initWithDefault]) {
        self.cellClass = [XXWUHomeMainEntranceCell class];
        self.cellHeight = @(90+16);
    }
    return self;
}

@end
