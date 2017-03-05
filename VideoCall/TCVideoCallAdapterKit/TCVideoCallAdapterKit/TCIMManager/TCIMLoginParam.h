//
//  TCIMLoginParam.h
//  TCQAVIMAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCIMLoginParam : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *sdkAppId;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic, copy) NSString *loginToken;
@property (nonatomic, copy) NSString *videoLicense;

@end
