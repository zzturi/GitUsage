//
//  RectangleClipView.h
//  Aico
//
//  Created by  jiang liyin on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectMethods.h"
@interface RectangleClipView : UIView
{
    Rectangle rectangle_;                  //矩形的各种参数信息
    UIImageView	*viewImageDest_;		   //显示编辑图片的imageview
    ImageInfo *imageInfo_;			       //编辑图片的ImageInfo表现形式
	CGFloat	scale_;					       //图片的缩放比例
    CGPoint	ptTouchBegin_;			       //第一次按下的点的坐标
    CGFloat lastScale_;                    //UIPinchGestureRecognizer手势上次的缩放比例
    UIView  *clearView_;                   //移轴操作中清晰区域的视图
    CGFloat rotateAngle_;                  //当前矩形旋转过的角度（相对于最原始状态）
    UIImageView *blurImageView_;           //目前移轴特效有两个imageview，底下的是放原图的，上面的是显示模糊后的图片，当清晰区域调整后，将该区域内的像素点设置为透明
    ImageInfo *cloneImageInfo_;            //将原图片信息做高斯模糊处理后的图片信息
    UIViewController *superViewController_;//父视图控制器
    UIView *clearBackgroundView_;          //此视图上放置两个calayer，用来当手势触发时，显示白色蒙板，一个clearview
    CAGradientLayer  *topLayer_;           //clearview上方的蒙板层
    CAGradientLayer *bottomLayer_;         //clearview下方的蒙板层
}

@property(assign) Rectangle rectangle;
@property(nonatomic, retain) ImageInfo *imageInfo;
@property CGFloat scale;
@property(nonatomic, retain) UIView *clearView;

/**
 * @brief 初始化本view 
 *
 * @param [in] frame: view的区域
 * @param [in] pRectangle: view的清晰矩形区域
 * @param [in] imageView: 图片所在的imageview
 * @param [in] superViewController: 父视图控制器
 * @param [out]
 * @return 初始化好view
 * @note 
 */
-(id)initWithFrame:(CGRect)frame rectangle:(RectanglePtr)pRectangle imageView:(UIImageView *)imageView superController:(UIViewController *)superViewController;

/**
 * @brief 对当前的图片应用移轴效果 
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)effect;

/**
 * @brief 隐藏蒙板层
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)hidenLayer:(BOOL)hidden;
@end
