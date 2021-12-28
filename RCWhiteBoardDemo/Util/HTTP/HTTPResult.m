//
//  RCEHTTPResult.m
//  SealMeeting
//
//  Created by LiFei on 2019/2/25.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "HTTPResult.h"

@implementation HTTPResult

- (NSString *)description {
    return [NSString stringWithFormat:@"httpCode: %ld, code: %ld, message: %@, content: %@",
            (long)self.httpCode, (long)self.code, self.message, self.content];
}

@end
