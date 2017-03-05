//
//  TCAVFrameDispatcher.m
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "TCAVFrameDispatcher.h"

@implementation TCAVFrameDispatcher

- (void)dispatchVideoFrame:(QAVVideoFrame *)frame isLocal:(BOOL)isLocal isFront:(BOOL)frontCamera isFull:(BOOL)isFull
{
    NSString *renderKey = frame.identifier;
    
    AVGLRenderView *glView = [self.imageView getSubviewForKey:renderKey];
    
    if (glView)
    {
        
        [glView setNeedMirrorReverse:frontCamera];
        //        glView.isFloat = YES;
        
        AVGLImage * image = [[AVGLImage alloc] init];
        
        /// 当不是本地画面时
        if (!isLocal)
        {
            if (frame.frameDesc.rotate == 1)
            {
                if (isFull)
                {
                    image.angle = 0.0 + 180.0;
                }
                else
                {
                    image.angle = 0.0;
                }
            }
            else if (frame.frameDesc.rotate == 2)
            {
                if (isFull)
                {
                    image.angle = 0.0 + 180.0;
                }
                else
                {
                    image.angle = 0.0;
                }
            }
            else if (frame.frameDesc.rotate == 0)
            {
                if (isFull)
                {
                    image.angle = 180.0;
                }
                else
                {
                    image.angle = 180.0;
                }
            }
        }
        else
        {
            image.angle = 180.0;
        }
        
        
        image.data = (Byte *)frame.data;
        image.width = (int)frame.frameDesc.width;
        image.height = (int)frame.frameDesc.height;
        image.viewStatus = VIDEO_VIEW_DRAWING;
        
        if (isLocal) {
            image.dataFormat = Data_Format_NV12;
        }
        else
        {
            image.dataFormat = Data_Format_I420;
        }
        
        [glView setImage:image];
    }
    
}

- (float)calcRotateAngle:(int)peerFrameAngle selfAngle:(int)frameAngle
{
    float degree = 0.0f;
    
    frameAngle = (frameAngle+peerFrameAngle+3)%4;
    
    // 调整显示角度
    switch (frameAngle)
    {
        case 0:
        {
            degree = -180.0f;
        }
            break;
        case 1:
        {
            degree = -90.0f;
        }
            break;
        case 2:
        {
            degree = 0.0f;
        }
            break;
        case 3:
        {
            degree = 90.0f;
        }
            break;
        default:
        {
            degree = 0.0f;
        }
            break;
    }
    
    return degree;
}

- (BOOL)calcFullScr:(int)peerFrameAngle selfAngle:(int)frameAngle
{
    if ((peerFrameAngle & 1) == 0 && (frameAngle & 1) == 0)
    {
        // 对方和自己都是横屏
        return YES;
    }
    else if ((peerFrameAngle & 1) && (frameAngle & 1))
    {
        // 对方和自己都是竖屏
        return YES;
    }
    else if ((peerFrameAngle & 1) == 0 && (frameAngle & 1))
    {
        // 对方横屏，自己竖屏
        return NO;
    }
    else if ((peerFrameAngle & 1) && (frameAngle & 1) == 0)
    {
        // 对方竖屏，自己横屏
        return NO;
    }
    return YES;
}


@end
