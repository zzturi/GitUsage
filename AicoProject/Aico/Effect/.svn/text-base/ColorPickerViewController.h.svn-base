//
//  ColorPickerViewController.h
//  Aico
//
//  Created by cienet on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColorSelectorView;

@protocol ColorSelectorDelegate <NSObject>
- (void)closeViewAndSetColorHue:(float)hue 
                     saturation:(float)sat
                     brightness:(float)bri 
                        opacity:(float)opa;
@end

enum EFromViewControllerID 
{
    ETopLensFilterViewControllerID = 2451,              //上滤镜
    EEdgeLensFilterViewControllerID,                    //边框滤镜
    EMatteViewControllerID,                             //淡化边缘
    EVegnetteViewControllerID,                          //边缘模糊
    ENeonViewControllerID,                              //霓虹灯
    EDuoToneViewControllerID                            //双色调
}; 
enum EHSBOID 
{
    EHueID,
    ESaturationID,
    EBrightnessID,
    EOpoacity
};
@interface ColorPickerViewController : UIViewController
{
    UISlider                    *hueSlider_;                       //色调选择滑块
    UISlider                    *satSlider_;                       //饱和度
    UISlider                    *briSlider_;                       //亮度
    UISlider                    *opaSlider_;                       //透明度
    UIImageView                 *hueView_;                         //长条形图片,从左到右分别对应着红橙黄绿青蓝紫红.
    ColorSelectorView           *saturationView_;                  //hue和brightness一定，view上从左到右显示着不同的saturation值对应的颜色
    ColorSelectorView           *brightnessView_;                  //hue和saturation一定，view上从左到右显示着不同的brightness值对应的颜色
    float                       hue_;                              //选中颜色的hue值，范围0-360
    float                       saturation_;                       //0-1
    float                       brightness_;                       //0-255
    float                       opacity_;                          //0-1
    UIButton                    *colorButton_;                     //确定选择的颜色
    UIView                      *currentColorView_;                //用于显示当前选定的颜色
    id<ColorSelectorDelegate>   delegate_;
    int                         fromViewControllerID_;             //判断哪个页面用到了ColorPickerViewController
    
    UILabel *hueLabel_;                                            //显示hue字样的label,以下类似
    UILabel *hueValue_;                                            //显示对应的hue值,下面类似
    UILabel *satLabel_;
    UILabel *satValue_;
    UILabel *briLabel_;
    UILabel *briValue_;
    UILabel *opaLabel_;
    UILabel *opaValue_;
}
@property(nonatomic,retain) UISlider *hueSlider;
@property(nonatomic,retain) UISlider *satSlider;
@property(nonatomic,retain) UISlider *briSlider;
@property(nonatomic,retain) UISlider *opaSlider;
@property(nonatomic,assign) id<ColorSelectorDelegate> delegate;
@property int fromViewControllerID;
/**
 * @brief s
 * 设置要显示的颜色
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setHue:(float)h 
    saturation:(float)s 
    brightness:(float)b 
       opacity:(float)o;
/**
 * @brief 
 * 设置label's frame
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setLabelwithID:(enum EHSBOID)ID withFrame:(CGRect)referenceFrame;

/**
 * @brief 
 * 设置隐藏某些颜色条
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setHueHidden:(BOOL)hueShouldHide 
    saturationHidden:(BOOL)saturationShouldHide
    brightnessHidden:(BOOL)brightnessShouldHide 
             opacity:(BOOL)opacityShouldHide;
/**
 * @brief 
 * 设置弹出窗口的背景
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setPopwindowBackground;
@end
