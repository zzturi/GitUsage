//
//  AdjustRotateProcess.m
//  Aico
//
//  Created by Yincheng on 12-3-29.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "AdjustRotateProcess.h"

@implementation AdjustRotateProcess
@synthesize srcImage = srcImage_;


- (void)dealloc
{
    self.srcImage = nil;
    [super dealloc];
}

/**
 * @brief 图片按度数旋转 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)RotateChangeByDegrees:(CGFloat)degree
{
    UIImage *image = nil;
    image = [self.srcImage imageRotatedByDegrees:degree];
    self.srcImage = image;
}

/**
 * @brief 图片水平翻转 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)RotateChangeByHorizontal
{
    UIImage *image = nil;
    image = [Common imageRotatedFlip:self.srcImage withType:0];
    self.srcImage = [image imageRotatedByDegrees:0];
}

/**
 * @brief 图片垂直翻转 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)RotateChangeByVertical
{
    UIImage *image = nil;
    image = [Common imageRotatedFlip:self.srcImage withType:1];
    self.srcImage = [image imageRotatedByDegrees:0];
}
@end
