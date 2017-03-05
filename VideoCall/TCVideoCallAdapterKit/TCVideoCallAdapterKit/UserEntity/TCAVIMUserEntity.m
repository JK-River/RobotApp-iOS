//
//  AVIMUserEntity.m
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "TCAVIMUserEntity.h"

@implementation TCAVIMUserEntity

// 关闭摄像头
-(void)doCtrlCameraCompletion:(void (^)(BOOL success))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doCtrlCamera)])
    {
        BOOL success = [self.delegate doCtrlCamera];
        
        if (completion)
        {
            completion(success);
        }
    }
}

// 关闭Mic
-(void)doCtrlMicCompletion:(void (^)(BOOL success))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doCtrlMic)])
    {
        BOOL success = [self.delegate doCtrlMic];
        
        if (completion)
        {
            completion(success);
        }
    }
}

// 切换摄像头
-(void)doCtrlFrontCameraCompletion:(void (^)(BOOL success))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doCtrlFrontCamera)])
    {
        BOOL success = [self.delegate doCtrlFrontCamera];
        
        if (completion)
        {
            completion(success);
        }
    }
}

@end
