//
//  ColorPaletteViewController.h
//  Aico
//
//  Created by chentao on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSelectorView.h"

@protocol ColorSetDelegate <NSObject>
- (void)closeViewAndSetColorHue:(float)hue saturation:(float)sat;
- (void)setOpacity:(float)opacity;
@end
@interface ColorPaletteViewController : UIViewController
{

    UISlider                    *hueSlider_;
    UISlider                    *satSlider_;
    UISlider                    *briSlider_;
    UISlider                    *opaSlider_;
    BOOL                        satSliderHidden_;
    ColorSelectorView           *hueView_;                         //定制的view，从左到右显示着不同的hue值对应的颜色
    ColorSelectorView           *saturationView_;                  //hue和brightness一定，view上从左到右显示着不同的saturation值对应的颜色
    ColorSelectorView           *brightnessView_;                  //hue和saturation一定，view上从左到右显示着不同的brightness值对应的颜色
    float                       hue_;                              //选中颜色的hue值，范围0-360
    float                       saturation_;                       //0-1
    float                       brightness_;                       //0-255
    float                       opacity_;                          //0-1
    UIButton                    *colorButton_;
    UIView                      *currentColorView_;
    id<ColorSetDelegate>   delegate_;

}
@property(nonatomic,retain)UISlider *hueSlider;
@property(nonatomic,retain)UISlider *satSlider;
@property(nonatomic,retain)UISlider *briSlider;
@property(nonatomic,retain)UISlider *opaSlider;
@property BOOL satSliderHidden;
@property(nonatomic,assign)id<ColorSetDelegate> delegate;
- (void)setHue:(float)h saturation:(float)s brightness:(float)b opacity:(float)o;
@end
