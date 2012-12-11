//
//  MainViewController.h
//  Aico
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageScrollViewController;
@interface MainViewController : UIViewController<UIScrollViewDelegate>
{
    UIImage *srcImage_;                         //源图片
    CGFloat zoomScale_;                         //放缩倍数
    ImageScrollViewController *imageScrollVC_;
    int fatherController;                       //区分是从主页过来的 还是从aico文件夹过来的 0：主页，1：Aico文件夹
}
@property(nonatomic,retain) UIImage *srcImage;
@property(nonatomic,assign) int fatherController;

/**
 * @brief  点击编辑按钮响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)adjustButtonPressed:(id)sender;

/**
 * @brief  点击特效响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)effectButtonPressed:(id)sender;

/**
 * @brief  点击装饰响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)stickerButtonPressed:(id)sender;

/**
 * @brief  点击导出响应方法
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note IB调用
 */
- (IBAction)exportButtonPressed:(id)sender;

/**
 * @brief  检查撤销按钮显示
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)checkButton;
@end
