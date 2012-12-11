//
//  TitleEditViewController.h
//  Aico
//
//  Created by 勇 周 on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXButton;
@class TitleViewController;

enum PositionTypeOfPointInRect
{
	PositionTypeOfPointInRectTopLeft = 0,
	PositionTypeOfPointInRectLeft,
	PositionTypeOfPointInRectBottomLeft,
    
    PositionTypeOfPointInRectTop,
    PositionTypeOfPointInRectIn,
	PositionTypeOfPointInRectBottom,
    
    PositionTypeOfPointInRectTopRight,
    PositionTypeOfPointInRectRight,
    PositionTypeOfPointInRectBottomRight,
};

@interface TitleEditViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    UIImageView			*imageView_;            // 显示原始图片
	UIImageView			*imageViewRotate_;      // 显示的旋转图钉
    NSMutableArray		*arrViewTag_;			// 页面所有文字视图的tag标记 从8000开始
	UIView				*viewCurrentEdit_;		// 当前正在编辑的是哪个字体视图
	TitleViewController	*vcParent_;				// 记录当前的父view controller
	CGPoint				ptLast_;				// 记录上一次触摸的点的坐标
    CGPoint				ptFirst_;				// 记录第一次触摸的点的坐标
}

@property (nonatomic, assign) UIView* viewCurrentEdit;

/**
 * @brief 初始化自己，给定父viewcontroller 
 *
 * @param [in] vcParent: 父viewcontroller
 * @param [out]
 * @return 
 * @note 
 */
- (id)initWithParentViewController:(TitleViewController *)vcParent;

/**
 * @brief 初始化导航栏上的button
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)initNavigatinBarButtons;

/**
 * @brief 点击导航栏上的confirm按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)confirmButtonPressed;

/**
 * @brief 点击导航栏上的back按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)backButtonPressed;

/**
 * @brief 动态重置控制字体缩放和旋转的按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)resetRotatoButtonCenter;

/**
 * @brief 初始化文字，或者是编辑文字
 *
 * @param [in] title: 将要处理的视图
 * @param [in] tag: 视图的标记
 * @param [in] type: 处理的类型: 添加或编辑
 * @param [out]
 * @return 
 * @note 
 */
- (void)addTitle:(FXButton *)title tag:(NSInteger)tag operateType:(int)type;

/**
 * @brief 长按手势
 *
 * @param [in] recognizer: 手势识别器
 * @param [out]
 * @return 
 * @note 
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer;

/**
 * @brief 切换后台进行保存当前图片
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateImageSnap;

/**
 * @brief 合成最终图像
 *
 * @param [in] 
 * @param [out]
 * @return 合成后的图片
 * @note 
 */
- (UIImage *)mergeImage;

/**
 * @brief 获取指定点在指定矩形区域内的位置
 *
 * @param [in] rect: 指定区域
 * @param [in] pt: 指定位置
 * @param [out]
 * @return 位置标记
 * @note 
 */
- (int)getPointPositionOfRect:(CGRect)rect point:(CGPoint)pt;

@end
