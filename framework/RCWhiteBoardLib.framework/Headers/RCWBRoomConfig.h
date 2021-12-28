//
//  RCWBRoomConfig.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/7/23.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCWBStatusDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCWBRoomConfig : NSObject

/// AppKey
@property (nonatomic, copy) NSString *appKey;

/// 用户 token
@property (nonatomic, copy) NSString *token;

/// 白板 Id
@property (nonatomic, copy) NSString *roomId;

/// 用户 Id
@property (nonatomic, copy) NSString *userId;

/// 用户名称
@property (nonatomic, copy) NSString *userName;

/// 加入房间时的角色
@property (nonatomic, assign) RCWBRoleType roleType;

/// 白板存活时间，默认 1440 min（24 * 60）
@property (nonatomic, assign) int minutes;

@end

NS_ASSUME_NONNULL_END
