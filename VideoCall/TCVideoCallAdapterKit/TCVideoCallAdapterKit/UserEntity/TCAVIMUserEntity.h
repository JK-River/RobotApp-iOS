//
//  AVIMUserEntity.h
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCIMUserEntity.h"

@protocol TCAVIMOperationActionDelegate;

/*!
 *  @author renqingyang, 17-03-06 14:42:19
 *
 *  @brief  AVIM用户实体
 *
 *  @since  1.0
 */

@interface TCAVIMUserEntity : TCIMUserEntity

// 互动时，用户画面显示的屏幕上的区域（opengl相关的位置）
@property (nonatomic, assign) CGRect avInteractArea;

// 是否打开了MIC
@property (nonatomic, assign) BOOL isOpenMic;
// 是否打开了摄像头
@property (nonatomic, assign) BOOL isOpenCamera;

/// 是否是主播
@property (nonatomic, assign) BOOL isLiveUser;

// 是否需要显示到屏幕上
@property (nonatomic, assign) BOOL isShow;

/// 代理
@property (nonatomic, weak) id <TCAVIMOperationActionDelegate> delegate;

// 关闭摄像头
-(void)doCtrlCameraCompletion:(void (^)(BOOL success))completion;
// 关闭Mic
-(void)doCtrlMicCompletion:(void (^)(BOOL success))completion;
// 切换摄像头
-(void)doCtrlFrontCameraCompletion:(void (^)(BOOL success))completion;

@end

// 用户视频操作delegate
@protocol TCAVIMOperationActionDelegate <NSObject>

@optional

-(BOOL)doCtrlCamera;

-(BOOL)doCtrlMic;

-(BOOL)doCtrlFrontCamera;

@end
