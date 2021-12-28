//
//  RCWBVideoModel.h
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/7/30.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCWBVideoModel : NSObject

@property (nonatomic, copy) NSString *hubId;

@property (nonatomic, copy) NSString *hubName;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *recordedTime;

@property (nonatomic, copy) NSString *serverId;

@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) int duration;


@end

NS_ASSUME_NONNULL_END
