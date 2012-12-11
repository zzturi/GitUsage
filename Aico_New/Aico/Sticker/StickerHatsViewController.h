//
//  StickerHatsViewController.h
//  Aico
//
//  Created by Yincheng on 12-5-10.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerHatsViewController : UIViewController<UIWebViewDelegate>
{
    NSString *stringName_;    //导航栏标题
    NSInteger imageNum_;      //显示在装饰图片个数
    BOOL isStickerReplace_;   //是否是进行替换装饰push过来
    UIScrollView *scrollView_;
    NSString *contentCode_;   //二级分类号
    BOOL isNeedDownload_;     //是否需要下载
    
    UIActivityIndicatorView *activityIndicatorView_;
    UIAlertView *alterView_;
}
@property(nonatomic,copy)   NSString *stringName;
@property(nonatomic,assign) NSInteger imageNum;
@property(nonatomic,assign) BOOL isStickerReplace;
@property(nonatomic,copy)   NSString *contentCode;
@property(nonatomic,assign) BOOL isNeedDownload;

/**
 * @brief 导航栏初始化 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initNavigation;

/**
 * @brief 返回按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnButtonPressed:(id)sender;

/**
 * @brief 取消按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelButtonPressed:(id)sender;

/**
 * @brief 点击装饰处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseSticker:(id)sender;

/**
 * @brief 隐藏webview的背景 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (void) hideGradientBackground:(UIView*)theView;

/**
 * @brief 请求装饰图片列表 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)requestStickerDetailList;

/**
 * @brief 解压svgz图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)compressSVGZfile:(NSNotification *)notification;

/**
 * @brief 添加装饰图片 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)addStickerPictrue;
@end
