//
//  TCIMHost.h
//  TCQAVIMAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCIMHost : NSObject

// 当前App对应的AppID
@property (nonatomic, strong) NSString *imSDKAppId;

// 当前App的AccountType
@property (nonatomic, strong) NSString *imSDKAccountType;

// 当前App的environment
@property (nonatomic, assign) int environment;
@end
