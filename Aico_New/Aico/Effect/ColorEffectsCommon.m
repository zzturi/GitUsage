//
//  ColorEffectsCommon.m
//  Aico
//
//  Created by zhou yong on 4/19/12.
//  Copyright 2012 cienet. All rights reserved.
//

#import "ColorEffectsCommon.h"
#import "ImageInfo.h"
#import "EffectMethods.h"


@implementation ColorEffectsCommon

#define RED_SHIFT   0
#define GREEN_SHIFT 8
#define BLUE_SHIFT  16
#define ALPHA_SHIFT 24

#pragma mark -
#pragma mark 指定通道曲线调整
/**
 * @brief 指定通道曲线调整图片数据
 *
 * @param [in/out] info: 图片对象
 * @param [in] array: 调整因子 长度为256的数组
 * @return 
 * @note 
 */
+ (void)adjustCurve:(ImageInfo *)info transfer:(unsigned char *)array
{
	int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *data	= info.data;
	
	for (int i=0; i<height; i++)
	{
		for (int j=0; j<width; j++)
		{
			data[0] = array[data[0]];
			data[1] = array[data[1]];
			data[2] = array[data[2]];
			data += bpp;
		}
		data += offset;
	}
}

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
+ (void)adjustCurve:(ImageInfo *)info red:(unsigned char *)red green:(unsigned char *)green blue:(unsigned char *)blue
{
	int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *data	= info.data;
	
	for (int i=0; i<height; i++)
	{
		for (int j=0; j<width; j++)
		{
			data[0] = red  [data[0]];
			data[1] = green[data[1]];
			data[2] = blue [data[2]];
			data += bpp;
		}
		data += offset;
	}
}

#pragma mark -
#pragma mark 亮度
/**
 * @brief 亮度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)brightness:(ImageInfo *)info level:(double)level
{
	assert(level >= -1.0 && level <= 1.0);
	
	double delta = level + 1.0f;
	unsigned char lookup[256] = {0};
	for (int i=0; i<256; ++i)
	{
		lookup[i] = (unsigned char)CLAMP0255(i * delta);
	}
	
	[self adjustCurve:info transfer:lookup];
}

#pragma mark -
#pragma mark 对比度算法
/**
 * @brief 对比度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)contrast:(ImageInfo *)info level:(double)level
{
	assert(level >= -1.0 && level <= 1.0);
	
	unsigned char lookup[256];
	double delta = level + 1.0f;
	int threshold = 0x7F;	//128 可以认为是平均亮度
	for (int i=0; i<256; ++i)
	{
		lookup[i] = (unsigned char)CLAMP0255(threshold + (i - threshold)* delta);
	}
	
	[self adjustCurve:info transfer:lookup];
}




#pragma mark -
#pragma mark 饱和度算法(2种)
/**
 * @brief 饱和度调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)saturation:(ImageInfo *)info level:(double)level
{
    int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData = info.data;
	unsigned char *endData = info.data + height * stride;
    
    static float sat[] =
    {
        1,0,0,0,0,
        0,1,0,0,0,
        0,0,1,0,0,
        0,0,0,1,0
    }; 
    
    float satValue = level;//输入参数值    
    float invSat = 1 - satValue;
    float R = 0.213f * invSat;
    float G = 0.715f * invSat;
    float B = 0.075f * invSat;
    
    sat[0] = R + satValue;
    sat[1] = G;
    sat[2] = B;
    
    sat[5] = R;
    sat[6] = G + satValue;
    sat[7] = B;
    
    sat[10] = R;
    sat[11] = G;
    sat[12] = B +satValue;    
    
	
	int i = 0, j = 0;
	while (bmpData != endData)
	{
		
		int oR = bmpData[0];
		int oG = bmpData[1];
		int oB = bmpData[2];
		int oA = bmpData[3];
		
		oR = sat[0] *oR + sat[1] *oG + sat[2] *oB + sat[3] *oA + sat[4];
		oG = sat[5] *oR + sat[6] *oG + sat[7] *oB + sat[8] *oA + sat[9];
		oB = sat[10]*oR + sat[11]*oG + sat[12]*oB + sat[13]*oA + sat[14];
		oA = sat[15]*oR + sat[16]*oG + sat[17]*oB + sat[18]*oA + sat[19];
		
		bmpData[0] = CLAMP(oR, 0, 255);
		bmpData[1] = CLAMP(oG, 0, 255);
		bmpData[2] = CLAMP(oB, 0, 255);
		bmpData[3] = CLAMP(oA, 0, 255);
            
		bmpData += bpp;
		if (++j == width)
		{
			++i;
			j = 0;
			bmpData += offset;
		}
    }
} 

+ (void)saturation_another:(ImageInfo *)info level:(double)level
{
	int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData	= info.data;
	
	unsigned char r,g,b;
	CGFloat h=0.0f, s=0.0f, v=0.0f;
	    
	for (int i = 0; i < height; ++i)
	{
		for (int j = 0; j < width; ++j)
		{
			r = bmpData[0];
			g = bmpData[1];
			b = bmpData[2];
            
			[Common red:r green:g blue:b toHue:&h saturation:&s brightness:&v];
            
			s = s * level;
			if (s > 1.0f)
				s = 1.0f;
			
			unsigned char red=0, green=0, blue=0;
			[Common hue:h saturation:s brightness:v toRed:&red green:&green blue:&blue];
            
			bmpData[0] = red;
			bmpData[1] = green;
			bmpData[2] = blue;
			bmpData += bpp;
		}
		bmpData += offset;
	}
}

#pragma mark -
#pragma mark 曝光度算法
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
		   gamma: (double)gamma
{
	if (whiteThreshold > 254 && whiteThreshold < 510)
	{
		blackThreshold = 0;
		whiteThreshold = 510 - whiteThreshold;
	}
	else
	{
		blackThreshold = 255 - whiteThreshold;
		whiteThreshold = 255;
	}
	
	if (gamma < 0 || gamma > 10)
	{
		gamma = 1;
	}
	
	unsigned char lookup[256] = {0};
	//小于黑场阈值都设成0 
	for (int i = 0; i < blackThreshold; i ++)
	{
		lookup[i] = 0;
	}
	//中间部分做gamma校正
	double ig = (gamma == 0.0) ? 0.0 : 1 / gamma;
	double threshold = (double)(whiteThreshold - blackThreshold);
	for (int i = blackThreshold; i < whiteThreshold; i++)
	{
		lookup[i] = (unsigned char)CLAMP0255( pow((i-blackThreshold)/threshold,ig)*255);
	}
	//大于白场阈值都设为255
	for (int i = whiteThreshold; i < 256; i++)
	{
		lookup[i] = 255;
	}
	[self adjustCurve:info transfer:lookup];
}

#pragma mark -
#pragma mark RGB调节
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
+ (void)adjustImage:(ImageInfo *)info withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData	= info.data;
    
    for (int i=0; i<height; ++i)
    {
        for (int j=0; j<width; ++j)
        {
            int r = bmpData[0];
            int g = bmpData[1];
            int b = bmpData[2];
            
            r += red;
            g += green;
            b += blue;
            
            r = CLAMP(r, 0, 255);
            g = CLAMP(g, 0, 255);
            b = CLAMP(b, 0, 255);
            
            bmpData[0] = r;
            bmpData[1] = g;
            bmpData[2] = b;
            
            bmpData += bpp;
        }
        bmpData += offset;
    }
}

#pragma mark - 
#pragma mark 黄昏
/**
 * @brief 黄昏
 *
 * @param [in] info: 图片对象
 * @param [in] level: 调整因子
 * @return 
 * @note 
 */
+ (void)redScale:(ImageInfo *)info level:(float)level
{
	int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData	= info.data;
    
    for (int i=0; i<height; ++i)
    {
        for (int j=0; j<width; ++j)
        {
            int r = bmpData[0];
            int g = bmpData[1];
            int b = bmpData[2];
            
            r += level/2;
            b -= level;
            
            r = CLAMP(r, 0, 255);
            g = CLAMP(g, 0, 255);
            b = CLAMP(b, 0, 255);
            
            bmpData[0] = r;
            bmpData[1] = g;
            bmpData[2] = b;
            
            bmpData += bpp;
        }
        bmpData += offset;
    }
}

#pragma mark -
#pragma mark 色温调节
/**
 * @brief 色温调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的色温值
 * @return 
 * @note 
 */
+ (void)temperature:(ImageInfo *)info level:(float)level
{
    int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData	= info.data;
    
    for (int i=0; i<height; ++i)
    {
        for (int j=0; j<width; ++j)
        {
            int r = bmpData[0];
            int b = bmpData[2];
            
            level = CLAMP(level, -100, 100);
            if (level < 0) //蓝色调
            {
                r += level/2;
                b -= level/1.5;
            }
            if (level > 0) //黄色调
            {
                r += level/2;
                b -= level/1.5;  
            }
            
            
            r = CLAMP(r, 0, 255);
            b = CLAMP(b, 0, 255);
            
            bmpData[0] = r;
            bmpData[2] = b;
            
            bmpData += bpp;
        }
        bmpData += offset;
    }
    
}

#pragma mark -
#pragma mark 色彩调节
/**
 * @brief 色彩调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的色彩值
 * @return 
 * @note 
 */
+ (void)colorImage:(ImageInfo *)image level:(float)value
{
    int width	= image.width;
	int height	= image.height;
	int stride	= image.bytesPerRow;
	int bpp		= image.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData	= image.data;
    
    for (int i=0; i<height; ++i)
    {
        for (int j=0; j<width; ++j)
        {
            int r = bmpData[0];
            int g = bmpData[1];
            int b = bmpData[2];
            
            value = CLAMP(value, 0, 250);
            if (value < 51) //红
            {
                r = r + 50;
                g = g + value - 50;
                b = b - 50;
            }
            else if (value < 101)  //黄
            {
                r = r + 100 - value;
                g = g + value - 50;
                b = b + value - 100;
            }
            else if (value < 151) //绿
            {
                r = r + 100 - value;
                g = g + 150 - value ;
                b = b + value - 100;
                
            }
            else if (value < 201) //蓝
            {
                r = r + value - 200;
                g = g + 150 - value;
                b = b + 200 - value;
            }
            else if (value < 251) //红
            {
                r = r + value - 200;
                g = g - 50;
                b = b + 200 - value;
            }
           
            r = CLAMP(r, 0, 255);
            g = CLAMP(g, 0, 255);
            b = CLAMP(b, 0, 255);
            
            bmpData[0] = r;
            bmpData[1] = g;
            bmpData[2] = b;
            
            bmpData += bpp;
        }
        bmpData += offset;
    }  
}

#pragma mark -
#pragma mark 色调调节
/**
 * @brief 色调调节
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的色调值
 * @return 
 * @note 
 */
+ (void)toneImage:(ImageInfo *)image level:(float)value
{
    int width	= image.width;
	int height	= image.height;
	int stride	= image.bytesPerRow;
	int bpp		= image.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *bmpData	= image.data;
    
    for (int i=0; i<height; ++i)
    {
        for (int j=0; j<width; ++j)
        {
            int r = bmpData[0];
            int g = bmpData[1];
            int b = bmpData[2];
            
            value = CLAMP(value, -50, 50);
            if (value < 0)//洋红色
            {
                r = r - value;
                g = g + value;
                b = b - value;
            }
            else if (value > 0)//草绿色
            {
                r = r - value/2;
                g = g + value;
                b = b - value/2;
            }
  
            r = CLAMP(r, 0, 255);
            g = CLAMP(g, 0, 255);
            b = CLAMP(b, 0, 255);
            
            bmpData[0] = r;
            bmpData[1] = g;
            bmpData[2] = b;
            
            bmpData += bpp;
        }
        bmpData += offset;
    }  
}

#pragma mark -
#pragma mark 锐化
/**
 * @brief 边缘检测
 *     
 * @param [in/out] imageInfo: 图片对象
 * @return 
 * @note 
 */
+ (void)edgeDetect:(ImageInfo *)imageInfo 
{
    ImageInfo *clone = [imageInfo clone];
    int width = imageInfo.width;
	int height = imageInfo.height;
	int bpp	= imageInfo.bytesPerPixel;
	unsigned char *srcBmp = clone.data;
    int stride = imageInfo.bytesPerRow;
	int offset = stride - width * bpp;
    
    // 用Roberts算子进行边缘检测
    int a, b;   // a(x-1, y-1)    b(x, y-1)
    int c, d;   // c(x-1,   y)    d(x,   y)
    // 指向第一行
    srcBmp += stride;
    unsigned char * dst = imageInfo.data;
    dst += stride;
    // 不处理最上边和最左边
    for (int y = 1; y < height; y++)
    {
        // 指向每行第一列
        srcBmp += bpp;
        dst += bpp;
        for (int x = 1; x < width; x++)
        {
            for (int i = 0; i < 3; i++)
            {
                a = srcBmp[i - stride - bpp];
                b = srcBmp[i - stride];
                c = srcBmp[i - bpp];
                d = srcBmp[i];
                dst[i] = (int)sqrt((a-d) * (a-d) + (b-c) * (b-c));
            } // i为RGB
            srcBmp += bpp;
            dst += bpp;
        } // x为水平向右增加
        srcBmp += offset;
        dst += offset;
    } // y为竖直向下增加
    
    // 最左边和最上边像素值赋为０
    unsigned char *edgeDst = imageInfo.data;
    for ( int y = 0; y < height; y++)
        for (int x = 0; x < width; x++)
        {
            if ( x ==0 || y == 0)
            {
                edgeDst[0] = 0;
                edgeDst[1] = 0;
                edgeDst[2] = 0;
            }
            edgeDst += bpp;
        }
    [clone release];
}

/**
 * @brief 锐化
 *
 * @param [in/out] info: 图片对象
 * @param [in] value: 调节的锐化程度
 * @return 
 * @note 
 */
+ (void)sharpenImage:(ImageInfo*)image imageEdge:(ImageInfo *)imageEdge level:(float)value
{
	int width = image.width;
    int height = image.height;
	int stride = image.bytesPerRow;
    int bpp = image.bytesPerPixel;
    int offset = stride - bpp * width;
	unsigned char *src = image.data;
	
    
	unsigned char *dst = malloc(stride*height);
    memcpy(dst, imageEdge.data, stride*height);

    
    unsigned char *start = dst;
  	
	for (int y = 1; y < height; y++)
    {
        for (int x = 1; x < width; x++)
        {
            for (int i=0; i<3; i++)
            {
                if (dst[i] < 20) dst[i] = 0;
                int pixel = src[i] + dst[i] * value;
                pixel = CLAMP0255(pixel);
                dst[i] = pixel;
            }
            src += bpp;
            dst += bpp;
        }
        src += offset;
        dst += offset;
    }
	
	memcpy(image.data, start, stride*height);
    free(start);
}

#pragma mark -
#pragma mark 平滑

/**************************************************
 * 功能: 使用模板对彩色图邻域进行运算
 * 参数: image为目标图像
 *       matrix为模板 size为邻域大小 
 * position为要取得像素的坐标
 *       index为颜色分量编号 0为红色 1为绿色 2为蓝色
 **************************************************/
+ (int)templtExcuteCl:(unsigned char *)data 
               stride:(int)stride 
                  bpp:(int)bpp 
               matrix:(int *)matrix 
                 size:(int)size 
           colorIndex:(int)index
{
    int m = 0; //用来存放加权和
    int value;
    
    //依次对邻域中每个像素进行运算
    for(int i=0; i<size; i++)
    {
        for(int j=0; j<size; j++)
        {
            value = *(data + (i-1)*stride + (j-1)*bpp + index);
            m += value * matrix[i*size+j];
        }
    }
    return m;
}

/******************************************************************
 * 功能: 彩色图像的高斯平滑处理
 * 参数: image0为原图形，image1平滑结果，
 * w、h为图像的宽和高
 ******************************************************************/
+ (void)smoothGaussCl:(ImageInfo *)image matrix:(int *)matrix scale:(int)scale
{
    int w = image.width;
    int h = image.height;
    int bpp = image.bytesPerPixel;
    int stride= image.bytesPerRow;
    int offset = stride - bpp * w;
    
    ImageInfo *clone = [image clone];
    unsigned char *imageBuf = clone.data;
    
    //依次对原图像的每个像素进行处理
    int x = 1, y = 1;
    imageBuf += stride + bpp;   // 指向图片数据的第一行，第一列

    int a;
    while (y < h - 1)
    {
        for (int c=0; c<3; c++)
        {
            a = [ColorEffectsCommon templtExcuteCl:imageBuf stride:stride bpp:bpp matrix:matrix size:3 colorIndex:c];
            a /= scale;
            //过限处理
            a = CLAMP0255(a);
            *(imageBuf + c) = a;
        }
        
        imageBuf += bpp;
        
        if (++x == w - 1)
        {
            x = 1;
            ++y;
            imageBuf += offset + bpp * 2; // 这里要指向下一行数据的第1个像素的内存地址
        }
    }
    
    memcpy(image.data, clone.data, stride * h);
    [clone release];
}

+ (void)smoothImage:(ImageInfo *)image level:(float)value
{
    [EffectMethods gaussianBlurWithImageInfo:image andRadius:value];
}

#pragma mark -
#pragma mark 快速模糊
/**
 * @brief 模糊
 *
 * @param [in] srcPixels: 源图片数据
 * @param [out] dstPixels: 目标图片数据
 * @param [in] width: 图片的宽度
 * @param [in] height: 图片的高度
 * @param [in] radius: 模糊像素的半径
 * @return 
 * @note 
 */
+ (void)blurWithSrcPixels:(int *)srcPixels dstPixels:(int *)dstPixels width:(int)width height:(int)height radius:(int)radius
{
    int windowSize = radius * 2 + 1;
    int radiusPlusOne = radius + 1;
    
    int sumAlpha, sumRed, sumGreen, sumBlue;
    int srcIndex = 0;
    int dstIndex;
    int pixel;
    
    int tableCount = 256 * windowSize;
    int *sumLookupTable = malloc(tableCount * sizeof(int));
    for (int i=0; i<tableCount; i++)
    {
        sumLookupTable[i] = i / windowSize;
    }
    
    int *indexLookupTable = malloc(radiusPlusOne * sizeof(int));
    if (radius < width) 
    {
        for (int i=0; i<radiusPlusOne; i++)
        {
            indexLookupTable[i] = i;
        }
    }
    else 
    {
        for (int i=0; i<width; i++)
        {
            indexLookupTable[i] = i;
        }
        for (int i=width; i<radiusPlusOne; i++)
        {
            indexLookupTable[i] = width - 1;
        }
    }
    
    for (int y=0; y<height; y++)
    {
        sumAlpha = sumRed = sumGreen = sumBlue = 0;
        dstIndex = y;
        
        pixel = srcPixels[srcIndex];
        
        sumRed   += radiusPlusOne * ((pixel >> RED_SHIFT)   & 0xFF);
        sumGreen += radiusPlusOne * ((pixel >> GREEN_SHIFT) & 0xFF);
        sumBlue  += radiusPlusOne * ((pixel >> BLUE_SHIFT)  & 0xFF);
        sumAlpha += radiusPlusOne * ((pixel >> ALPHA_SHIFT) & 0xFF);
        
        for (int i=1; i<=radius; i++)
        {
            pixel = srcPixels[srcIndex + indexLookupTable[i]];
            sumRed   += (pixel >> RED_SHIFT)   & 0xFF;
            sumGreen += (pixel >> GREEN_SHIFT) & 0xFF;
            sumBlue  += (pixel >> BLUE_SHIFT)  & 0xFF;
            sumAlpha += (pixel >> ALPHA_SHIFT) & 0xFF;
        }
        
        for (int x=0; x<width; x++)
        {
            dstPixels[dstIndex] = sumLookupTable[sumRed]   << RED_SHIFT   |
                                  sumLookupTable[sumGreen] << GREEN_SHIFT |
                                  sumLookupTable[sumBlue]  << BLUE_SHIFT  |
                                  sumLookupTable[sumAlpha] << ALPHA_SHIFT;
            
            dstIndex += height;
            
            int nextPixelIndex = x + radiusPlusOne;
            if (nextPixelIndex >= width)
            {
                nextPixelIndex = width - 1;
            }
            int previousPixelIndex = x - radius;
            if (previousPixelIndex < 0)
            {
                previousPixelIndex = 0;
            }
            
            int nextPixel = srcPixels[srcIndex + nextPixelIndex];
            int previousPixel = srcPixels[srcIndex + previousPixelIndex];
            
            sumRed   += (nextPixel     >> RED_SHIFT)   & 0xFF;
            sumRed   -= (previousPixel >> RED_SHIFT)   & 0xFF;
            
            sumGreen += (nextPixel     >> GREEN_SHIFT) & 0xFF;
            sumGreen -= (previousPixel >> GREEN_SHIFT) & 0xFF;
            
            sumBlue  += (nextPixel     >> BLUE_SHIFT)  & 0xFF;
            sumBlue  -= (previousPixel >> BLUE_SHIFT)  & 0xFF;
            
            sumAlpha += (nextPixel     >> ALPHA_SHIFT) & 0xFF;
            sumAlpha -= (previousPixel >> ALPHA_SHIFT) & 0xFF;
        }
        
        srcIndex += width;
    }
    
    free(sumLookupTable);
    free(indexLookupTable);
}

/**
 * @brief 快速模糊
 *
 * @param [in/out] image: 图片数据
 * @param [in] radius: 模糊像素的半径
 * @return 
 * @note 
 */
+ (void)fastBlurImage:(ImageInfo *)image radius:(int)radius
{
    int width = image.width;
    int height = image.height;
    
    int *srcPixels = (int *)image.data;
    int *dstPixels = malloc(image.bytesPerRow * height);
    
    [ColorEffectsCommon blurWithSrcPixels:srcPixels dstPixels:dstPixels width:width height:height radius:radius];
    [ColorEffectsCommon blurWithSrcPixels:dstPixels dstPixels:srcPixels width:height height:width radius:radius];
    
    free(dstPixels);
}

@end
