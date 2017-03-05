//
//  TCAVFrameDispatcher.h
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "AVFrameDispatcher.h"

@interface TCAVFrameDispatcher : AVFrameDispatcher

@property (nonatomic, strong) AVGLBaseView *imageView;

- (void)dispatchVideoFrame:(QAVVideoFrame *)frame
                   isLocal:(BOOL)isLocal
                   isFront:(BOOL)frontCamera
                    isFull:(BOOL)isFull;

@end
