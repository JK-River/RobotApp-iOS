//
//  TCAVLivePreView.h
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "AVGLBaseView.h"
#import "TCAVFrameDispatcher.h"

// AVLivePreView 处理一路画面显示的问题
@interface TCAVLivePreView : UIView
{
@protected
    AVGLBaseView                *_imageView;            // 画面
    TCAVFrameDispatcher         *_frameDispatcher;      // 分发器
@protected
    UIView                      *_animationView;        // 开启泻染时，因开摄像头会有有闪，添加动画效果
}

// user为该画面对应的对象
- (void)addRenderFor:(NSString *)uid withRenderFrame:(CGRect)renderFrame;

// 绘制画面
- (void)addRenderFor:(NSString *)uid
      withVideoFrame:(QAVVideoFrame *)videoFrame
              isFull:(BOOL)isFull
             isLocal:(BOOL)isLocal;

// 开始预览
- (void)startPreview;

- (void)stopPreview;

// 移除user的渲染
- (void)removeRenderFor:(NSString *)uid;

- (void)removeImageView;

- (void)addImageView;
@end
