//
//  ViewController.h
//  TCVideoCallDemo
//
//  Created by 任清阳 on 2017/3/5.
//  Copyright © 2017年 任清阳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TLSUI/TLSUI.h"
#import "TLSSDK/TLSRefreshTicketListener.h"
#import "TLSSDK/TLSOpenLoginListener.h"

@interface ViewController : UIViewController<TLSUILoginListener,TLSRefreshTicketListener,TLSOpenLoginListener>


@end

