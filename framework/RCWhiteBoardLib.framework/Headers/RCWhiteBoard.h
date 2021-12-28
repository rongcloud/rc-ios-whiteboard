//
//  RCWhiteBoard.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/7/23.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCWBWebView.h"
#import "RCWBProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class RCWBRoomConfig;
@class RCWBRecordConfig;

/// 成功通用回调
typedef void (^WBSuccessBlock)(void);
/// 失败通用回调
typedef void (^WBErrorBlock)(RCWBErrorCode code, NSString * desc);

// 一个白板实例只能加入一个房间
@interface RCWhiteBoard : NSObject

/// 初始化 RCWhiteBoard
/// @param webView webView
- (instancetype)initWithWebView:(RCWBWebView *)webView;

/// 加入白板
/// @param config 加入白板需要的参数
/// @param successBlock 成功回调
/// @param errorBlock 失败回调
- (void)joinWithConfig:(RCWBRoomConfig *)config success:(WBSuccessBlock)successBlock error:(WBErrorBlock)errorBlock;

/// 退出白板
- (void)quitWhiteBoard:(WBSuccessBlock)successBlock error:(WBErrorBlock)errorBlock;

/// 进入录像播放
/// @param config 录像播放需要的参数
/// @param successBlock 成功回调
/// @param errorBlock 失败回调
- (void)playWithConfig:(RCWBRecordConfig *)config success:(WBSuccessBlock)successBlock error:(WBErrorBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
