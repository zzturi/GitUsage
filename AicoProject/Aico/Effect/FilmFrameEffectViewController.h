//
//  FilmFrameEffectViewController.h
//  Aico
//
//  Created by wang cuicui on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomSlider.h"

@class ImageScrollViewController;
@interface FilmFrameEffectViewController : UIViewController <UIScrollViewDelegate>
{
    UIImage       *frameImage_;               //边框
    UIImage       *sourceImage_;              //保留原图像  在更改边框时使用
    UIButton      *simpleFrameButton_;        //简单边框
    UIButton      *colorfulFrameButton_;      //炫彩边框
    UIImageView   *frameEffectImage_;         //图片视图
    UIScrollView  *frameEffectScrollView_;    // 图片简单边框效果选择栏
    UIScrollView  *frameColorScollView_;      //炫彩边框效果选择
    int effectType_;                          //当前特效类型
    ImageScrollViewController *imageScrollVC_;//图片视图
} 

@property (nonatomic, copy)   UIImage     *frameImage;
@property (nonatomic, copy)   UIImage     *sourceImage;
@property (nonatomic, retain) UIButton    *simpleFrameButton;
@property (nonatomic, retain) UIButton    *colorfulFrameButton;
@property (nonatomic, retain) UIImageView *frameEffectImage;
@property (nonatomic, retain) IBOutlet UIScrollView *frameEffectScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *frameColorScollView;
@property (nonatomic, assign) int       effectType;

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
 * 简单边框按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)simpleFrameButtonPressed:(id)sender;
/**
 * @brief 
 * 绚彩边框按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)colorfulFrameButtonPressed:(id)sender;
/**
 * @brief 
 * 合成过程
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)makeFrameEffect;
/**
 * @brief  将图片和边框合成一张图片。
 *
 * @param [in]  边框的名称
 * @param [out] 合并后的图片 
 * @return　　  
 * @note
 */
- (void) mergeImage:(NSString *)frameName;
/**
 * @brief  清除图片的边框效果
 *
 * @param [in]  
 * @param [out] 
 * @return　　   
 * @note
 */
- (void) clearBorderColor; 
/**
 * @brief 存放边框按钮名称的Label的属性设置。
 * 
 * @param [in] 图片的效果数imgEffectNum，图片特效或者加边框imgEffectScrollView,图片各个效果名称imgEffectName。
 * @param [out] 设置好属性的Label。
 * @return
 * @note
 */
- (void) labelPropertySetting: (NSInteger)imgEffectNum: (UIScrollView *)imgEffectScrollView: (NSArray *)imgEffectName; 
/**
 * @brief 边框按钮的图片，选中与未选中图片。
 * 点击TabBar中的边框项，弹出的view中包含五个边框。
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) buttonInFrameScrollView; 
/**
 * @brief 照片加边框处理
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)imageFrame:(id)sender;
/**
 * @brief  改变简单边框按钮和炫彩边框按钮的字体和背景
 *
 * @param [in]  
 * @param [out] 
 * @return　　   
 * @note
 */
- (void) changeButtonStringAndBackGround;
@end
