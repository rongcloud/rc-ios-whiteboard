//
//  RCWBUserCenter.h
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/2.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RCWhiteBoardLib/RCWhiteBoardLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCWBUserCenter : NSObject

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong, nullable) RCWhiteBoard *wbClient;

+ (instancetype)standardUserCenter;

@end

NS_ASSUME_NONNULL_END
