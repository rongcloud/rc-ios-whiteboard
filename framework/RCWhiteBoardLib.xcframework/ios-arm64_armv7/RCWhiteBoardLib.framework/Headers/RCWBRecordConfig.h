//
//  RCWBRecordConfig.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCWBRecordConfig : NSObject

/// AppKey
@property (nonatomic, copy) NSString *appKey;

/// 用户 token
@property (nonatomic, copy) NSString *token;

/// 白板 Id
@property (nonatomic, copy) NSString *roomId;

/// 用户 Id
@property (nonatomic, copy) NSString *userId;

/// 用户名称
@property (nonatomic, copy) NSString *userName;

/// 白板地址（Server 录像列表中对应录像的地址，SDK 内部会根据该地址获取到真正的播放地址并 load 到 RCWebView 上）
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
