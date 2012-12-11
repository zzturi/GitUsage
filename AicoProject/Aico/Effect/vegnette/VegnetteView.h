//
//  VegnetteView.h
//  Aico
//
//  Created by chentao on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VegnetteView : UIView
{
    UIImage *srcImg_;             // 原图片
    float radius_;                // 半径
    float endRadius_;             // 最大半径 
    float opacityValue_;          // 透明度
    
}
@property(nonatomic,retain) UIImage *srcImg;
@property(nonatomic,assign) float radius;
@property(nonatomic,assign) float opacityValue;
/**
 * @brief 
 * 生成特效列表界面的小图片
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIImage *)getEffectSmallImage:(UIImage *)img;
@end
