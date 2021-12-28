//
//  RCWBVideoListCell.h
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/29.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCWBVideoModel;
@interface RCWBVideoListCell : UITableViewCell

@property (nonatomic, strong) RCWBVideoModel *model;

@end

NS_ASSUME_NONNULL_END
