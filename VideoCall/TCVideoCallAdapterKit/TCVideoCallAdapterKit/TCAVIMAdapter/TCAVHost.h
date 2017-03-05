//
//  TCAVHost.h
//  TCQAVIMAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCAVIMCalledStatus) {
    // 添加电话场景的命令字
    TCAVIM_Call_Dialing,       // 正在呼叫
    TCAVIM_Call_Connected,     // 连接进行通话
    TCAVIM_Call_LineBusy,      // 电话占线
    TCAVIM_Call_Disconnected,  // 挂断
    TCAVIM_Call_NoAnswer      // 无人接听
};

typedef NS_ENUM(NSInteger, TCAVIMRoomStatus)
{
    AVIMCMD_EnterLive,          // 有人加入房间
    AVIMCMD_ExitLive,           // 有人离开房间
    AVIMCMD_Praise,             // 主播离开了房间（其他用户也会退出）
};

typedef NS_ENUM(NSInteger, TCAVCtrlState) {
    
    // 以下事件为AVAdapter内部处理的通用事件
    TCAVCtrlState_EnterLive,          // 有人加入房间
    TCAVCtrlState_ExitLive,           // 有人离开房间
    TCAVCtrlState_Praise,             // 主播离开了房间（其他用户也会退出）

    AVIMCMD_Call_EnableMic,     // 有人打开mic
    AVIMCMD_Call_DisableMic,    // 有人关闭Mic
    AVIMCMD_Call_EnableCamera,  // 有人打开Camera
    AVIMCMD_Call_DisableCamera, // 有人关闭Camera
};

@class TCAVIMUserEntity;

@interface TCAVHost : NSObject

// 聊天室Id
@property (nonatomic, copy) NSString *liveIMChatRoomId;

// 当前聊天室主播信息
@property (nonatomic, copy) TCAVIMUserEntity *liveAVIMModel;

@end
