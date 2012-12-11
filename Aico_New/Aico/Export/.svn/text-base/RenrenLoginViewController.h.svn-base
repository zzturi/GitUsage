//
//  RenrenLoginViewController.h
//  Aico
//
//  Created by Mike on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenrenLoginViewController : UIViewController<RenrenDelegate,UIWebViewDelegate,UIAlertViewDelegate>
{
    Renren *renren_;
    BOOL isFromChangeAccount_;              //由退出登录按钮进入
    BOOL isFromExit_;                       //由切换帐号按钮进入本页面
}
@property(nonatomic,retain) Renren *renren;
@property(nonatomic,assign) BOOL isFromChangeAccount;
@property(nonatomic,assign) BOOL isFromExit;
@end
