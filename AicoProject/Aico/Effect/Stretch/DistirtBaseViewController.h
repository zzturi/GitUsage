//
//  DistirtBaseViewController.h
//  Aico
//
//  Created by 操 于 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"

@class CustomSlider;

#define kEPSINON      0.00001f
#define kSliderValue  0.5f

//扭曲基类
@interface DistirtBaseViewController : UIViewController <CustomSliderDelegate>
{
    UIImage *srcImage_;                         //原图
    UIImage *destImage_;                        //目标图片
    
    unsigned char *imagePixel_;	                //图片像素
    unsigned char *destImagePixel_;             //目标图片像素
    
    CGRect imageRect_;                          //图片区域
    
    CustomSlider *slider_;		                //公共的slider
}

/**
 * @brief setSlider
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setSlider;

/**
 * @brief  Generate image from data bytes 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)GenerateImageFromData:(unsigned char *)imgPixelData 
                 withImgPixelWidth:(NSUInteger) imgPixelWidth 
                withImgPixelHeight:(NSUInteger)imgPixelHeight;

@end