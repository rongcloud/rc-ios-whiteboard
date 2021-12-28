//
//  RCWBException.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCWBException : NSObject

/// 异常码
@property (nonatomic, assign) NSInteger code;

/// 错误描述
@property (nonatomic, copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
