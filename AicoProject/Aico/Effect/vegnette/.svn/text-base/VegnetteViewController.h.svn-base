//
//  VegnetteViewController.h
//  Aico
//
//  Created by chentao on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import "ImageScrollViewController.h"
#import "IMPopoverController.h"
#import "ColorPickerViewController.h"
#import "VegnetteView.h"

@interface VegnetteViewController : UIViewController <IMPopoverDelegate, ColorSelectorDelegate, CustomSliderDelegate>
{
    UIImage *srcImage_;                                            // 原图片
    CustomSlider *effectSlider_;                                   // 滑块
    ImageScrollViewController *imageScrollVC_;                     // 图片视图
    UIActivityIndicatorView   *activityIndicatorView_;             // 做特效时的转圈    
    IMPopoverController *popViewCtrl_;                             // 弹出窗口    
    VegnetteView *vegnetteView_;                                   // 显示图片View
    float radiusMin_;                                              // 最小半径
    float radiusMax_;                                              // 最大半径
    float opacity_;                                                // 保存设置透明度的值
    UIButton *colorBtn_;                                           // 颜色块按钮
    BOOL chooseColorButtonPressed_;                                // 判断是否曾经点击过选择透明度按钮
}
@property(nonatomic,retain)UIImage *srcImage;
@property(nonatomic,retain)VegnetteView *vegnetteView;
@property(nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;
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
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelButtonPressed:(id)sender;
/**
 * @brief 
 * 点击透明块按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)colorBtnPressed:(id)sender;
/**
 * @brief 
 * 特效开始，添加activityindicatorview
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)addActivityIndicatorView;
/**
 * @brief 
 * 特效结束，移除activityindicatorview
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)removeActivityIndicatorView;
@end
