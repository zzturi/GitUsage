//
//  PhotoEffectsViewController.h
//  Aico
//
//  Created by Jiang Liyin on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import "CircleClipView.h"
#import "ImageScrollViewController.h"
#import "GradientView.h"
#import "RectangleClipView.h"
#import "ColorPickerViewController.h"
#import "IMPopoverController.h"

@interface PhotoEffectsViewController : UIViewController<CustomSliderDelegate, DoPanDelegate,IMPopoverDelegate, ColorSelectorDelegate>
{
    UIImage *srcImage_;                               //从主界面传过来的图片           
    UIScrollView *effectImgScrollView_;               //图片滚动视图
    CustomSlider *effectSlider_;                      //滑块
    int effectType_;                                  //当前特效类型
    ImageScrollViewController *imageScrollVC_;        //图片视图
    UIActivityIndicatorView *activityIndicatorView_;  //做特效时的转圈
    
    CircleClipView *viewClip_;                        //聚光灯的圆形裁剪视图
    ImageInfo *cloneImgInfo_;                         //用srcimage初始化，并做相应特效的一部分操作
    GradientView *rainbowMaskView_;                   //彩虹特效view  
    int tag_;                                         //判断颜色选择按钮
    NSMutableArray *colorArray_;                      //双色调选择颜色数组

    RectangleClipView *rectangleView_;                //移轴的矩形裁剪视图
    
    IMPopoverController *popViewCtrl_;                //颜色块弹出窗口
    float hue_;                                       //保存色调 范围0-360                                
    float saturation_;                                //保存饱和度 范围0-1
    float bright_;                                    //保存明亮度 范围0-255
    float opacity_;                                   //保存颜色透明度的值
    BOOL chooseColorButtonPressed_;                   //判断是否曾经点击过选择颜色按钮
}
@property(nonatomic,retain) UIImage *srcImage;
@property(nonatomic,assign) int effectType;
@property(nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
/**
 * @brief 
 * 定制界面
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)customView;
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
 * 特效
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)makeEffect;


/**
 * @brief 
 * 特效结束，移除activityindicatorview
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)removeActivityIndicatorView;

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
 * clone srcImg 图片信息，并添加相应特效的一部分操作
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)cloneImgInfo;
/**
 * @brief 
 * 颜色块按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)colorBlockBtnPressed:(id)sender;

/**
 * @brief 
 * 获取当前图片：彩虹等特效是两个imageview合成的，所以必须用此方法
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIImage *)getCurrentImage;
@end
