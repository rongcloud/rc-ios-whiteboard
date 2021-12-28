//
//  RCWBWebView.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/7/23.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "DWKWebView.h"
#import "RCWBProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCWBWebView : DWKWebView

/// 房间状态变化的代理
@property (nonatomic, weak) id<RCWBRoomStatusProtocol> roomStatusDelegate;

/// 录制回调的代理
@property (nonatomic, weak) id<RCWBRecordProtocol> recordDelegate;

/// 权限变化的代理
@property (nonatomic, weak) id<RCWBPermissionProtocol> permisssionDelegate;

@end

NS_ASSUME_NONNULL_END
