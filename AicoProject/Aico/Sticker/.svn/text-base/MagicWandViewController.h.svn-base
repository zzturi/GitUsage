//
//  MagicWandViewController.h
//  Aico
//
//  Created by  Jiangliyin on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaintingView;
@class CustomSlider;
@interface MagicWandViewController : UIViewController
{
    PaintingView *paintView_;                //绘图具体实现视图
    CustomSlider *sizeSlider_;               //调节装饰大小的滑块
    
}

@property(nonatomic,retain) PaintingView *paintView;


/**
 * @brief 
 * 更新ReUnManager  snapimage
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)updateImageSnap;
/**
 * @brief 
 * 更新撤销和恢复按钮图片
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)updateBtnImage:(NSNotification *)notification;
/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelButtonPressed:(id)sender;

/**
 * @brief 
 * 确定按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)confirmButtonPressed:(id)sender;

/**
 * @brief 
 * redo按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)redoOperation:(id)sender;
/**
 * @brief 
 * undo按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)undoOperation:(id)sender;

/**
 * @brief 
 * 点击图片样式按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)addPaintPic:(id)sender;

/**
 * @brief 
 * 更新滑块及scrollview 的userInteraction enable
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)updateUserInteractionEnable:(NSNotification *)notification;
@end
