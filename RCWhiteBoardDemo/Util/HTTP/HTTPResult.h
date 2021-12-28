//
//  RCEHTTPResult.h
//  SealMeeting
//
//  Created by LiFei on 2019/2/25.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ErrorCode.h"

@interface HTTPResult : NSObject

@property (nonatomic, assign) NSInteger code;
@property(nonatomic, assign) NSInteger httpCode;
@property(nonatomic, copy)   NSString *message;
@property(nonatomic, strong) id content;

@end
