//
//  TCIMManager.m
//  TCAVIMAdapterKit
//
//  Created by 任清阳 on 2017/2/25.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "TCIMManager.h"

#import "TCIMUserEntity.h"
#import "TCIMHost.h"
#import "TCIMLoginParam.h"
#import "TCAVShareContext.h"

@interface TCIMManager ()<TIMUserStatusListener,TIMMessageListener>

@property (nonatomic, copy) TCLoginBlock loginBlock;
@property (nonatomic, copy) TCLogoutBlock logoutBlock;

@property (nonatomic, readwrite) TCIMHost *host;
@property (nonatomic, readwrite) TCIMLoginParam *loginParam;
@end

@implementation TCIMManager

static TCIMManager *_sharedInstance = nil;

+ (instancetype)initHostWith:(TCIMHost *)host
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[TCIMManager alloc] init];
        [_sharedInstance configIMHost:host];
    });
    
    return _sharedInstance;
    
}

+ (instancetype)sharedInstance
{
    return _sharedInstance;
}

- (void)configIMHost:(TCIMHost *)host
{
    self.host = host;
    
    TIMManager *manager = [TIMManager sharedInstance];
    
    [manager setEnv:host.environment];
    
    [manager initSdk:[host.imSDKAppId intValue] accountType:host.imSDKAccountType];

    /// 添加信息代理
    [manager setMessageListener:self];
    /// 添加在线状态代理
    [manager setUserStatusListener:self];
}


- (void)onLogoutCompletion
{
    self.offlineBlock = nil;

    _host = nil;
    _loginParam = nil;
    
     [TCAVShareContext destroyContextCompletion:nil];
}

- (void)loginOutCompletion:(TCLogoutBlock)block
{
    __weak TCIMManager *ws = self;
    
    [[TIMManager sharedInstance] logout:^{
        [ws onLogoutCompletion];
        if (block)
        {
            block(YES);
        }
    } fail:^(int code, NSString *err) {
        [ws onLogoutCompletion];
        if (block)
        {
            block(NO);
        }
    }];
}

- (void)loginWith:(TCIMLoginParam *)loginParam
        userModel:(TCIMUserEntity *)userModel
       completion:(TCLoginBlock)block
{
    self.loginParam = loginParam;
    if (!_host)
    {
        if (block)
        {
            block(NO);
        }
    }
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
    login_param.identifier = self.loginParam.identifier;
    login_param.appidAt3rd = self.loginParam.sdkAppId;
    login_param.accountType = self.loginParam.accountType;
    login_param.sdkAppId = [self.loginParam.sdkAppId intValue];
    login_param.userSig = self.loginParam.videoLicense;
\
    [[TIMManager sharedInstance] login:login_param succ:^(){
        
        [TCAVShareContext configWithStartedContext:userModel withCompletion:^(BOOL success) {
            if (block)
            {
                block(success);
            }
        }];
    }
     
                                  fail:^(int code, NSString * err) {
                                      if (block)
                                      {
                                          block(NO);
                                      }
                                  }];
}

- (void)onNewMessage:(NSArray *)msgs
{
    for(TIMMessage *msg in msgs)
    {
        TIMConversationType conType = msg.getConversation.getType;
        
        switch (conType)
        {
            case TIM_C2C:
            {
                if (self.delegate
                    &&[self.delegate respondsToSelector:@selector(onRecvC2CSender:customMsg:)])
                {
                    // C2C时获取到消息GetSenderProfile为空
                    NSString *recv = [[msg getConversation] getReceiver];
                    TCIMUserEntity *user = [TCIMUserEntity new];
                    user.userId = recv;
                    
                    // 未处理C2C文本消息
                    for(int index = 0; index < [msg elemCount]; index++)
                    {
                        TIMElem *elem = [msg getElem:index];
                        
                        // 只处理C2C自定义消息，不处理其他类型聊天消息
                        if([elem isKindOfClass:[TIMCustomElem class]])
                        {
                            // 自定义消息
                            [self.delegate onRecvC2CSender:user customMsg:(TIMCustomElem *)elem];
                        }
                    }
                }
            }
                break;
            case TIM_GROUP:
            {
                
            }
                break;
            case TIM_SYSTEM:
            {
                
            }
                break;
            default:
                break;
        }
    }
}
@end

