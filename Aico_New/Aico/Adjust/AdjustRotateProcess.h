//
//  AdjustRotateProcess.h
//  Aico
//
//  Created by Yincheng on 12-3-29.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+extend.h"

@interface AdjustRotateProcess : NSObject
{
    UIImage          *srcImage_;     //旋转进行处理的图片
}
@property(nonatomic,retain) UIImage *srcImage;

/**
 * @brief 图片按度数旋转 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)RotateChangeByDegrees:(CGFloat)degree;

/**
 * @brief 图片水平翻转 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)RotateChangeByHorizontal;

/**
 * @brief 图片垂直翻转 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)RotateChangeByVertical;
@end
