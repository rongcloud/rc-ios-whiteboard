//
//  ErrorCode.h
//  SealMeeting
//
//  Created by Sin on 2019/3/13.
//  Copyright © 2019年 RongCloud. All rights reserved.
//

#ifndef ErrorCode_h
#define ErrorCode_h

typedef NS_ENUM(NSInteger, ErrorCode) {
    ErrorCodeHTTPFailure = 99,
    ErrorCodeSuccess = 200,
    //app
    ErrorCodeCodeFail = 1000,
    ErrorCodeCodeTimeout = 2000,
    ErrorCodeExceededLimit = 5000,
};

#endif /* ErrorCode_h */
