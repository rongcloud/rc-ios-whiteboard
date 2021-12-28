//
//  RCWBStatusDefine.h
//  RCWhiteBoardLib
//
//  Created by 孙浩 on 2021/8/5.
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RCWBRoleType) {
    /// 演示者
    RCWBRoleType_PRESENTER = 0,

    /// 观看者
    RCWBRoleType_VIEWER = 1,
};

typedef NS_ENUM(NSUInteger, RCWBPermissionType) {
    
    /// 只读权限
    RCWBPermissionType_READONLY = 0,

    /// 可操作权限
    RCWBPermissionType_WRITABLE = 1,
};

typedef NS_ENUM(NSUInteger, RCWBErrorCode) {
    
    /// SDK 内接口响应未知错误
    RC_WB_UNKNOWN = 1,
    
    /// SDK 内接口请求参数错误
    RC_WB_REQUEST_PARAMETER_ERROR = 100001,
    
    /// AppKey 错误
    RC_WB_APP_KEY_ERROR = 100007,
    
    /// Token 为空
    RC_WB_APP_TOKEN_NOT_EMPTY = 100008,
    
    /// AppKey 为空
    RC_WB_APP_KEY_NOT_EMPTY = 100009,
    
    /// Token 非法
    /// @discussion 请检查您使用的 AppKey 与 Token 是否正确，是否匹配。
    RC_WB_APP_TOKEN_ILLEGAL = 100010,
    
    /// 白板服务未开通
    RC_WB_WHITEBOARD_SERVICE_NOT_ENABLED = 100011,
    
    /// 白板文件服务异常
    RC_WB_RESOURCE_SERVER_NOT_READY = 100017,
    
    /// 强制下线
    RC_WB_FORCE_LOGIN = 200001,
    
    /// ping 超时
    RC_WB_NO_HEARTBEAT = 200002,
    
    /// 房间人数已满
    RC_WB_WHITEBOARD_ROOM_IS_FULL = 200003,
    
    /// 房间已销毁
    RC_WB_WHITEBOARD_ROOM_IS_CLOSED = 200006,
    
    /// 房间唯一标识（令牌）校验失败
    RC_WB_WHITEBOARD_ROOM_NOT_ALLOW = 200007,
    
    /// 当次操作数据量过大
    RC_WB_OPERATION_DATA_IS_MUCH = 200008,
    
    /// 房间不存在
    RC_WB_WHITEBOARD_ROOM_NOT_EXIST = 200010,
    
    /// 房间已移除
    RC_WB_WHITEBOARD_ROOM_REMOVED = 200011,
    
    /// 房间已退出
    RC_WB_WHITEBOARD_ROOM_QUITTED= 200013,
    
    /// SDK 没有初始化
    /// @discussion 在使用 SDK 任何功能之前，必须先 Init。
    RC_WB_CLIENT_NOT_INIT = 300001,
    
    /// 开发者接口调用时传入的参数错误
    /// @discussion 请检查接口调用时传入的参数类型和值。
    RC_WB_INVALID_PARAMETER = 300002,
    
    /// 导航 HTTP 请求失败
    RC_WB_NAVI_HTTP_ERROR = 300003,
    
    /// 导航 HTTP 返回数据格式错误
    RC_WB_NODE_NOT_FOUND = 300004,
    
    /// 加入白板请求失败
    RC_WB_JOIN_ROOM_HTTP_FAILED = 300005,
    
    /// 加入白板操作失败
    RC_WB_JOIN_ROOM_FAILED = 300006,
    
    /// 播放录像请求失败
    RC_WB_PLAY_VIDEO_HTTP_FAILED = 300007,
    
    /// 播放白板录像操作失败
    RC_WB_PLAY_VIDEO_FAILED = 300008,
    
    /// 退出白板请求失败
    RC_WB_QUIT_ROOM_HTTP_FAILED = 300009,
    
    /// 退出房间操作失败
    /// @discussion 必须先加入白板再执行退出操作,请检查您的业务调用
    RC_WB_QUIT_ROOM_FAILED = 300010,
};
