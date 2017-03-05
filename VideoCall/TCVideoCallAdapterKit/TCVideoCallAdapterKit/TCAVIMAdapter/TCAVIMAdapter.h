//
//  TCAVIMAdapter.h
//  TCQAVIMAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCAVLivePreView;
@class TCAVIMUserEntity;
@class TCAVHost;
@protocol TCAVIMAdapterDelegate;

typedef void (^TCAVIMAdapterEnterRoomBlock)(BOOL success);

// 渲染用户回调
typedef void (^TCAVIMUserDisplayBlock)(TCAVIMUserEntity *user);

// 用户离开回调
typedef void (^TCAVIMUserExitBlock)(NSString *userId);

// 当前用户离开房间回调
typedef void (^TCAVIMLocalUserExitRoomBlock)();

@interface TCAVIMAdapter : NSObject<QAVRoomDelegate, QAVLocalVideoDelegate, QAVRemoteVideoDelegate>

@property (nonatomic, strong) TCAVHost *avHost;
@property (nonatomic, strong) TCAVIMUserEntity *mainUser; // 主用户（全屏用户）
@property (nonatomic, strong) TCAVIMUserEntity *localUser; // 当前用户
@property (nonatomic, strong) TCAVLivePreView *preView;
@property (nonatomic, strong) NSMutableArray <TCAVIMUserEntity *>*userArray; // 不包括主用户和localUser

@property (nonatomic, copy) TCAVIMUserDisplayBlock displayUserBlock;
@property (nonatomic, copy) TCAVIMUserExitBlock userExitBlock;
@property (nonatomic, copy) TCAVIMLocalUserExitRoomBlock localUserExitRoomBlock;

/// 代理
@property (nonatomic, weak) id <TCAVIMAdapterDelegate> delegate;

// 请求某个人的视频画面
- (void)requestViewOf:(TCAVIMUserEntity *)user;

// 请求多个人的视频画面
- (void)requestMultipleViewOf:(NSArray *)users;

// 创建房间
- (void)creatRoomWith:(TCAVHost *)avhost completion:(TCAVIMAdapterEnterRoomBlock)block;

// 初始化
- (instancetype)initAdapterWithMainUser:(TCAVIMUserEntity *)mainUser  localUser:(TCAVIMUserEntity *)localUser;

@end

@protocol TCAVIMAdapterDelegate <NSObject>

@optional

/**
 *  @author renqingyang 17-03-06 14：39：19
 *
 *  @brief 获取users显示区域字典
 *
 *  @param includeLocal 是否包含本地画面区域
 *
 *  @return 区域字典，字典key为userID，value为rect对应的string
 *
 *  @since 1.0
 */

- (NSDictionary *)getAVIMAdapterUsersAvInteractArea:(BOOL)includeLocal;

@end


