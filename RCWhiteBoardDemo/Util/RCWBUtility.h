//
//  RCWBUtility.h
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/2.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCWBUtility : NSObject

+ (NSString *)recordedTimeString:(NSString *)timeInterval;

+ (NSString *)getDurationString:(int)duration;

@end

NS_ASSUME_NONNULL_END
