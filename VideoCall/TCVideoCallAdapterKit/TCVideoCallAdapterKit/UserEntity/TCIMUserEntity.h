//
//  TCIMUserEntity.h
//  TCVideoCallAdapterKit
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 音视频操作回调
typedef void (^TCAVCompletion)(BOOL succ);

/*!
 *  @author renqingyang, 17-03-06 14:42:19
 *
 *  @brief  IM用户实体
 *
 *  @since  1.0
 */

@interface TCIMUserEntity : NSObject

/// 用户ID
@property (nonatomic, strong) NSString *userId;

@end
