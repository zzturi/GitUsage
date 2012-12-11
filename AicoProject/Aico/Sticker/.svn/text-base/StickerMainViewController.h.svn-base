//
//  StickerMainViewController.h
//  Aico
//
//  Created by Yincheng on 12-5-15.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerMainViewController : UIViewController<UIActionSheetDelegate,UIWebViewDelegate>
{
    UIImageView *imageView_;  //底图
    UIImageView *btnView_;    //图钉
    
    CGPoint begPoint_;        //触摸开始位置
    CGPoint curPoint_;        //触摸当前位置
}

/**
 * @brief 返回按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnButtonPressed:(id)sender;

/**
 * @brief 确认按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)confirmButtonPressed:(id)sender;

/**
 * @brief 截取当前视图，获得图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)mergeImage;

/**
 * @brief 长按装饰图，弹出菜单
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)showStickerSheet:(NSInteger)stag;
@end
