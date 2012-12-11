//
//  TopLensFilterAndEdgeLensFilterViewController.h
//  Aico
//
//  Created by cienet on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSelectorView.h"
#import "TopLensFilterAndEdgeLensFilterProcess.h"
#import "CustomSlider.h"
#import "IMPopoverController.h"
#import "ColorPickerViewController.h"

@class ImageScrollViewController;

@interface TopLensFilterAndEdgeLensFilterViewController : UIViewController<CustomSliderDelegate,IMPopoverDelegate,ColorSelectorDelegate>
{
    UIImage                                 *sourcePicture_;                //原图片
    UIImageView                             *currentImageView_;             //原图片所在的imageview
    float                                   hue_;                           //0-360      
    float                                   brightness_;                    //0-255
    float                                   opacity_;                       //0-1
    float                                   heightRatio_;                   //滤镜高度占图片高度的比例
    BOOL                                    isFromTopLensFilter_;           //判断是否显示的是最高滤镜页面
    TopLensFilterAndEdgeLensFilterProcess   *filterProcess_;                //滤镜处理类
    CustomSlider                            *effectSlider_;                 //滑块
    ImageScrollViewController               *imageScrollVC_;                //图片视图
    IMPopoverController                     *popoverViewCntroller_;         //弹出视图
    UIActivityIndicatorView                 *activityIndicatorView_;        //做特效时的转圈
    BOOL                                    chooseColorButtonPressed_;      //判断是否曾经点击过选择颜色按钮
}
@property(nonatomic,copy) UIImage *sourcePicture;
@property(nonatomic,retain) UIImageView *currentImageView;
@property BOOL isFromTopLensFilter;
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
