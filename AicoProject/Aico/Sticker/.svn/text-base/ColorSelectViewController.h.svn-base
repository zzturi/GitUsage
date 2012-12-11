//
//  ColorSelectView.h
//  Aico
//
//  Created by 勇 周 on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleViewController;

@interface ColorSelectViewController : UIViewController
{
    UILabel        *labelRed_;			// 红色标签
    UILabel        *labelGreen_;		// 绿色标签
    UILabel        *labelBlue_;			// 蓝色标签
    UILabel        *labelAlpha_;		// 透明度标签
    UILabel        *labelRedValue_;		// 红色值标签
    UILabel        *labelGreenValue_;	// 绿色值标签
    UILabel        *labelBlueValue_;	// 蓝色值标签
    UILabel        *labelAlphaValue_;	// 透明度值标签
    
    UISlider       *sliderRed_;			// 红色滑动条
    UISlider       *sliderGreen_;		// 绿色滑动条
    UISlider       *sliderBlue_;		// 蓝色滑动条
    UISlider       *sliderAlpha_;		// 红色滑动条
    
    UIButton       *btnConfirm_;		// 确定按钮
    UIColor        *color_;				// 初始化slider的颜色
    int            colorType_;			// 颜色的类型
    
    TitleViewController    *vcParent_;  // 父视图
}

@property (nonatomic, retain) UILabel *labelRed;
@property (nonatomic, retain) UILabel *labelGreen;
@property (nonatomic, retain) UILabel *labelBlue;
@property (nonatomic, retain) UILabel *labelAlpha;
@property (nonatomic, retain) UILabel *labelRedValue;
@property (nonatomic, retain) UILabel *labelGreenValue;
@property (nonatomic, retain) UILabel *labelBlueValue;
@property (nonatomic, retain) UILabel *labelAlphaValue;

@property (nonatomic, retain) UISlider *sliderRed;
@property (nonatomic, retain) UISlider *sliderGreen;
@property (nonatomic, retain) UISlider *sliderBlue;
@property (nonatomic, retain) UISlider *sliderAlpha;

@property (nonatomic, retain) UIButton *btnConfirm;
@property (nonatomic, retain) UIColor *color;

- (id)initWithType:(int)type color:(UIColor *)color parentVC:(TitleViewController *)vc;
- (void)initSliderAndLabelValue;

- (void)releaseObjects;

- (IBAction)buttonPressed:(id)sender;
- (void)sliderValueChanged:(id)sender;

@end
