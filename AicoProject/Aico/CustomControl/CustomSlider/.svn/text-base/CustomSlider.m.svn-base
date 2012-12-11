//
//  CustomSlider.m
//  Aico
//
//  Created by Jiang Liyin on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CustomSlider.h"
#import "UIColor+extend.h"

#define kSliderValueTipViewWidth	        70
#define kSliderValueTipViewHeight	        41
#define kEffectAdjustButtonPaddingX         5
#define kEffectAdjustButtonPaddingY         12
#define kEffectAdjustButtonSize             24

@implementation CustomSlider
@synthesize slider		= slider_;
@synthesize labelValue	= labelValue_;
@synthesize step        = step_;
@synthesize isShowProgress = isShowProgress_;
@synthesize minimumShowPercentValue = minimumShowPercentValue_;
@synthesize maximumShowPercentValue = maximumShowPercentValue_;
@synthesize isCurrentValueViewOnLastWindow = isCurrentValueViewOnLastWindow_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.slider = nil;
	self.labelValue = nil;
    delegate_ = nil;
    RELEASE_OBJECT(currentValueView_);
    [self removePopover];
    [super dealloc];
}
/**
 * @brief 
 * 初始化函数
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id) initWithTarget:(id)target frame:(CGRect)rect showBkgroundImage:(BOOL)flag
{
    self = [super init];
    if (self != nil) {
        delegate_ = target;
        self.frame = rect;
		step_ = 0.01f;
        isShowProgress_ = YES;
		isSetBkgroundImage_ = flag;
		minimumShowPercentValue_ = -100.0f;
		maximumShowPercentValue_ = 100.0f;
        self.isCurrentValueViewOnLastWindow = YES;
        [self customUI];
    }
    return  self;
}

// 当没有显示滑块视图的预览框显示时能进行其他一些操作
- (void)checkAndPerformCustomSelecter:(id)sender
{
    if ([delegate_ respondsToSelector:@selector(customSliderValueChanged:sender:)])
    {
        [delegate_ performSelector:@selector(customSliderValueChanged:sender:) withObject:[NSNumber numberWithFloat:self.slider.value] withObject:sender];
    }
}

/**
 * @brief 
 * 滑块滑动事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)sliderEventValueChanged:(id)sender
{
    if (isShowProgress_)
    {
        //调整滑块值显示
        CGRect senderFrame = ((UISlider *)sender).frame;
        [self adjustValueShowAtRect:senderFrame];
    }
    else
    {
        [self checkAndPerformCustomSelecter:sender];
    }

}

/**
 * @brief 
 * 滑块滑动后事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)sliderTouchUp:(id)sender
{
    if ([delegate_ respondsToSelector:@selector(sliderValueChanged:)])
    {
        [delegate_ sliderValueChanged:self.slider.value];
        if ([delegate_ respondsToSelector:@selector(sliderTouchUp)]) 
        {
            [delegate_ sliderTouchUp];
        }

    }
    
}
/**
 * @brief 
 * 减少按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)decreaseBtnPressed:(id)sender
{
    //只有slider当前值大于最小值时才能减少
    if (self.slider.value > self.slider.minimumValue)
    {
        float value = self.slider.value;
        self.slider.value = value - step_;
        
        if (isShowProgress_)
        {
            //调整滑块值显示
            CGRect senderFrame = self.slider.frame;
            [self adjustValueShowAtRect:senderFrame];
        }
        else
        {
            [self checkAndPerformCustomSelecter:slider_];
        }
        
        [self sliderTouchUp:nil];
    }
}
/**
 * @brief 
 * 增加按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)increaseBtnPressed:(id)sender
{
    //只有slider当前值小于最大值时才能增加
    if (self.slider.value < self.slider.maximumValue)
    {
        float value = self.slider.value;
        self.slider.value = value + step_;
        
        if (isShowProgress_)
        {
            //调整滑块值显示
            CGRect senderFrame = self.slider.frame;
            [self adjustValueShowAtRect:senderFrame];
        }
        else
        {
            [self checkAndPerformCustomSelecter:slider_];
        }
        
        [self sliderTouchUp:nil];
    }
}

/**
 * @brief 
 * 定制ui
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)customUI
{
    CGFloat width = self.frame.size.width;
    
    //todo 添加背景图片
	if (isSetBkgroundImage_)
	{
		self.backgroundColor = [UIColor clearColor];
        UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backgroundImgView.image = [UIImage imageNamed:@"blackTopBar.png"];
        [self addSubview:backgroundImgView];
        [self sendSubviewToBack:backgroundImgView];
        [backgroundImgView release];

	}
    
    //添加“－”按钮
    UIButton *decreaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(kEffectAdjustButtonPaddingX, kEffectAdjustButtonPaddingY, kEffectAdjustButtonSize, kEffectAdjustButtonSize)];
    [decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decrease.png"] forState:UIControlStateNormal];
    [decreaseBtn addTarget:self action:@selector(decreaseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:decreaseBtn];
    [decreaseBtn release];
    
    
    //添加“+”按钮
    CGFloat originX = width - kEffectAdjustButtonPaddingX - kEffectAdjustButtonSize;
    UIButton *increaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(originX, kEffectAdjustButtonPaddingY, kEffectAdjustButtonSize, kEffectAdjustButtonSize)];
    [increaseBtn setBackgroundImage:[UIImage imageNamed:@"increase.png"] forState:UIControlStateNormal];
    [increaseBtn addTarget:self action:@selector(increaseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:increaseBtn];
    [increaseBtn release];
    
    //添加滑块
    originX = kEffectAdjustButtonPaddingX + kEffectAdjustButtonSize;
    CGFloat sliderWidth = width - 2 * originX - 16;
    slider_ = [[UISlider alloc] initWithFrame:CGRectMake(originX + 8, kEffectAdjustButtonPaddingY, sliderWidth, kEffectAdjustButtonSize)];
    [slider_ addTarget:self action:@selector(sliderEventValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider_ addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    slider_.minimumValue = kSliderValue1;
    slider_.maximumValue = kSliderValue2;
    slider_.value = kSliderValue1;
    slider_.backgroundColor = [UIColor clearColor];
    [slider_ setThumbImage:[UIImage imageNamed:@"thunder.png"] forState:UIControlStateNormal];
    UIImage *minImage = [UIImage imageNamed:@"sliderHighLightBkg.png"];
    minImage = [minImage stretchableImageWithLeftCapWidth:minImage.size.width/2 topCapHeight:minImage.size.height/2];
    [slider_ setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [slider_ setMaximumTrackImage:[UIImage imageNamed:@"sliderNormalBkg.png"] forState:UIControlStateNormal];
    [self addSubview:slider_];
    
}

 // override point. called by layoutIfNeeded automatically.
- (void)layoutSubviews
{
    [self adjustValueShowAtRect:self.slider.frame];
}

/**
 * @brief 
 * 调整滑块值显示以及位置
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)adjustValueShowAtRect:(CGRect)rect
{
    if (!isShowProgress_) 
    {
        return;
    }
	
	CGRect sliderFrame = slider_.frame;
	
	CGFloat value = slider_.value;
	CGFloat distance = fabs(slider_.maximumValue - slider_.minimumValue);
	CGFloat halfValue = (slider_.minimumValue + slider_.maximumValue) / 2.0f;
    CGFloat showPercentValue;	// 浮动窗口上显示的值
    showPercentValue = (value - slider_.minimumValue) / distance * fabs(maximumShowPercentValue_ - minimumShowPercentValue_) + minimumShowPercentValue_;
        
	CGFloat currentPercent = fabs(value - slider_.minimumValue)  / distance;
	CGFloat offsetX = (sliderFrame.size.width * currentPercent) + sliderFrame.origin.x - kSliderValueTipViewWidth / 2.0f;
	
	UIImage* image = [slider_ thumbImageForState:UIControlStateNormal];
	offsetX -= image.size.width * (value - halfValue) / distance;	// image.size.width * 0.5f * fabs(value - halfValue) / distance * 2.0f 的简化
	
    if (currentValueView_ == nil)
    {
        // 添加显示slider值的标签
        labelValue_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSliderValueTipViewWidth, kSliderValueTipViewHeight - 5)];
        labelValue_.backgroundColor = [UIColor clearColor];
        labelValue_.textAlignment = UITextAlignmentCenter;
        labelValue_.textColor = [UIColor getColor:kSliderValueFontColor];
        labelValue_.font = [UIFont systemFontOfSize:kSliderValueFontSize];
        
        currentValueView_ = [[UIView alloc] initWithFrame:CGRectMake(offsetX, self.frame.origin.y - kSliderValueTipViewHeight +14, kSliderValueTipViewWidth, kSliderValueTipViewHeight)];
        currentValueView_.tag = kSliderValueShowViewTag;
        UIImageView *backgroundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSliderValueTipViewWidth, kSliderValueTipViewHeight)];
        backgroundImgView.image = [UIImage imageNamed:@"sliderValue.png"];
        [currentValueView_ addSubview:backgroundImgView];
        [currentValueView_ sendSubviewToBack:backgroundImgView];
        [backgroundImgView release];
        [currentValueView_ addSubview:labelValue_];
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:currentValueView_];
    }
//    UIWindow *lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    UIWindow *lastWindow = nil;
    if (isCurrentValueViewOnLastWindow_)
    {
        lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    }
    else 
    {
        int count = [[[UIApplication sharedApplication]windows] count];
        lastWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:count-2];
    }
    UIView *currValueView = nil;
    for (UIView *obj in [lastWindow subviews])
    {
        if (obj.tag == kSliderValueShowViewTag) 
        {
            currValueView = obj;
        }
    }
	showPercentValue += (showPercentValue < 0 ?-0.5f:0.5f);
	labelValue_.text = [NSString stringWithFormat:@"%d%@",(int)showPercentValue,@"%"];
    //防止出现－0％的问题
    if ([labelValue_.text isEqualToString:@"-0%"])
    {
        labelValue_.text = @"0%";
    }
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect newRect = CGRectMake(offsetX, self.frame.origin.y - kSliderValueTipViewHeight+14, kSliderValueTipViewWidth, kSliderValueTipViewHeight);
    [currValueView setFrame:newRect];
    [UIView commitAnimations];
}

/**
 * @brief 
 * 移除滑块值显示
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)removePopover
{
    //    UIWindow *lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    UIWindow *lastWindow = nil;
    if (isCurrentValueViewOnLastWindow_)
    {
        lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    }
    else 
    {
        int count = [[[UIApplication sharedApplication]windows] count];
        lastWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:count-2];
    }
    
    for (UIView *obj in [lastWindow subviews])
    {
        if (obj.tag == 675) 
        {
            [obj removeFromSuperview];
            break;
        }
    }
}
@end
