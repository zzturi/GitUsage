//
//  MatteView.h
//  Aico
//
//  Created by cienet on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kColorComponentArraySize 12
@interface MatteView : UIView
{
    UIImage         *sourcePicture_;                          //原图片
    CGFloat         components[kColorComponentArraySize];                           //颜色数组
    float           radius_;                                  //边框宽度
}
@property(nonatomic,copy) UIImage *sourcePicture;
@property float radius;

/**
 * @brief 
 * 给颜色数组components[12]赋值
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setComponentsArray:(CGFloat [])array;
/**
 * @brief 
 * 生成特效列表table cell中的小图片，并返回
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (UIImage *)getSmallImage:(UIImage *)inImage;
@end
