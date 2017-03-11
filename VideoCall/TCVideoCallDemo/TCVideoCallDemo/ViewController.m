//
//  ViewController.m
//  TCVideoCallDemo
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "ViewController.h"

#import <TCVideoCallAdapterKit/TCVideoCallAdapterKit.h>

#import "VideoCallViewController.h"

#define kSdkAppId       @"1400001692"
#define kSdkAccountType @"884"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TCIMHost *host = [TCIMHost new];
    
    host.imSDKAppId = kSdkAppId;
    host.imSDKAccountType = kSdkAccountType;
    host.environment = 0;
    
    // 因TLSSDK在IMSDK里面初始化，必须先初始化IMSDK，才能使用TLS登录
    // 导致登出然后使用相同的帐号登录，config会清掉
    
    [TCIMManager initHostWith:host tlsDelegte:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate<TLSUILoginListener>
-(void)TLSUILoginOK:(TLSUserInfo *)userinfo
{
    //回调时已结束登录流程 销毁微信回调对象
    //根据登录结果处理
    [self loginWith:userinfo];
}

//demo暂不提供微博登录
-(void)TLSUILoginWBOK:(WBAuthorizeResponse *)resp
{
    
}
-(void)TLSUILoginQQOK
{
    
}
-(void)TLSUILoginWXOK:(SendAuthResp *)resp
{
    
}
-(void)TLSUILoginCancel
{
    //回调时已结束登录流程 销毁微信回调对象
}

#pragma mark - TLSOpenLoginListener

//第三方登录成功之后，再次登陆tls换取userinfo
-(void)OnOpenLoginSuccess:(TLSUserInfo *)userinfo
{
    //回调时已结束登录流程 销毁微信回调对象
    //根据登录结果处理
    [self loginWith:userinfo];
}

-(void)OnOpenLoginFail:(TLSErrInfo*)errInfo
{
    
}

-(void)OnOpenLoginTimeout:(TLSErrInfo*)errInfo
{
    
}

#pragma mark - Provate Methods


#pragma mark - 刷新票据代理

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{

}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

- (void)loginWith:(TLSUserInfo *)userinfo
{

    dispatch_async(dispatch_get_main_queue(), ^{
        if (userinfo)
        {
            TCIMLoginParam *loginParan = [TCIMLoginParam new];
            
            loginParan.identifier = userinfo.identifier;
            
            NSString *sig = [[TCIMManager sharedInstance] getSigWithIdentifierInTestEnvironment:userinfo.identifier];
            loginParan.videoLicense = sig;
            loginParan.sdkAppId = kSdkAppId;
            loginParan.accountType = kSdkAccountType;
            
            TCIMUserEntity *userEntity = [TCIMUserEntity new];
            userEntity.userId = userinfo.identifier;
            
            [[TCIMManager sharedInstance] loginWith:loginParan userModel:userEntity completion:^(BOOL success) {
                NSLog(@"%@",success?@"登录成功":@"登录失败");
                if (success) {
                    [self.navigationController pushViewController:[[VideoCallViewController alloc] initWithUserId:userinfo.identifier] animated:YES];
                }
            }];
        }
    });
}
@end
