//
//  UIImageInfo.m
//  Aico
//
//  Created by zhou yong on 3/30/12.
//  Copyright 2012 cienet. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo

@synthesize data				= data_;
@synthesize width				= width_;
@synthesize height				= height_;
@synthesize bitsPerComponent	= bitsPerComponent_;
@synthesize bytesPerPixel		= bytesPerPixel_;
@synthesize bytesPerRow			= bytesPerRow_;

/**
 * @brief 检验ImageInfo内的数据成员是否都是有效的值 
 *
 * @param [in]
 * @param [out]
 * @return 有效返回YES, 无效返回NO
 * @note 
 */
- (BOOL)isValid
{
	if (data_ == NULL)
	{
		NSLog(@"ImageInfo data Invalid!");
		return NO;
	}
	if (width_ <= 0)
	{
		NSLog(@"ImageInfo width Invalid!");
		return NO;
	}
	if (height_ <= 0)
	{
		NSLog(@"ImageInfo height Invalid!");
		return NO;
	}
	if (bitsPerComponent_ <= 0)
	{
		NSLog(@"ImageInfo bitsPerComponent Invalid!");
		return NO;
	}
	if (bytesPerPixel_ <= 0)
	{
		NSLog(@"ImageInfo bytesPerPixel Invalid!");
		return NO;
	}
	if (bytesPerRow_ <= 0)
	{
		NSLog(@"ImageInfo bytesPerRow Invalid!");
		return NO;
	}
	return YES;
}

/**
 * @brief 克隆一个新的ImageInfo对象 
 *
 * @param [in]
 * @param [out]
 * @return 新的对象
 * @note 新的对象需要自己手动释放
 */
- (ImageInfo *)clone
{
	size_t bytes = bytesPerRow_ * height_;
	unsigned char *newData = malloc(bytes);
	if (newData == NULL)
	{
		NSLog(@"ImageInfo clone failed!");
		return nil;
	}
	memcpy(newData, data_, bytes);
	
	ImageInfo *info = [[ImageInfo alloc] init];
	info.data = newData;
	info.width = width_;
	info.height = height_;
	info.bitsPerComponent = bitsPerComponent_;
	info.bytesPerPixel = bytesPerPixel_;
	info.bytesPerRow = bytesPerRow_;
	return info;
}

- (void)dealloc
{
	if (data_ != NULL)
	{
		free(data_);
		data_ = NULL;
	}
	[super dealloc];
}

/**
 * @brief 将一个UIImage的数据格式转换成ImageInfo的数据格式 
 *
 * @param [in] image: 被转换的UIImage对象
 * @param [out] 
 * @return 需要的ImageInfo的对象
 * @note 
 */
+ (ImageInfo *)UIImageToImageInfo:(UIImage *)image
{
	CGImageRef imageRef = image.CGImage;
	size_t width			= CGImageGetWidth(imageRef);
	size_t height			= CGImageGetHeight(imageRef);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
	size_t bitsPerPixel		= 32;//CGImageGetBitsPerPixel(imageRef);
	size_t bytesPerRow		= width * bitsPerPixel / 8;//CGImageGetBytesPerRow(imageRef); 
	
	ImageInfo *info = [[[ImageInfo alloc] init] autorelease];
	info.width = width;
	info.height = height;
	info.bitsPerComponent = bitsPerComponent;
	info.bytesPerPixel = bitsPerPixel / 8;
	info.bytesPerRow = bytesPerRow;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) 
	{
		NSLog(@"Error allocating color space!"); 
        return nil;
	}

	// ios4.2以上支持第一个参数为NULL,否则就要自己分配内存，并且要自己在合适的时候释放
	CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
	if (context == NULL) 
	{
		CGColorSpaceRelease(colorSpace);
		NSLog(@"Context not created!");
		return nil;
	}
	CGColorSpaceRelease(colorSpace);
	
	CGRect rect = {{0,0},{width, height}};
	CGContextDrawImage(context, rect, imageRef);
	
	unsigned char *dataBitmap = CGBitmapContextGetData(context);
	size_t totalBytes = bytesPerRow * height;
	info.data = malloc(totalBytes);
	memcpy(info.data, dataBitmap, totalBytes); 
	CGContextRelease(context);
	
	return info;
}

/**
 * @brief 将一个ImageInfo的数据格式转换成UIImage的数据格式 
 *
 * @param [in] info: 被转换的ImageInfo对象
 * @param [out] 
 * @return 需要的UIImage的对象
 * @note 
 */
+ (UIImage *)ImageInfoToUIImage:(ImageInfo *)info 
{
	if (![info isValid])
	{
		NSLog(@"input param(info) invalid!");
		return NO;
	}
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(info.data, info.width, info.height, info.bitsPerComponent, info.bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *image = [UIImage imageWithCGImage:imageRef];
	
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	return image;
}

/**
 * @brief 获取指定行的图片数据的内存地址 
 *
 * @param [in] line: 指定的行
 * @param [out] 
 * @return 数据的内存首地址
 * @note 
 */
- (unsigned char *)getRowWithLine:(int)line;
{
	assert(line >=0 && line < height_);
	return data_ + line * bytesPerRow_;
}

/**
 * @brief 更新指定行的图片数据 
 *
 * @param [out] col: 接受图片数据的内存区域
 * @param [in] line: 指定行
 * @return 
 * @note 
 */
- (void)getColumnWithColomn:(unsigned char *)col Withline:(int)line
{
	assert(line >=0 && line < width_);
	assert(col);
	unsigned char *currentCol = col;
	for (int i = 0 ; i < height_; ++i)
	{
		memcpy(currentCol,data_ + i * bytesPerRow_ + line * bytesPerPixel_,bytesPerPixel_);
		currentCol += bytesPerPixel_;
	}
}

/**
 * @brief 设置指定行的图片数据 
 *
 * @param [in] col: 新的图片数据的内存区域
 * @param [in] line: 指定行
 * @return 
 * @note 
 */
- (void)setColumnWithColumn:(unsigned char *)col WithLine:(int)line
{
	assert(line >=0 && line < width_);
	assert(col);
	unsigned char *currentCol = col;
	for (int i = 0 ; i < height_; i ++)
	{
		memcpy(data_ + i * bytesPerRow_ + line * bytesPerPixel_,currentCol,bytesPerPixel_);
		currentCol += bytesPerPixel_;
	}
}
@end
