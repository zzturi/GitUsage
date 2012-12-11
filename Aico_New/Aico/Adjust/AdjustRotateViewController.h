//
//  AdjustRotateViewController.h
//  Aico
//
//  Created by Yincheng on 12-3-29.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdjustRotateProcess,ImageScrollViewController;
@interface AdjustRotateViewController : UIViewController 
{
    UIImage         *srcImage_;               //旋转页面显示的图片
    AdjustRotateProcess *rotateProcess_;      //旋转处理类    
    UIView       *toolBar_;                   //工具栏
    ImageScrollViewController *imageScrollVC_;
}
@property(nonatomic,copy)   UIImage *srcImage;
@property(nonatomic,retain) AdjustRotateProcess *rotateProcess;
@property(nonatomic,retain) UIView *toolBar;

/**
 * @brief 逆时针旋转90度(向左旋转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)leftRotate:(id)sender;

/**
 * @brief 顺时针旋转90度(向右旋转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)rightRotate:(id)sender;

/**
 * @brief 水平翻转(左右翻转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)HorizontalRotate:(id)sender;

/**
 * @brief 垂直翻转(上下翻转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)VerticalRotate:(id)sender;

/**
 * @brief 确认按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)finishRotate:(id)sender;

/**
 * @brief 取消按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnAdjustMenu:(id)sender;
@end
