//
//  TCAVLivePreView.h
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QAVSDK/QAVSDK.h>

// AVLivePreView 处理一路画面显示的问题
@interface TCAVLivePreView : UIView

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
@end
