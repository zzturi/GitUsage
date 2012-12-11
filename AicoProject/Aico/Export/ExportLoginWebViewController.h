//
//  ExportLoginWebViewController.h
//  Aico
//
//  Created by chen mengtao on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExportLoginWebViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>
{
    UIWebView *loginWebView_;      // 存储UIWebView
    NSString *appKey_;             // 申请key
	NSString *appSecret_;          // 申请secret
	NSString *tokenKey_;           // Request TokenKey
	NSString *tokenSecret_;        // Request TokenSecret
    NSURLConnection *connection_;  // 网络连接
    NSMutableData *responseData_;  // 保存网络返回的信息
    BOOL isExitCurrentCount_;       // 标记是否从退出按钮传入
}
@property(nonatomic,copy) NSString *appKey;
@property(nonatomic,copy) NSString *appSecret;
@property(nonatomic,copy) NSString *tokenKey;
@property(nonatomic,copy) NSString *tokenSecret;
@property(nonatomic,retain) NSURLConnection *connection;
@property(nonatomic,retain) NSMutableData *responseData;
@property(nonatomic,assign) BOOL isExitCurrentCount;
/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelBtnPressed:(id)sender;
/**
 * @brief 
 * 加载tokenKey和tokenSecret值
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)loadDefaultKey;
/**
 * @brief 
 * 保存tokenKey和tokenSecret值
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)saveDefaultKey;
/**
 * @brief 
 * 从字符串中查找key的值
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query;
/**
 * @brief 
 * 从Respone中解析出tokenkey和tokensecret
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)parseTokenKeyWithResponse:(NSString *)aResponse;

/**
 * @brief 
 * 移除转圈
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
-(void)removeActivity;
@end
