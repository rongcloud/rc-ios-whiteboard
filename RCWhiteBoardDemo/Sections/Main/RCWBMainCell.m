//
//  RCWBMainCell.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/29.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBMainCell.h"
#import "RCWBCommonDefine.h"
#import <Masonry/Masonry.h>

@interface RCWBMainCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RCWBMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setTitle:(NSString *)title image:(UIImage *)image {
    self.titleLabel.text = title;
    self.imgView.image = image;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.titleLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(31);
        make.height.width.offset(80);
        make.top.bottom.equalTo(self.bgView).inset(22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.imgView.mas_right).offset(16);
        make.height.offset(28);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HEXCOLOR(0xFAFAFA);
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];

    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.65];
        _titleLabel.font = [UIFont systemFontOfSize: 20];
    }
    return _titleLabel;
}

@end
