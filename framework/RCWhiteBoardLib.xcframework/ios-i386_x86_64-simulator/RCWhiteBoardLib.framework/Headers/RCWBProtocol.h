//
//  RCWBProtocol.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/7/23.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCWBStatusDefine.h"

@class RCWBException;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 房间状态相关
@protocol RCWBRoomStatusProtocol <NSObject>

/// 房间退出
- (void)onWBRoomQuit;

@optional
/// 房间异常
/// @param exception 异常对象
- (void)onWBRoomException:(RCWBException *)exception;

/// 截图结束
/// @param image 图片
/// @discussion 截图不会存服务器，App 层需要时可在此方法中保存至本地
- (void)onWBCaptureEnd:(UIImage *)image;

@end

#pragma mark - 权限相关
@protocol RCWBPermissionProtocol <NSObject>

/// 当前用户权限变化
/// @param permissionType 权限
- (void)onWBPermissionChange:(RCWBPermissionType)permissionType;

@end

#pragma mark - 录制相关
@protocol RCWBRecordProtocol <NSObject>

/// 视频录制开始
- (void)onWBRecordStart;

/// 视频录制结束
/// @param url url
- (void)onWBRecordEnd:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
