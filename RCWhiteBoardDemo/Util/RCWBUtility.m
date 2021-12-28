//
//  RCWBUtility.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/2.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBUtility.h"

@implementation RCWBUtility

+ (NSString *)recordedTimeString:(NSString *)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue] / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+ (NSString *)getDurationString:(int)duration {
    NSString *hour = [NSString stringWithFormat:@"%02d", duration / 3600];
    NSString *minute = [NSString stringWithFormat:@"%02d", (duration % 3600) / 60];
    NSString *second = [NSString stringWithFormat:@"%02d", duration % 60];
    NSString *string = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    return string;
}

@end
