//
//  TCVideoCallAdapterKit.h
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <UIKit/UIKit.h>

// 若是通过引用Framework的方式使用类库，则需要以 #import <TCVideoCallAdapterKit/TCVideoCallAdapterKit.h> 的方式引入头文件
#if __has_include(<TCVideoCallAdapterKit/TCVideoCallAdapterKit.h>)

//! Project version number for TCVideoCallAdapterKit.
FOUNDATION_EXPORT double TCVideoCallAdapterKitVersionNumber;

//! Project version string for TCVideoCallAdapterKit.
FOUNDATION_EXPORT const unsigned char TCVideoCallAdapterKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <TCVideoCallAdapterKit/PublicHeader.h>


#import <TCVideoCallAdapterKit/TCIMUserEntity.h>
#import <TCVideoCallAdapterKit/TCAVIMUserEntity.h>
#import <TCVideoCallAdapterKit/TCIMManager.h>
#import <TCVideoCallAdapterKit/TCIMHost.h>
#import <TCVideoCallAdapterKit/TCIMLoginParam.h>
#import <TCVideoCallAdapterKit/TCAVHost.h>
#import <TCVideoCallAdapterKit/TCAVIMAdapter.h>
#import <TCVideoCallAdapterKit/TCAVLivePreView.h>


// 若是通过引用源码或者lib库的方式使用类库，则需要以 #import "TCVideoCallAdapterKit.h" 的方式引入头文件
#else

#import "TCIMUserEntity.h"
#import "TCAVIMUserEntity.h"
#import "TCIMManager.h"
#import "TCIMHost.h"
#import "TCIMLoginParam.h"
#import "TCAVHost.h"
#import "TCAVIMAdapter.h"
#import "TCAVLivePreView.h"

#endif
