//
//  RCWBVideoListCell.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/29.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBVideoListCell.h"
#import <Masonry/Masonry.h>
#import "RCWBCommonDefine.h"
#import "RCWBVideoModel.h"
#import "RCWBUtility.h"

@interface RCWBVideoListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *roomIdLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *startTimeLabel;

@property (nonatomic, strong) UILabel *videoTimeLabel;

@end

@implementation RCWBVideoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setModel:(RCWBVideoModel *)model {
    _model = model;
    
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间号 %@", model.hubId];
    self.startTimeLabel.attributedText = [self getAttributedString:@"录制开始   " content:[RCWBUtility recordedTimeString:model.recordedTime]];
    self.videoTimeLabel.attributedText = [self getAttributedString:@"录制时长   " content:[RCWBUtility getDurationString:model.duration]];
}

#pragma mark - Private Method
- (void)setupView {
    
    self.contentView.backgroundColor = HEXCOLOR(0xEDEDED);
    
    [self.contentView addSubview:self.bgView];
    
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.roomIdLabel];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.startTimeLabel];
    [self.bgView addSubview:self.videoTimeLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(17);
        make.left.equalTo(self.bgView).offset(24);
        make.height.width.offset(20);
    }];
    
    [self.roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(8);
        make.right.equalTo(self.bgView).offset(-10);
        make.height.offset(24);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomIdLabel.mas_bottom).offset(9);
        make.left.equalTo(self.bgView).offset(24);
        make.right.equalTo(self.bgView).offset(-21);
        make.height.offset(1);
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(14);
        make.left.equalTo(self.imgView);
        make.right.equalTo(self.roomIdLabel);
        make.height.offset(15);
    }];
    
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTimeLabel.mas_bottom).offset(8);
        make.left.right.equalTo(self.startTimeLabel);
        make.height.offset(15);
        make.bottom.equalTo(self.bgView).offset(-14);
    }];
}

- (NSMutableAttributedString *)getAttributedString:(NSString *)title content:(NSString *)content {
    NSString *string = [NSString stringWithFormat:@"%@%@", title, content];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[attributedString.string rangeOfString:string]];
    NSRange range1 = [[attributedString string] rangeOfString:title];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.45] range:range1];
    NSRange range2 = [[attributedString string] rangeOfString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[HEXCOLOR(0x000000) colorWithAlphaComponent:0.85] range:range2];
    return attributedString;
}

#pragma mark - Setter && Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"list-room-icon"];
    }
    return _imgView;
}

- (UILabel *)roomIdLabel {
    if (!_roomIdLabel) {
        _roomIdLabel = [[UILabel alloc] init];
        _roomIdLabel.font = [UIFont systemFontOfSize:16];
        _roomIdLabel.textColor = HEXCOLOR(0x1E85FF);
    }
    return _roomIdLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xEDEDED);
    }
    return _lineView;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.font = [UIFont systemFontOfSize:14];
        _startTimeLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.45];
    }
    return _startTimeLabel;
}

- (UILabel *)videoTimeLabel {
    if (!_videoTimeLabel) {
        _videoTimeLabel = [[UILabel alloc] init];
        _videoTimeLabel.font = [UIFont systemFontOfSize:14];
        _videoTimeLabel.textColor = [HEXCOLOR(0x000000) colorWithAlphaComponent:0.45];
    }
    return _videoTimeLabel;
}

@end
