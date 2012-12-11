//
//  MatteViewController.h
//  Aico
//
//  Created by cienet on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//特效－淡化边缘
#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import "ColorPickerViewController.h"
#import "IMPopoverController.h"

@class ImageScrollViewController;
@class MatteView;
@class ColorSelectorView;

@interface MatteViewController : UIViewController<CustomSliderDelegate,IMPopoverDelegate,ColorSelectorDelegate>
{
    UIImage                     *sourcePicture_;                   //要处理的源图
    MatteView                   *matteView_;                       //界面上显示的图片所在的定制view
    float                       hue_;                              //选中颜色的hue值，范围0-360
    float                       saturation_;                       //0-1
    float                       brightness_;                       //0-255
    float                       opacity_;                          //0-1
    float                       shortEdgeLength_;                  //source picture的短边长度
    CustomSlider                *effectSlider_;                    //滑块
    ImageScrollViewController   *imageScrollVC_;                   //图片视图
    IMPopoverController         *popoverViewCntroller_;            //弹出视图
    UIActivityIndicatorView     *activityIndicatorView_;           //做特效时的转圈
    BOOL                        chooseColorButtonPressed_;         //判断是否曾经点击过选择颜色按钮
}
@property(nonatomic,copy) UIImage *sourcePicture;
@property(nonatomic,retain) MatteView *matteView;
@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
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
