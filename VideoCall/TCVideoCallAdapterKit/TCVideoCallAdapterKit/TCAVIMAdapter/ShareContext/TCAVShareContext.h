//
//  TCAVShareContext.h
//  TCQAVAdapterKit
//
//  Created by 任清阳 on 2017/2/25.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCIMUserEntity;

// 当用户量较大时，用户长时间使用直播场景时，用户每次进入直播的时候，如果重新创建context，会去拉取配置，导致进入房间变慢

@interface TCAVShareContext : NSObject
{
    QAVContext      *_sharedContext;
}

// 用户登录成功后只存在一个context
+ (QAVContext *)sharedContext;

// 防止因configWith创建context不成功时，为保留现有逻辑不变，则在原有TCAVBaseRoomEngine中添加
+ (void)configWithStartedContext:(QAVContext *)context;

+ (void)configWithStartedContext:(TCIMUserEntity *)userEntity
                  withCompletion:(void (^)(BOOL success))completion;

// 销毁当前上下文，切换用户时销毁
+ (void)destroyContextCompletion:(void (^)())completion;

@end
