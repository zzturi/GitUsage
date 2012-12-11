//
//  ColorEffectsCommon.h
//  Aico
//
//  Created by zhou yong on 3/31/12.
//  Copyright 2012 cienet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SIZE_6		6
#define SIZE_7		7
#define SIZE_256	256

#define CLAMP(x,l,u) ((x)<(l)?(l):((x)>(u)?(u):(x)))

@class ImageInfo;

@interface ColorEffectsCommon : NSObject
{
	
}

/**
 * @brief 指定通道曲线调整图片数据
 *
 * @param [in/out] info: 图片对象
 * @param [in] array: 调整因子 长度为256的数组
 * @return 
 * @note 
 */
+ (void)adjustCurve:(ImageInfo *)info transfer:(unsigned char *)array;

/**
 * @brief 指定通道曲线调整图片数据
 *
 * @param [in/out] info: 图片对象
 * @param [in] red: 红色通道调整因子 长度为256的数组
 * @param [in] green: 绿色通道调整因子 长度为256的数组
 * @param [in] blue: 蓝色通道调整因子 长度为256的数组
 * @return 
 * @note 
 */
+ (void)adjustCurve:(ImageInfo *)info red:(unsigned char *)red green:(unsigned char *)green blue:(unsigned char *)blue;

/**
 * @brief 亮度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)brightness:(ImageInfo *)info level:(double)level;

/**
 * @brief 对比度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)contrast:(ImageInfo *)info level:(double)level;

/**
 * @brief 饱和度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)saturation:(ImageInfo *)info level:(double)level;

/**
 * @brief 曝光度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] blackThreshold: 黑场调整因子 默认为0
 * @param [in] whiteThreshold: 白场调整因子 =[1,255]
 * @param [in] gamma: gamma调整因子 默认为1
 * @return 
 * @note 
 */
+ (void)exposure: (ImageInfo *)info 
  blackThreshold: (int)blackThreshold 
  whiteThreshold: (int)whiteThreshold
		   gamma: (double)gamma;

/**
 * @brief RGB调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] red: 红色调节值
 * @param [in] green: 绿色调节值
 * @param [in] blue: 蓝色调节值
 * @return 
 * @note 
 */
+ (void)adjustImage:(ImageInfo *)info withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 * @brief 黄昏调节
 *
 * @param [in] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)redScale:(ImageInfo *)info level:(float)level;

/**
 * @brief 色温调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的色温值
 * @return 
 * @note 
 */
+ (void)temperature:(ImageInfo *)info level:(float)level;

/**
 * @brief 色彩调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的色彩值
 * @param [in] mode: 调整的色调的模式
 * @param [in] preserveLuminosity: 是否保持亮度
 * @return 
 * @note 
 */
+ (void)colorImage:(ImageInfo *)image level:(float)value;

/**
 * @brief 色调调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的色调值
 * @return 
 * @note 
 */
+ (void)toneImage:(ImageInfo *)image level:(float)value;

/**
 * @brief 边缘检测
 *     
 * @param [in/out] imageInfo: 图片对象
 * @return 
 * @note 
 */
+ (void)edgeDetect:(ImageInfo *)imageInfo; 

/**
 * @brief 锐化
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 锐化半径
 * @return 
 * @note 
 */
+ (void)sharpenImage:(ImageInfo *)image imageEdge:(ImageInfo *)imageEdge level:(float)value;

/**
 * @brief 平滑
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 平滑系数
 * @return 
 * @note 
 */
+ (void)smoothImage:(ImageInfo *)image level:(float)value;

/**
 * @brief 快速模糊
 *
 * @param [in/out] image: 图片数据
 * @param [in] radius: 模糊像素的半径
 * @return 
 * @note 
 */
+ (void)fastBlurImage:(ImageInfo *)image radius:(int)radius;

@end


//色彩范围
typedef enum TINYIMAGE_HUERANGE_TAG
{
	TINYIMAGE_HUERANGE_ALLHUES,		//全图
	TINYIMAGE_HUERANGE_RED,			//红
	TINYIMAGE_HUERANGE_YELLOW,		//黄
	TINYIMAGE_HUERANGE_GREEN,		//绿
	TINYIMAGE_HUERANGE_CYAN,		//青
	TINYIMAGE_HUERANGE_BLUE,		//蓝
	TINYIMAGE_HUERANGE_MAGENTA,		//洋红
} TINYIMAGE_HUERANGE;

typedef struct HueSaturationTag
{
	double hue[SIZE_7];
	double lightness[SIZE_7];
	double saturation[SIZE_7];
	
	int    hueTransfer[SIZE_6][SIZE_256];
	int    lightnessTransfer[SIZE_6][SIZE_256];
	int    saturationTransfer[SIZE_6][SIZE_256];
	
	TINYIMAGE_HUERANGE range;
} HueSaturation, *HueSaturationRef;


typedef struct HueSaturationParamTag
{
	int hue;
	int saturation;
	int lightness;
	
	TINYIMAGE_HUERANGE range;
} HueSaturationParam, *HueSaturationParamRef;

//明暗调区域
typedef enum TINYIMAGE_TRANSFERMODE_TAG
{
	TINYIMAGE_TRANSFERMODE_SHADOWS,		//阴影
	TINYIMAGE_TRANSFERMODE_MIDTONES,	//中间调
	TINYIMAGE_TRANSFERMODE_HIGHLIGHTS,	//高光
} TINYIMAGE_TRANSFERMODE;

