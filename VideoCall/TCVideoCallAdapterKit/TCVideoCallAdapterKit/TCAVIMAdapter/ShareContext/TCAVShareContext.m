//
//  TCAVShareContext.m
//  TCQAVAdapterKit
//
//  Created by 任清阳 on 2017/2/25.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "TCAVShareContext.h"

#import "TCIMHost.h"
#import "TCIMUserEntity.h"
#import "TCIMManager.h"

@interface TCAVShareContext ()

@property (nonatomic, strong) QAVContext *sharedContext;

@end

@implementation TCAVShareContext

static TCAVShareContext *kSharedConext = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        kSharedConext = [[TCAVShareContext alloc] init];
    });
    
    return kSharedConext;
}


+ (QAVContext *)sharedContext
{
    return [TCAVShareContext sharedInstance].sharedContext;
}

+ (void)configWithStartedContext:(QAVContext *)context
{
    if ([TCAVShareContext sharedInstance].sharedContext)
    {
        [TCAVShareContext destroyContextCompletion:^{
            [TCAVShareContext sharedInstance].sharedContext = context;
        }];
    }
    else
    {
        [TCAVShareContext sharedInstance].sharedContext = context;
    }
}

+ (void)configWithStartedContext:(TCIMUserEntity *)userEntity
                  withCompletion:(void (^)(BOOL success))completion
{
    if ([TCAVShareContext sharedInstance].sharedContext == nil)
    {
        QAVContextStartParam *config = [[QAVContextStartParam alloc] init];

        NSString *appid = [TCIMManager sharedInstance].host.imSDKAppId;
        
        config.sdkAppId = [appid intValue];
        config.appidAt3rd = appid;
        config.identifier = [userEntity userId];
        
        config.accountType = [TCIMManager sharedInstance].host.imSDKAccountType;

        config.engineCtrlType = QAVSpearEngineCtrlTypeCloud;
        QAVContext *context = [QAVContext CreateContext];
        
        [context startWithParam:config completion:^(int result, NSString *errorInfo) {

            if (result == QAV_OK)
            {
                [TCAVShareContext sharedInstance].sharedContext = context;
            }
            
            if (completion)
            {
                completion(result == QAV_OK);
            }
        }];
    }
}

+ (void)destroyContextCompletion:(void (^)())completion
{
    if ([TCAVShareContext sharedInstance].sharedContext)
    {
        QAVResult res = [[TCAVShareContext sharedInstance].sharedContext stop];
        if (res != QAV_OK)
        {
            
        }
        [[TCAVShareContext sharedInstance].sharedContext destroy];
        [TCAVShareContext sharedInstance].sharedContext = nil;
        if (completion)
        {
            completion();
        }
    }
}

@end

