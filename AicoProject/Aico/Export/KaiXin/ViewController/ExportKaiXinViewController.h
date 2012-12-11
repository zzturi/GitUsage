//
//  ExportKaiXinViewController.h
//  Aico
//
//  Created by rongtaowu on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KaixinConnect.h"

@protocol kaixinDelegate <NSObject>
- (void)loginSucess;
- (void)publishSucess;
- (void)publishFailed;
- (void)logoutSucess:(NSNotification *)notification;
@end

@interface ExportKaiXinViewController : UIViewController<KaixinRequestDelegate,KaixinDialogDelegate,KaixinSessionDelegate>
{
    id<kaixinDelegate> delegate_;                 //开心网代理
    Kaixin            *kaixin_;                   //开心网功能实现对象
    UIView            *displayWebView_;           //显示登陆
    UIActivityIndicatorView *activityView_;       //旋转等待
    BOOL             bChangeAccount_;             //标记切换账户
    BOOL             bExitAccount_;               //标记退出账户
}
@property(readonly) Kaixin *kaixin;
@property(nonatomic,assign)id <kaixinDelegate> delegate;
@property(nonatomic,assign)BOOL  bChangeAccount;
@property(nonatomic,assign)BOOL  bExitAccount;

/**
 * @brief  发送到开心网
 *
 * @param [in] content；发送内容
 * @param [out]
 * @return
 * @note 
 */
- (void)pubilishRecord:(NSDictionary *)content;

/**
 * @brief  发送到开心网
 *
 * @param [in] 获取当前登陆用户信息
 * @param [out]
 * @return
 * @note 
 */
- (void)getUserInfo;

/**
 * @brief  发送到开退出登陆
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)logout;

/**
 * @brief  更新当前网页内容
 *
 * @param [in] content；发送内容
 * @param [out]
 * @return
 * @note 
 */
- (void)updateView;
@end


