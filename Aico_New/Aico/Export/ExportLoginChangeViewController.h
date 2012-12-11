//
//  ExportLoginChangeViewController.h
//  Aico
//
//  Created by chen mengtao on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kaixin.h"

@interface ExportLoginChangeViewController : UIViewController<KaixinSessionDelegate,RenrenDelegate>
{
    UILabel *userLabel_;        // 获取用户名称
    UILabel *titleLabel_;       // 用户名标签
    UIButton *accountBtn_;      // 切换账户按钮
    UIButton *accountExitBtn_;  // 退出账户按钮
    NSString *strTitle_;        // 导航栏的title
    NSInteger rowTag_;          // 列表中每行的标记
    Renren *renren_;            //处理人人网分享的类
    BOOL isFromExit_;           //判断是否是由点击退出登录进入页面
}
@property(nonatomic,retain) IBOutlet UIButton *accountExitBtn;
@property(nonatomic,retain) IBOutlet UIButton *accountBtn;
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UILabel *userLabel;
@property(nonatomic,assign) NSInteger rowTag;
@property(nonatomic,copy) NSString *strTitle;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,retain) Renren *renren;
/**
 * @brief 
 * 切换账户按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)changeAccount:(id)sender;
/**
 * @brief 
 * 退出账户按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)exitAccount:(id)sender;
/**
 * @brief 通知更新sina用户名 回调函数
 * 当获取用户名成功时，会发更新用户名通知，
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)updateUserName:(NSNotification *)notification;
@end
