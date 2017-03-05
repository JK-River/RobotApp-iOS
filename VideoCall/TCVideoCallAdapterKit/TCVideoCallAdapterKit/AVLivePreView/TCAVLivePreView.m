//
//  AVLivePreView.m
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "TCAVLivePreView.h"

#import "TCAVShareContext.h"

@interface TCAVLivePreView ()

@end

@implementation TCAVLivePreView

- (void)dealloc
{
    [self stopPreview];
    [_imageView destroyOpenGL];
    _imageView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)startPreview
{
    if (![_imageView isDisplay])
    {
        [_imageView startDisplay];
    }
}

- (void)stopPreview
{
    if (_imageView)
    {
        [_imageView stopDisplay];
    }
}

- (void)removeRenderOf:(NSString *)uid
{
    if (uid)
    {
        [_imageView removeSubviewForKey:uid];
    }
}

- (void)addRenderFor:(NSString *)uid withRenderFrame:(CGRect)renderFrame
{
    if (!uid)
    {
        return;
    }
    
    AVGLRenderView *glView = [_imageView getSubviewForKey:uid];
    
    if (!glView)
    {
        glView = [[AVGLRenderView alloc] initWithFrame:_imageView.bounds];
        [_imageView addSubview:glView forKey:uid];
    }
    else
    {
        
    }
    
    [glView setHasBlackEdge:NO];
    glView.nickView.hidden = YES;
    [glView setBoundsWithWidth:0];
    [glView setDisplayBlock:NO];
    [glView setCuttingEnable:YES];
    
    if (!CGRectIsEmpty(renderFrame))
    {
        [glView setFrame:renderFrame];
    }
    
    if (![_imageView isDisplay])
    {
        [_imageView startDisplay];
    }
}
- (void)removeRenderFor:(NSString *)uid
{
    [_imageView removeSubviewForKey:uid];
}
// 绘制画面
- (void)addRenderFor:(NSString *)uid
      withVideoFrame:(QAVVideoFrame *)videoFrame
              isFull:(BOOL)isFull
             isLocal:(BOOL)isLocal
{
    videoFrame.identifier = uid;
    
    if ([_imageView isDisplay])
    {
        if (isLocal)
        {
            BOOL isFront = [[TCAVShareContext sharedContext].videoCtrl isFrontcamera];
            
            [_frameDispatcher dispatchVideoFrame:videoFrame isLocal:YES isFront:isFront isFull:isFull];
        }
        else
        {
            [_frameDispatcher dispatchVideoFrame:videoFrame isLocal:NO isFront:NO isFull:isFull];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}
- (void)removeImageView
{
    [self stopPreview];
    [_imageView destroyOpenGL];
    
    [_imageView removeFromSuperview];
    
    _imageView = nil;
}
- (void)addImageView
{
    if (_imageView) {
        return;
    }
    else
    {
        _imageView = [[AVGLBaseView alloc] initWithFrame:self.bounds];
        
        glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
        [_imageView setBackGroundTransparent:YES];
        [self insertSubview:_imageView atIndex:1];
        
        @try
        {
            [_imageView initOpenGL];
            
            _frameDispatcher = [[TCAVFrameDispatcher alloc] init];
            _frameDispatcher.imageView = _imageView;
            NSLog(@"初始化OpenGL成功");
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"OpenGL 初台化异常");
        }
        @finally
        {
            
        }
    }
}

@end
