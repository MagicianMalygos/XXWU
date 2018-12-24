//
//  XXWUHomeMainEntranceView.m
//  XXWU
//
//  Created by zcp on 2018/12/24.
//  Copyright © 2018 zcp. All rights reserved.
//

#import "XXWUHomeMainEntranceView.h"

@implementation XXWUHomeMainEntranceView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.titleLabel.hidden = YES;
    self.imageView.hidden = YES;
    
    [self addSubview:self.iconLabel];
    [self addSubview:self.nameLabel];
    
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.height.mas_equalTo(26);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

#pragma mark - getters and setters

- (UILabel *)iconLabel {
    if (!_iconLabel) {
        _iconLabel = [[UILabel alloc] init];
        _iconLabel.font = [UIFont fontWithName:@"iconfont" size:25.0f];
        _iconLabel.textColor = [UIColor whiteColor];
    }
    return _iconLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

@end
