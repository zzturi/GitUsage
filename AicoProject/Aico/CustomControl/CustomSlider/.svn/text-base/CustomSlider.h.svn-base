//
//  CustomSlider.h
//  Aico
//
//  Created by JiangLiyin on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


///////////////////////////////////////////
//////////自定义滑块控件/////////////////////
//1.滑块默认最小值为0.0，最大值为1.0,当前值为0.0；
//2.滑块的当前值改变时会通过CustomSliderDelegate调用sliderValueChanged，
////请在使用该自定义控件时实现CustomSliderDelegate方法；
//3.控件初始化请调用- (id)initWithTarget:(id)target frame:(CGRect)rect showBkgroundImage:(BOOL)flag方法；
//4.初始化后可以通过uislider的属性设置控件属性；
//5.可以通过设置标记量isShowProgress_来确定是否显示数值，默认为yes
//6.如果isShowProgress_为yes，请在父视图消失前先调用removePopover移除显示数值的view
///////////////////////////////////////////
#import <UIKit/UIKit.h>

@protocol CustomSliderDelegate <NSObject>

@optional
/**
 * @brief 
 * 滑块值改变时调用此方法
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)sliderValueChanged:(float)value;

/**
 * @brief 
 * 当收到UIControlEventTouchUpInside | UIControlEventTouchUpOutside时调用此方法
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)sliderTouchUp;

@end

@interface CustomSlider : UIView
{
    id<CustomSliderDelegate>delegate_;         //滑块状态（包含值以及事件）改变delegate
    UISlider	*slider_;                      //滑块
	UILabel		*labelValue_;                  
    CGFloat     step_;
    UIView      *currentValueView_;            //显示当前滑块值的view
    BOOL		isShowProgress_;
	BOOL		isSetBkgroundImage_;
	
	// 显示滑块值的百分比数
	CGFloat		minimumShowPercentValue_;		// 默认为-100  -100%
	CGFloat		maximumShowPercentValue_;		// 默认为100   100%
    
    BOOL        isCurrentValueViewOnLastWindow_;
}
@property(nonatomic,retain) UISlider *slider;
@property(nonatomic,retain) UILabel *labelValue;
@property CGFloat step;
@property(nonatomic,assign) BOOL isShowProgress;
@property CGFloat minimumShowPercentValue;
@property CGFloat maximumShowPercentValue;
@property BOOL isCurrentValueViewOnLastWindow;
/**
 * @brief 
 * 初始化函数
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id)initWithTarget:(id)target frame:(CGRect)rect showBkgroundImage:(BOOL)flag;

/**
 * @brief 
 * 滑块滑动事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)sliderEventValueChanged:(id)sender;

/**
 * @brief 
 * 滑块滑动后事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)sliderTouchUp:(id)sender;

/**
 * @brief 
 * 减少按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)decreaseBtnPressed:(id)sender;
/**
 * @brief 
 * 增加按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)increaseBtnPressed:(id)sender;

/**
 * @brief 
 * 定制ui
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)customUI;

/**
 * @brief 
 * 调整滑块值显示以及位置
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)adjustValueShowAtRect:(CGRect)rect;

/**
 * @brief 
 * 移除滑块值显示
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)removePopover;
@end
