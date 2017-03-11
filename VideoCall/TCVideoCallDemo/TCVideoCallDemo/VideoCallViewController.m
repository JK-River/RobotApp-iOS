//
//  VideoCallViewController.m
//  TCVideoCallDemo
//
//  Created by 任清阳 on 2017/3/11.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import "VideoCallViewController.h"

#import <TCVideoCallAdapterKit/TCVideoCallAdapterKit.h>

@interface VideoCallViewController ()<TCAVIMAdapterDelegate>

@property (nonatomic, strong) TCAVLivePreView *previewView;

@property (nonatomic, strong) NSString *userId;
@end

@implementation VideoCallViewController

-(instancetype)initWithUserId:(NSString *)userId
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        self.userId = userId;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.previewView];
    
    TCAVIMUserEntity *mainUser = [TCAVIMUserEntity new];
    mainUser.userId = self.userId;
    
    TCAVIMUserEntity *localUser = [TCAVIMUserEntity new];
    localUser.userId = self.userId;
    localUser.avInteractArea = self.previewView.bounds;
    localUser.isOpenCamera = YES;
    localUser.isOpenMic = YES;
    localUser.isShow = YES;
    
    TCAVIMAdapter *AVIMAdapter = [[TCAVIMAdapter alloc] initAdapterWithMainUser:mainUser localUser:localUser];
    
    AVIMAdapter.preView = self.previewView;
    
    TCAVHost *host = [TCAVHost new];
    
    host.liveIMChatRoomId = @"111111";
    host.liveAVIMModel = mainUser;
    
    [AVIMAdapter creatRoomWith:host completion:^(BOOL success) {
        NSLog(@"%@",success?@"进入房间成功":@"进入房间失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TCAVLivePreView *)previewView
{
    if (!_previewView)
    {
        _previewView = [[TCAVLivePreView alloc] initWithFrame:self.view.bounds];
    }
    return _previewView;
}

- (NSDictionary *)getAVIMAdapterUsersAvInteractArea
{
    return @{};
}
@end
