//
//  TCIMManager.h
//  TCAVIMAdapterKit
//
//  Created by 任清阳 on 2017/2/25.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ImSDK/ImSDK.h>

typedef void (^TCOfflineBlock)();
typedef void (^TCLoginBlock)(BOOL success);
typedef void (^TCLogoutBlock)(BOOL success);

@class TCIMHost;
@class TCIMLoginParam;
@class TCIMUserEntity;
@protocol TCAVIMReceiveMessageDelegate;

/*!
 *  @author renqingyang, 17-03-06 14:43:19
 *
 *  @brief  TCIM管理单例
 *
 *  @since  1.0
 */
@interface TCIMManager : NSObject

// app host配置
@property (nonatomic, readonly) TCIMHost *host;
// 登录配置信息
@property (nonatomic, readonly) TCIMLoginParam *loginParam;

+ (instancetype)initHostWith:(TCIMHost *)host;

// 供测试demo使用，跳转TC提供的UI
+ (instancetype)initHostWith:(TCIMHost *)host tlsDelegte:(id)delegate;

// 在测试demo中用户可以通过这个方法获取用户sig
- (NSString *)getSigWithIdentifierInTestEnvironment:(NSString *)identifier;

// 被踢下线时，进行调用
@property (nonatomic, copy) TCOfflineBlock offlineBlock;

/// 代理
@property (nonatomic, weak) id <TCAVIMReceiveMessageDelegate> delegate;

+ (instancetype)sharedInstance;

// 退出登录
- (void)loginOutCompletion:(TCLogoutBlock)block;
// 登录
- (void)loginWith:(TCIMLoginParam *)loginParam
        userModel:(TCIMUserEntity *)userModel
       completion:(TCLoginBlock)block;

@end

@protocol TCAVIMReceiveMessageDelegate <NSObject>

@optional

// 收到C2C自定义消息
- (void)onRecvC2CSender:(TCIMUserEntity *)user customMsg:(TIMCustomElem *)msg;

// 如果有sig获取方法，不回调此方法

@end

