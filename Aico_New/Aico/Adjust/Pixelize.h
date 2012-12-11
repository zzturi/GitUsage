//
//  Pixelize.h
//  Aico
//
//  Created by Yincheng on 12-6-12.
//  Copyright (c) 2012年  . All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageInfo;
@interface Pixelize : NSObject
{
    int pixelWidth_;
    int pixelHeight_;
    
    ImageInfo *pixelInfo_;
}

- (id)initWithImage:(UIImage *)image;

/**
 * @brief 获取像素化后的图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)getPixelizeImage;

/**
 * @brief 像素化全图 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)pixelize;

/**
 * @brief 像素化单个网格 
 * @param [in]index:此网格在这个像素二维坐标中索引
 * @param [out]
 * @return
 * @note 
 */
- (void)pixelizeCell:(PixelCellIndex)index;

@end
