//
//  TwistHandle.h
//  Aico
//
//  Created by rongtaowu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageInfo;

@interface TwistHandle : NSObject
{
}

/**
 * @brief 球面化 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
+ (void)spherize:(ImageInfo *)inImage 
        destImage:(ImageInfo *)destImage
      CycleCenter:(CGPoint)centerPoint 
           Radius:(CGFloat)radius
       scaleRatio:(CGFloat)ratio;

/**
 * @brief  喷溅效果 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
+ (void)pinch:(ImageInfo *)inImage 
    destImage:(ImageInfo *)dstImage
  CycleCenter:(CGPoint)centerPoint 
       degree:(CGFloat)degree
     inRadius:(CGFloat)radius;
/**
 * @brief  旋转 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
+ (void)rotate:(ImageInfo *)inImage 
     destImage:(ImageInfo *)dstImage 
   CycleCenter:(CGPoint)centerPoint 
        degree:(CGFloat)degree
        radius:(CGFloat)inRadius;
@end
