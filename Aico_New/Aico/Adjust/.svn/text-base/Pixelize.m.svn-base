//
//  Pixelize.m
//  Aico
//
//  Created by Yincheng on 12-6-12.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "Pixelize.h"
#import "ImageInfo.h"

@implementation Pixelize

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) 
    {
        if (image)
        {
            pixelWidth_ = 15;
            pixelHeight_ = 15;
            pixelInfo_ = [[ImageInfo UIImageToImageInfo:image] clone];
        }
    }
    return self;
}

- (void)dealloc
{
    RELEASE_OBJECT(pixelInfo_);
    [super dealloc];
}

/**
 * @brief 获取像素化后的图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)getPixelizeImage
{
    UIImage *image = [ImageInfo ImageInfoToUIImage:pixelInfo_];
    return image;
}

- (int)choosePixelSize:(int) size
{
    int ret = 20;
    ret = (size/100)*5;
    if (ret == 0) 
    {
        ret = 2;
    }
    return ret;
}

/**
 * @brief 像素化全图 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)pixelize
{
    int width	= pixelInfo_.width;
	int height	= pixelInfo_.height;
    pixelWidth_ = [self choosePixelSize:(width+height)/2];
    pixelHeight_ = pixelWidth_;
        
    int row = width/pixelWidth_;
    int col = height/pixelHeight_;
    
    if (width%pixelWidth_ !=0) 
    {
        row += 1;
    }
    if (height%pixelHeight_ !=0) 
    {
        col += 1;
    }
    
	for (int i=0; i < col; i++)
	{
		for (int j=0; j < row; j++)
		{
            PixelCellIndex index;
            index.width = j;
            index.height = i;
            [self pixelizeCell:index];
		}
	}
}

/**
 * @brief 像素化单个网格 
 * @param [in]index:此网格在这个像素二维坐标中索引
 * @param [out]
 * @return
 * @note 
 */
- (void)pixelizeCell:(PixelCellIndex)index;
{
    int width	= pixelInfo_.width;
	int height	= pixelInfo_.height;
    int stride	= pixelInfo_.bytesPerRow;
	int bpp		= pixelInfo_.bytesPerPixel;
	unsigned char *data	= pixelInfo_.data;
    
    int col = height/pixelHeight_;
    int row = width/pixelWidth_;
    
    int average[] = {0,0,0,0};//进行RGBA调节
    
    int nh = pixelHeight_;
    int nw = pixelWidth_;
    
    unsigned char *newData = data + stride * index.height * pixelHeight_ + index.width * pixelWidth_ * bpp;
    
    //部分区域
    if (index.width == row) 
    {
        nw = width % pixelWidth_; 
    }
    if (index.height == col) 
    {
        nh = height % pixelHeight_;
    }
    
    //获取像素平均值
    for (int i=0; i<nh; i++) 
    {
        unsigned char *newBmpData = newData;
        for (int j=0; j<nw; j++)
        {
            //average
            for (int k=0; k<sizeof(average)/sizeof(average[0]); k++) 
            {
                average[k] += (int)newBmpData[k];
            }
            newBmpData += bpp;
        }
        newData += stride;
    }
    
    newData = data + stride * index.height * pixelHeight_ + index.width * pixelWidth_ * bpp;
    //像素处理
    for (int i=0; i<nh; i++) 
    {
        unsigned char *newBmpData = newData;
        for (int j=0; j<nw; j++)
        {
            //average
            for (int k=0; k<sizeof(average)/sizeof(average[0]); k++)
            {
                newBmpData[k] = average[k]/(nh*nw);
            }
            newBmpData += bpp;
        }
        newData += stride;
    }
}
@end
