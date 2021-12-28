//
//  HTTPUtility.m
//  SealMeeting
//
//  Created by LiFei on 2019/2/25.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "HTTPUtility.h"
#import <AFNetworking/AFNetworking.h>
NSString *const BASE_URL = @"https://whiteboard-app-server.ronghub.com";

static AFHTTPSessionManager *manager;

@implementation HTTPUtility

+ (AFHTTPSessionManager *)sharedHTTPManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [AFHTTPSessionManager manager];
        manager.completionQueue = dispatch_queue_create("cn.rongcloud.seal.httpqueue", DISPATCH_QUEUE_SERIAL);
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", nil];
    });
    return manager;
}

+ (void)requestWithHTTPMethod:(HTTPMethod)method
                    URLString:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                     response:(void (^)(HTTPResult *))responseBlock {
    AFHTTPSessionManager *manager = [HTTPUtility sharedHTTPManager];
    NSString *url = [BASE_URL stringByAppendingString:URLString];
    NSString *cookie = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserCookies"];
    if (cookie && cookie.length > 0) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    switch (method) {
        case HTTPMethodGet: {
            NSString *rcToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"RC-Token"];
            if (rcToken.length > 0) {
                [manager.requestSerializer setValue:rcToken forHTTPHeaderField:@"RC-Token"];
            }
            
            [manager GET:url parameters:parameters headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseBlock) {
                    responseBlock([[self class] httpSuccessResult:task response:responseObject]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"GET url is %@, error is %@", URLString, error.localizedDescription);
                if (responseBlock) {
                    responseBlock([[self class] httpFailureResult:task error:error]);
                }
            }];
            break;
        }
            
        case HTTPMethodHead: {
            [manager HEAD:url parameters:parameters headers:@{} success:^(NSURLSessionDataTask * _Nonnull task) {
                if (responseBlock) {
                    responseBlock([[self class] httpSuccessResult:task response:nil]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"HEAD url is %@, error is %@", URLString, error.localizedDescription);
                if (responseBlock) {
                    responseBlock([[self class] httpFailureResult:task error:error]);
                }
            }];
            break;
        }
            
        case HTTPMethodPost: {
            [manager POST:url parameters:parameters headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self saveCookieIfHave:task];
                if (responseBlock) {
                    responseBlock([[self class] httpSuccessResult:task response:responseObject]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"POST url is %@, error is %@", URLString, error.localizedDescription);
                if (responseBlock) {
                    responseBlock([[self class] httpFailureResult:task error:error]);
                }
            }];
            break;
        }
            
        case HTTPMethodPut: {
            [manager PUT:url parameters:parameters headers:@{} success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                if (responseBlock) {
                    responseBlock([[self class] httpSuccessResult:task response:responseObject]);
                }
            }
                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSLog(@"PUT url is %@, error is %@", URLString, error.localizedDescription);
                if (responseBlock) {
                    responseBlock([[self class] httpFailureResult:task error:error]);
                }
            }];
            break;
        }
            
        case HTTPMethodDelete: {
            [manager DELETE:url parameters:parameters headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseBlock) {
                    responseBlock([[self class] httpSuccessResult:task response:responseObject]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"DELETE url is %@, error is %@", URLString, error.localizedDescription);
                if (responseBlock) {
                    responseBlock([[self class] httpFailureResult:task error:error]);
                }
            }];
            break;
        }
            
        default:
            break;
    }
}


+ (HTTPResult *)httpSuccessResult:(NSURLSessionDataTask *)task response:(id)responseObject {
    HTTPResult *result = [[HTTPResult alloc] init];
    result.httpCode = ((NSHTTPURLResponse *)task.response).statusCode;
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        result.code = [responseObject[@"code"] integerValue];
        result.content = responseObject;
    }
    NSLog(@"%@, {%@}", task.currentRequest.URL, responseObject);
    return result;	
}

+ (HTTPResult *)httpFailureResult:(NSURLSessionDataTask *)task error:(NSError *)error {
    HTTPResult *result = [[HTTPResult alloc] init];
    result.httpCode = ((NSHTTPURLResponse *)task.response).statusCode;
    if (error.localizedDescription) {
        result.message = error.localizedDescription;
    } else {
        result.message = @"request error";
    }
    NSLog(@"%@, {%@}", task.currentRequest.URL, result);
    return result;
}

+ (void)setAuthHeader:(NSString *)auth {
    [[HTTPUtility sharedHTTPManager].requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
}

+ (void)saveCookieIfHave:(NSURLSessionDataTask *)task {
    NSString *cookieString = [[(NSHTTPURLResponse *)task.response allHeaderFields] valueForKey:@"Set-Cookie"];
    NSMutableString *finalCookie = [NSMutableString new];
    NSArray *cookieStrings = [cookieString componentsSeparatedByString:@","];
    for (NSString *temp in cookieStrings) {
        NSArray *tempArr = [temp componentsSeparatedByString:@";"];
        [finalCookie appendString:[NSString stringWithFormat:@"%@;", tempArr[0]]];
    }
    if (finalCookie.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:finalCookie forKey:@"UserCookies"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[HTTPUtility sharedHTTPManager].requestSerializer setValue:finalCookie forHTTPHeaderField:@"Cookie"];
    }
}

@end
