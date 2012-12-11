//
//  UIImageInfo.h
//  Aico
//
//  Created by zhou yong on 3/30/12.
//  Copyright 2012 cienet. All rights reserved.
//

@interface ImageInfo : NSObject
{
	unsigned char   *data_;					// data of image
	size_t			width_;					// width of image
	size_t			height_;				// height of image
	size_t			bitsPerComponent_;		// number of bits/component of `image'
	size_t			bytesPerPixel_;			// the number of bits/pixel of `image'
	size_t			bytesPerRow_;			// the number of bytes/row of `image'
}

@property unsigned char *data;
@property size_t width;
@property size_t height;
@property size_t bitsPerComponent;
@property size_t bytesPerPixel;
@property size_t bytesPerRow;

/**
 * @brief 检验ImageInfo内的数据成员是否都是有效的值 
 *
 * @param [in]
 * @param [out]
 * @return 有效返回YES, 无效返回NO
 * @note 
 */
- (BOOL)isValid;

/**
 * @brief 克隆一个新的ImageInfo对象 
 *
 * @param [in]
 * @param [out]
 * @return 新的对象
 * @note 新的对象需要自己手动释放
 */
- (ImageInfo *)clone;

/**
 * @brief 将一个UIImage的数据格式转换成ImageInfo的数据格式 
 *
 * @param [in] image: 被转换的UIImage对象
 * @param [out] 
 * @return 需要的ImageInfo的对象
 * @note 
 */
+ (ImageInfo *)UIImageToImageInfo:(UIImage *)image;

/**
 * @brief 将一个ImageInfo的数据格式转换成UIImage的数据格式 
 *
 * @param [in] info: 被转换的ImageInfo对象
 * @param [out] 
 * @return 需要的UIImage的对象
 * @note 
 */
+ (UIImage *)ImageInfoToUIImage:(ImageInfo *)info;

/**
 * @brief 获取指定行的图片数据的内存地址 
 *
 * @param [in] line: 指定的行
 * @param [out] 
 * @return 数据的内存首地址
 * @note 
 */
- (unsigned char *)getRowWithLine:(int)line;

/**
 * @brief 更新指定行的图片数据 
 *
 * @param [out] col: 接受图片数据的内存区域
 * @param [in] line: 指定行
 * @return 
 * @note 
 */
- (void)getColumnWithColomn:(unsigned char *)col Withline:(int)line;

/**
 * @brief 设置指定行的图片数据 
 *
 * @param [in] col: 新的图片数据的内存区域
 * @param [in] line: 指定行
 * @return 
 * @note 
 */
- (void)setColumnWithColumn:(unsigned char *)col WithLine:(int)line;

@end
