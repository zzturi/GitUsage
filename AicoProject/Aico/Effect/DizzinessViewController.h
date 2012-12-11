//
//  DizzinessViewController.h
//  Aico
//
//  Created by cienet on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//特效－镜头模糊
#import <UIKit/UIKit.h>
#import "CustomSlider.h"

@class ImageScrollViewController;

@interface DizzinessViewController : UIViewController<CustomSliderDelegate>
{
    UIImage                     *sourcePicture_;                //原图片
    UIImageView                 *currentImageView_;             //原图片所在的imageview 
    UIImageView                 *movedImageView_;               //上层半透明的可以移动的图片
    float                       moveWidth_;                     //允许移动的最大宽度
    float                       moveHeight_;                    //允许移动的最大高度
    CGPoint                     center_;                        //movedImageView_的center坐标
    CustomSlider                *effectSlider_;                 //滑块
    ImageScrollViewController   *imageScrollVC_;                //scroll view，图片可以缩放
}
@property(nonatomic,copy) UIImage *sourcePicture;
@property(nonatomic,retain) UIImageView *currentImageView;
@property(nonatomic,retain) UIImageView *movedImageView;
/**
 * @brief 
 * 生成特效列表cell中的缩略图
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (UIImage *)getSmallImage:(UIImage *)inImage;
@end
