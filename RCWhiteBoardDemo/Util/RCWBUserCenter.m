//
//  RCWBUserCenter.m
//  RCWhiteBoardDemo
//
//  Created by 孙浩 on 2021/8/2.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "RCWBUserCenter.h"

@implementation RCWBUserCenter
@synthesize nickName = _nickName;
@synthesize phoneNumber = _phoneNumber;
@synthesize userId = _userId;
@synthesize token = _token;

+ (instancetype)standardUserCenter {
    
    static RCWBUserCenter *userCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (userCenter == nil) {
            userCenter = [[RCWBUserCenter alloc] init];
        }
    });
    return userCenter;
}

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    [[NSUserDefaults standardUserDefaults] setValue:nickName forKey:@"RC-nickName"];
}

- (NSString *)nickName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RC-nickName"];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    [[NSUserDefaults standardUserDefaults] setValue:phoneNumber forKey:@"RC-PhoneNumber"];
}

- (NSString *)phoneNumber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RC-PhoneNumber"];
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"RC-userId"];
}

- (NSString *)userId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RC-userId"];
}


- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"RC-Token"];
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RC-Token"];
}

@end
