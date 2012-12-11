//
//  ColorEffectsViewController.h
//  Aico
//
//  Created by zhou yong on 3/29/12.
//  Copyright 2012 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import "ColorEffectsCommon.h"

@class ImageScrollViewController;
@class ImageInfo;

@interface ColorEffectsViewController : UIViewController
{
	ImageScrollViewController  *vcImage_;           // 显示要处理图片的视图
	UIImageView                *imageViewSlider_;   // 只用于显示统一背景
	CustomSlider               *slider_;			// 公共的slider
	CustomSlider               *sliderRed_;         // 当是RGB调节时，需要3个slider，红色
	CustomSlider               *sliderGreen_;		// 当是RGB调节时，需要3个slider，绿色
    UILabel                    *labelRedTag_;		// 当是RGB调节时,显示“红”色标签
    UILabel                    *labelGreenTag_;		// 当是RGB调节时,显示“绿”色标签
    UILabel                    *labelBlueTag_;		// 当是RGB调节时,显示“蓝”色标签
	UILabel                    *labelRedValue_;		// 当是RGB调节时,显示“红”色值
    UILabel                    *labelGreenValue_;	// 当是RGB调节时,显示“蓝”色值
    UILabel                    *labelBlueValue_;	// 当是RGB调节时,显示“蓝”色值
	int                        effectType_;			// 特效的类型
	NSString                   *strEffectType_;		// 特效的类型字符串表示
	ImageInfo                  *imageInfo_;			// 当前编辑的图片数据
    UIActivityIndicatorView    *activityIndicatorView_;  //做特效时的转圈
    ImageInfo                  *imageEdge;          // 锐化处理第一步边缘检测后图片
}

@property(nonatomic, retain) ImageScrollViewController *vcImage;
@property(nonatomic, retain) IBOutlet UIImageView *imageViewSlider;
@property(nonatomic, retain) CustomSlider *slider;
@property(nonatomic, copy) NSString *strEffectType;
@property int effectType;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

/**
 * @brief 当特效是RGB调节时，需要初始化显示RGB信息的标签 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initLabels;

/**
 * @brief 初始化导航栏上的功能按钮 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initButtons;

/**
 * @brief 获取显示图片的imageview 
 *
 * @param [in]
 * @param [out]
 * @return 显示图片的imageview
 * @note 
 */
- (UIImageView *)getImageView;

/**
 * @brief 获取scrollview中显示图片的imageview 
 *
 * @param [in] 将要显示的新的图片对象
 * @param [out]
 * @return 
 * @note 
 */
- (void)setImage:(UIImage *)image;

/**
 * @brief 点击导航栏上的取消按钮 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelButtonPressed;

/**
 * @brief 点击导航栏上的确定按钮 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)confirmButtonPressed;

/**
 * @brief 当特效是RGB调节时，实时显示滑块的值
 *
 * @param [in] number: 显示的值
 * @param [in] sender: 移动的滑块对象
 * @param [out] 
 * @return
 * @note 
 */
- (void)customSliderValueChanged:(NSNumber *)number sender:(id)sender;

@end

