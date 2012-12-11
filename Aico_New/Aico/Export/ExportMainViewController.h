//
//  ExportMainViewController.h
//  Aico
//
//  Created by chen mengtao on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBSendView.h"		
#import "WBEngine.h"
#import "ExportKaiXinViewController.h"

@interface ExportMainViewController : UIViewController <UITextViewDelegate, WBEngineDelegate,WBRequestDelegate,kaixinDelegate,RenrenDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>
{
    UIImage *storeImage_;                              // 存储图片
    UIImageView *imageView_;                           // 显示图片缩略图
    UITextView *contentView_;                          // 分享的文字
    UIButton *storeImgBtn_;                            // 存储图片按钮  
    UIButton *toAimiButton_;                           // 调用Aimi按钮
    NSURLConnection *connection_;                      // 网络连接
    NSMutableData *responseData_;                      // 网络接收的数据    
    UITableView *tableView_;                           // tableView表格
    NSArray *shareWBName_;                             // 微博的名称
    NSArray *imageName_;                               // 微博图标的名称    
    int btnTag_;                                       // 配置按钮标记
    int switchTag_;                                    // Switch按钮开关标记    
	BOOL bSending;                                     // 发送请求中	
    int hasSentCount_;                                 // 记住当前打开，分享，已经回调了的账户个数
    int hasOpenCount_;                                 // 记住当前打开了几个微博
    NSMutableDictionary *accountInfoDict_;             // 各个微博信息，是否打开，是否分享成功
    NSTimer *timeOutTimer_;                            // 分享超时定时器
    WBEngine *sinaWBEngine_;                           // 新浪微博数据处理  
    ExportKaiXinViewController *kaiXinViewController_;
    Renren *renren_;   
}
@property(nonatomic,retain) IBOutlet UILabel *titleLabel;
@property(nonatomic,retain) IBOutlet UIButton *storeImgBtn;
@property(nonatomic,retain) NSArray *imageName;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSArray *shareWBName;
@property(nonatomic,retain) UIImage *storeImage;
@property(nonatomic,retain) IBOutlet UIImageView *imageView;
@property(nonatomic,retain) IBOutlet UITextView *contentView;
@property(nonatomic,retain) NSURLConnection *connection;
@property(nonatomic,retain) NSMutableData *responseData;
@property(nonatomic,retain) Renren *renren;
@property(retain, nonatomic) IBOutlet UIButton *toAimiButton;
/**
 * @brief 
 * 保存图片按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)saveImageBtnPressed:(id)sender;
/**
 * @brief 
 * 配置账户按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)ConfigurePressed:(id)sender;
/**
 * @brief  隐藏renren配置帐号按钮，显示uiswitch
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)hideRenrenBtn;
/**
 * @brief  隐藏renren uiswitch，显示配置帐号按钮
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)hideRenrenSwitch;

/**
 * @brief  获取各个账户是否配置并打开，以及分享结果
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)getAccountInfoCount;


/**
 * @brief  分享微博时，添加转圈
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)addActivityView;


/**
 * @brief  分享微博结束，移除转圈
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)removeActivityView;


/**
 * @brief 分享超时定时器回调函数
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)timeOutFire;
/**
 * @brief  把renren uiswitch设为on，每次renren登录成功后会调用此方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)setRenrenSwitchOn;

//检查开心网TOKEN 有效期
- (BOOL)checkDateValid;

/**
 * @brief  分享微博结束时，显示各个微博的分享结果
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)showShareResult;

/**
 * @brief  分享到Aimi
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (IBAction)exportToAimi:(id)sender;

/**
 * @brief  打开调用界面
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
-(void)saveToInstagram;
@end
