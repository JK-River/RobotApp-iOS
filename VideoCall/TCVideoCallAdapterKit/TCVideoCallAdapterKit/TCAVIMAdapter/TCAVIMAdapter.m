//
//  TCAVIMAdapter.m
//  TCQAVIMAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "TCAVIMAdapter.h"

#import "TCAVShareContext.h"
#import "TCAVLivePreView.h"
#import "TCAVIMUserEntity.h"
#import "TCAVHost.h"

@interface TCAVIMAdapter ()<TCAVIMOperationActionDelegate>

@property (nonatomic, copy) TCAVIMAdapterEnterRoomBlock enterRoomBlock;

@end

@implementation TCAVIMAdapter

// 初始化
- (instancetype)initAdapterWithMainUser:(TCAVIMUserEntity *)mainUser  localUser:(TCAVIMUserEntity *)localUser
{
    if (self = [super init])
    {
        self.mainUser = mainUser;
        self.localUser = localUser;
        
        localUser.delegate = self;
    }
    return self;
}
// 创建房间
- (void)creatRoomWith:(TCAVHost *)avhost completion:(TCAVIMAdapterEnterRoomBlock)block
{
    
    self.enterRoomBlock = block;
    
    QAVMultiParam*param = [[QAVMultiParam alloc]init];
    
    param.relationId = (UInt32)[avhost.liveIMChatRoomId integerValue];
    
    param.audioCategory = 0;
    
    param.authBits = QAV_AUTH_BITS_DEFAULT;

    param.enableMic = NO;
    param.enableSpeaker = YES;
    param.createRoom = YES;
    param.videoRecvMode = VIDEO_RECV_MODE_SEMI_AUTO_RECV_CAMERA_VIDEO;

    [[TCAVShareContext sharedContext] enterRoom:param delegate:self];
}

#pragma mark - delegate

#pragma mark QAVLocalVideoDelegate

-(void)OnLocalVideoPreview:(QAVVideoFrame *)frameData
{
    if (self.localUser.isShow)
    {
        // 添加画面
        [self.preView addRenderFor:self.localUser.userId
                   withRenderFrame:self.localUser.avInteractArea];
        
        // 渲染画面
        [self.preView addRenderFor:self.localUser.userId withVideoFrame:frameData isFull:[self.localUser.userId isEqualToString:self.mainUser.userId] isLocal:YES];

    }
}

-(void)OnLocalVideoPreProcess:(QAVVideoFrame*)frameData
{
    
}
#pragma mark remoteVideoDelegate
-(void)OnVideoPreview:(QAVVideoFrame*)frameData{
    
    if ([frameData.identifier isEqualToString:self.mainUser.userId])
    {
        // 添加画面
        [self.preView addRenderFor:self.mainUser.userId
                   withRenderFrame:self.mainUser.avInteractArea];
        
        // 渲染画面
        [self.preView addRenderFor:self.mainUser.userId
                    withVideoFrame:frameData isFull:YES isLocal:NO];
    }
    else
    {
        [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.userId isEqualToString:frameData.identifier])
            {
                // 添加画面
                [self.preView addRenderFor:obj.userId
                           withRenderFrame:obj.avInteractArea];
                
                // 渲染画面
                [self.preView addRenderFor:obj.userId
                            withVideoFrame:frameData isFull:NO isLocal:NO];
                
                *stop = YES;
            }
        }];
    }
}


#pragma mark- QAVRoomDelegate

-(void)OnEnterRoomComplete:(int)result WithErrinfo:(NSString *)error_info
{
    // 进入AV房间
    if (![TCAVShareContext sharedContext])
    {
        NSLog(@"avContext已销毁");
        
        if (self.enterRoomBlock)
        {
            self.enterRoomBlock(NO);
        }
        
        return;
    }
    if(QAV_OK == result)
    {
        NSLog(@"进入AV房间成功");

        QAVVideoCtrl *ctrl = [[TCAVShareContext sharedContext] videoCtrl];
        if (ctrl)
        {
            [ctrl setLocalVideoDelegate:self];
            [ctrl setRemoteVideoDelegate:self];
        }

        if (self.enterRoomBlock)
        {
            self.enterRoomBlock(YES);
        }
    }
    else
    {
        if (self.enterRoomBlock)
        {
            self.enterRoomBlock(NO);
        }
    }
}

- (void)OnEndpointsUpdateInfo:(QAVUpdateEvent)eventID endpointlist:(NSArray *)endpoints
{
    
    QAVVideoCtrl *videoCtrl = [[TCAVShareContext sharedContext] videoCtrl];
    
    // 是否打开本地摄像头
    [videoCtrl enableCamera:CameraPosFront isEnable:self.localUser.isOpenCamera complete:^(int result) {
        
    }];

    QAVAudioCtrl *audioCtrl = [[TCAVShareContext sharedContext] audioCtrl];
    
    /// 设置打开扬声器
    [audioCtrl enableSpeaker:YES];
    
    [audioCtrl enableMic:self.localUser.isOpenMic];
    
    if (eventID == QAV_EVENT_ID_ENDPOINT_EXIT)
    {
        
        [endpoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[QAVEndpoint class]])
            {
                QAVEndpoint *endPoint = (QAVEndpoint *)obj;

                // 用户离开回调
                if (self.userExitBlock)
                {
                    self.userExitBlock(endPoint.identifier);
                }
            
                // 如果主播退出房间，则退出
                if ([endPoint.identifier isEqualToString:self.mainUser.userId])
                {
                    // 移除所有用户
                    [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.userId isEqualToString:endPoint.identifier])
                        {
                            [self.userArray removeObject:obj];
                            
                            [self.preView removeRenderFor:obj.userId];
                        }
                    }];
                    
                    // 移除主用户渲染
                    [self.preView removeRenderFor:self.mainUser.userId];
                }
                else
                {
                    // 移除单独用户
                    [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.userId isEqualToString:endPoint.identifier])
                        {
                            [self.userArray removeObject:obj];
                            
                            [self.preView removeRenderFor:obj.userId];
                            *stop = YES;
                        }
                    }];
                }
            }
        }];
    }
    else if (eventID == QAV_EVENT_ID_ENDPOINT_ENTER)
    {
        
    }
    else
    {
        // 其他事件监听
        switch (eventID)
        {
            case QAV_EVENT_ID_ENDPOINT_HAS_CAMERA_VIDEO:
            {
                [endpoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[QAVEndpoint class]])
                    {
                        QAVEndpoint *endPoint = (QAVEndpoint *)obj;
                        
                        // 如果是本地用户的，则不渲染视频
                        if ([endPoint.identifier isEqual:self.localUser.userId])
                        {
                            self.localUser.isShow = YES;
                        }
                        else
                        {
                            // 如果是主用户，不添加到用户列表，默认为全屏
                            if ([endPoint.identifier isEqual:self.mainUser.userId])
                            {
                                self.mainUser.isOpenCamera = YES;
                            }
                            else
                            {
                                __block BOOL isExist = NO;
                                [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    
                                    // 已经在用户列表中存在
                                    if ([obj.userId isEqualToString:endPoint.identifier])
                                    {
                                        // 标记摄像头打开状态
                                        obj.isOpenCamera = YES;
                                        
                                        isExist = YES;
                                        
                                        *stop = YES;
                                    }
                                }];
                                
                                if (!isExist)
                                {
                                    TCAVIMUserEntity *userModel = [TCAVIMUserEntity new];
                                    userModel.userId = endPoint.identifier;
                                    userModel.isOpenCamera = YES;
                                    
                                    // 添加新成员
                                    [self.userArray addObject:userModel];
                                }

                            }
                        }
                    }
                }];
                // 有人打开摄像头，请求画面
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(realRequestAllView) object:nil];
                
                [self realRequestAllView];
            }
                
                break;
            case QAV_EVENT_ID_ENDPOINT_NO_CAMERA_VIDEO:
            {
                // 有人关闭摄像头
                [endpoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[QAVEndpoint class]])
                    {
                        QAVEndpoint *endPoint = (QAVEndpoint *)obj;
                        
                        // 如果是本地用户的，则不渲染视频
                        if ([endPoint.identifier isEqual:self.localUser.userId])
                        {
                            self.localUser.isShow = NO;
                            
                            [self.preView removeRenderFor:self.localUser.userId];
                        }
                        else
                        {
                            if ([endPoint.identifier isEqual:self.mainUser.userId])
                            {
                                self.mainUser.isOpenCamera = NO;
                                
                                // 移除主用户渲染
                                [self.preView removeRenderFor:self.mainUser.userId];
                            }
                            else
                            {
                                [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                    
                                    // 已经在用户列表中存在
                                    if ([obj.userId isEqualToString:endPoint.identifier])
                                    {
                                        // 移除用户，别从渲染画面中移除
                                        [self.userArray removeObject:obj];
                                        
                                        [self.preView removeRenderFor:obj.userId];
                                        *stop = YES;
                                    }
                                }];
                            }
                        }
                    }
                }];
            }
                break;
            case QAV_EVENT_ID_ENDPOINT_HAS_AUDIO:
            {
                // 打开关闭麦克
            }
                break;
            case QAV_EVENT_ID_ENDPOINT_NO_AUDIO:
            {
                // 有人关闭麦克
            }
                break;
            default:
                break;
        }
    }
    
}

-(void)OnExitRoomComplete{
    
    /// 禁止锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[TCAVShareContext sharedContext] stop];
        
        [self.preView stopPreview];
            
        if (self.localUserExitRoomBlock)
        {
            self.localUserExitRoomBlock();
            self.localUserExitRoomBlock = nil;
        }
    });
}
-(void)OnPrivilegeDiffNotify:(int)privilege
{
    
}
- (void)realRequestAllView
{
    if (self.userArray.count > 0)
    {
        NSMutableArray *typeArray = [NSMutableArray array];
        NSMutableArray *idlist = [NSMutableArray array];
        for (NSInteger i = 0; i < _userArray.count; i++)
        {
            TCAVIMUserEntity *user = [_userArray objectAtIndex:i];
            [idlist addObject:user.userId];
            [typeArray addObject:@(QAVVIDEO_SRC_TYPE_CAMERA)];
        }
        
        [idlist insertObject:self.mainUser.userId atIndex:0];
        [typeArray addObject:@(QAVVIDEO_SRC_TYPE_CAMERA)];

        [[TCAVShareContext sharedContext].room requestViewList:idlist srcTypeList:typeArray ret:^(int result, NSString *error_info) {
            if (result != QAV_OK)
            {

            }
            else
            {
                NSLog(@"请求画面成功");
            }
            
        }];
    }
}

// 获取user AVArae
-(void)getAVIMAdapterUsersAvInteractArea
{
    if (self.delegate
        &&[self.delegate respondsToSelector:@selector(getAVIMAdapterUsersAvInteractArea)])
    {
        NSDictionary *areaDic = [self.delegate getAVIMAdapterUsersAvInteractArea];
                
        [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.avInteractArea = CGRectFromString(areaDic[obj.userId]);
        }];
    }
    else
    {
        [self.userArray enumerateObjectsUsingBlock:^(TCAVIMUserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSInteger index = self.localUser.isShow ? 1 : 0;
            
            obj.avInteractArea = CGRectMake(120 * (index + idx), 0, 120, 90);
        }];
    }
}
#pragma mark - TCAVIMOperationActionDelegate

-(BOOL)doCtrlCamera
{
    BOOL isFront = [[TCAVShareContext sharedContext].videoCtrl isFrontcamera];
    
    QAVVideoCtrl *videoCtrl = [[TCAVShareContext sharedContext] videoCtrl];
    
    self.localUser.isOpenCamera = !self.localUser.isOpenCamera;
    
    // 打开本地摄像头
    QAVResult result = [videoCtrl enableCamera:isFront isEnable:self.localUser.isOpenCamera complete:^(int result) {
        
    }];
    
    return result == 0;
}

-(BOOL)doCtrlMic
{
    QAVAudioCtrl *audioCtrl = [[TCAVShareContext sharedContext] audioCtrl];
    
    self.localUser.isOpenMic = !self.localUser.isOpenMic;
    
    return [audioCtrl enableMic:self.localUser.isOpenMic];
}

-(BOOL)doCtrlFrontCamera
{
    BOOL isFront = [[TCAVShareContext sharedContext].videoCtrl isFrontcamera];
    
    QAVVideoCtrl *videoCtrl = [[TCAVShareContext sharedContext] videoCtrl];
    
    // 切换摄像头
    QAVResult result = [videoCtrl switchCamera:!isFront complete:^(int result) {
        
    }];
    
    return result == 0;
}
@end

