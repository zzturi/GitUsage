//
//  EffectMethods.m
//  Aico
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <OpenGLES/ES2/gl.h>
#import "EffectMethods.h"
#import "ImageInfo.h"

#ifndef CLAMP0255
#define CLAMP0255(x) ((x)<(0)?(0):((x)>(255)?(255):(x)))
#endif
static bool tranferInit = false;

//变亮的转换数组
static double highlightsAdd[256] = {0};
static double midtonesAdd[256] = {0};
static double shadowsAdd[256] = {0};

//变暗的转换数组
static double highlightsSub[256] = {0};
static double midtonesSub[256] = {0};
static double shadowsSub[256] = {0};
@implementation EffectMethods

// 图层混合模式
enum KBlendMode
{
    KBlendModeSoftLight,    // 柔光
    KBlendModeReversalfilm, // 反转片
    KBlendModeNeon,          // 霓虹灯
    KBlendModeHardLight      // 强光     
};
#pragma mark - Curve
/**
 * @brief  RGB通道曲线调整 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)adjustCurveWithInImage:(ImageInfo *)imageInfo 
                 withRedLookup:(unsigned char *)redLookup 
               withGreenLookup:(unsigned char *)greenLookup 
                withBlueLookup:(unsigned char *)blueLookup
{
    unsigned char *imgPixel = imageInfo.data;
	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;
    int offset = imgBytesPerRow - imgWidth * imgBpp;
    for (int i = 0; i < imgHeight; ++i)
    {
        for (int j = 0; j < imgWidth; ++j)
        {
            imgPixel[0] = redLookup[imgPixel[0]];
            imgPixel[1] = greenLookup[imgPixel[1]];
            imgPixel[2] = blueLookup[imgPixel[2]];
            imgPixel += imgBpp;
        }
        imgPixel += offset;
    }
    
}
/**
 * @brief  指定通道曲线调整 
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)adjustCurveWithInImage:(ImageInfo *)imageInfo withLookup:(unsigned char *)lookup withChanel:(int)chanel
{
    unsigned char *imgPixel = imageInfo.data;
	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;
    int offset = imgBytesPerRow - imgWidth * imgBpp;
    switch (chanel)
    {
        case EChanelR:
        {
            for (int i = 0; i < imgHeight; ++i)
            {
                for (int j = 0; j < imgWidth; ++j)
                {
                    imgPixel[0] = lookup[imgPixel[0]];
                    imgPixel += imgBpp;
                }
                imgPixel += offset;
            }
            break;       
        }
        case EChanelG:
        {
            for (int i = 0; i < imgHeight; ++i)
            {
                for (int j = 0; j < imgWidth; ++j)
                {
                    imgPixel[1] = lookup[imgPixel[1]];
                    imgPixel += imgBpp;
                }
                imgPixel += offset;
            }
            break;
        }
        case EChanelB:
        {
            for (int i = 0; i < imgHeight; ++i)
            {
                for (int j = 0; j < imgWidth; ++j)
                {
                    imgPixel[2] = lookup[imgPixel[2]];
                    imgPixel += imgBpp;
                }
                imgPixel += offset;
            }
            break;
        }
        case EChanelRGB:
        {
            
            for (int i = 0; i < imgHeight; ++i)
            {
                for (int j = 0; j < imgWidth; ++j)
                {
                    int redPix = (unsigned char)imgPixel[0];
                    int greenPix = (unsigned char)imgPixel[1];
                    int bluePix = (unsigned char)imgPixel[2];
                    imgPixel[0] = lookup[redPix];
                    imgPixel[1] = lookup[greenPix];
                    imgPixel[2] = lookup[bluePix];
                    imgPixel += imgBpp;
                }
                imgPixel += offset;
            }
            break;
        }
        default:
            break;
    }
}
/**
 * @brief  RGB通道曲线调整 
 * 保证像素点亮度不变的曲线调整
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)preserveLuminosityAdjustCurveWithInImage:(ImageInfo *)imageInfo 
                                   withRedLookup:(unsigned char *)redLookup 
                                 withGreenLookup:(unsigned char *)greenLookup 
                                  withBlueLookup:(unsigned char *)blueLookup
{
    unsigned char *imgPixel = imageInfo.data;
	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;   
    int offset = imgBytesPerRow - imgWidth * imgBpp;
    int red,green,blue;
    int rLookup,gLookup,bLookup;
    
    for (int i = 0; i < imgHeight; ++i)
    {
        for (int j = 0; j < imgWidth; ++j)
        {
            red = (int)imgPixel[0];
            green = (int)imgPixel[1];
            blue = (int)imgPixel[2];
            
            rLookup = (int)redLookup[red];
            gLookup = (int)greenLookup[green];
            bLookup = (int)blueLookup[blue];
            
            //添加下面三句，只执行色彩平衡操作就有杂点，暂时先注释
//            [EffectMethods rgb2Hsl_IntWithRed:&rLookup WithGreen:&gLookup WithBlue:&bLookup];
//            bLookup = [EffectMethods rgb2Hsl_LWithRed:red WithGreen:green WithBlue:blue];
//            [EffectMethods hsl2Rgb_IntWithHue:&rLookup WithSaturation:&gLookup WithLightness:&bLookup];
            
            imgPixel[0] = (unsigned char)rLookup;
            imgPixel[1] = (unsigned char)gLookup;
            imgPixel[2] = (unsigned char)bLookup;
            imgPixel += imgBpp;
        }
        imgPixel += offset;
    }
    
}

/**
 * @brief  RGB转HSL 
 * 参数为［int，out］型
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)rgb2Hsl_IntWithRed:(int *)red withGreen:(int *)green withBlue:(int *)blue
{
    int    r, g, b;
    double h, s, l;
    int    min, max;
    int    delta;
    r = *red;
    g = *green;
    b = *blue;
    
    if (r > g)
    {
        max = MAX(r, b);
        min = MIN(g, b);
    }
    else
    {
        max = MAX(g, b);
        min = MIN(r, b);
    }
    
    l = (max + min)/2.0;
    
    if (max == min)
    {
        s = 0.0;
        h = 0.0;
    }
    else
    {
        delta = max - min;
        if (l < 128)
        {
            s = 255 * (double)delta/(double)(max + min);
        }
        else
        {
            s = 255 * (double)delta/(double)(511 - max - min);
        }
        
        if (r == max)
        {
            h = (g - b)/(double)delta;
        }
        else if(g == max)
        {
            h = 2 + (b - r)/(double)delta;
        }
        else
        {
            h = 4 + (r - g)/(double)delta;
        }
        
        h = h * 42.5;
        
        if (h < 0)
        {
            h += 255;
        }
        else if(h > 255)
        {
            h -= 255;
        }
    }
    
    *red = (int)ROUND(h);
    *green = (int)ROUND(s);
    *blue = (int)ROUND(l);
    
}

/**
 * @brief  RGB转HSL，只获取L
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (int)rgb2Hsl_LWithRed:(unsigned char)red withGreen:(unsigned char)green withBlue:(unsigned char)blue;
{
	int min, max;
    
	if (red > green) 
	{
		max = MAX(red, blue);
		min = MIN(green, blue);
	} 
	else 
	{
		max = MAX(green, blue);
		min = MIN(red, blue);
	}
    
	return(int)ROUND((max + min) / 2.0);
}
//HSL转RGB中间计算函数
static int hslValueInt(double n1, double n2, double hue) {
	double value;
    
	if (hue > 255) 
	{
		hue -= 255;
	} 
	else if (hue < 0) 
	{
		hue += 255;
	}
    
	if (hue < 42.5) 
	{
		value = n1 + (n2 - n1) * (hue / 42.5);
	} 
	else if (hue < 127.5) 
	{
		value = n2;
	}
	else if (hue < 170) 
	{
		value = n1 + (n2 - n1) * ((170 - hue) / 42.5);
	} 
	else 
	{
		value = n1;
	}
    
	return (int)ROUND(value * 255.0);
}
/**
 * @brief  HSL转RGB 参数都是[int,out]类型
 * hue返回R ，saturation返回G，lightness返回B
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)hsl2Rgb_IntWithHue:(int *)hue withSaturation:(int *)saturation withLightness:(int *)lightness;

{
	double h, s, l;
	h = *hue;
	s = *saturation;
	l = *lightness;
    
	if (s == 0)
	{
        *hue = *lightness;
        *saturation = *lightness;
	}
	else
	{
		double m1, m2;
        
		if (l < 128)
        {
			m2 = (l * (255 + s)) / 65025.0;
        }
		else
        {
			m2 = (l + s - (l * s) / 255.0) / 255.0;
        }
        
		m1 = (l / 127.5) - m2;
        
        *hue = hslValueInt(m1, m2, h + 85);
        *saturation = hslValueInt(m1, m2, h);
        *lightness = hslValueInt(m1, m2, h - 85);
    }
}

#pragma mark - balance color －－－－色彩平衡

/**
 * @brief  调节色彩平衡，
 * 
 * @param [in] cyan－－－青蓝色 magenta －－－品红色 yellow －－－黄色
 * @param [out]
 * @return
 * @note 
 */
+ (void)balanceColorWithInImage:(ImageInfo *)imageInfo 
                       withCyan:(int)cyan 
                    withMagenta:(int)magenta 
                     withYellow:(int)yellow
               withTransferMode:(int)mode
         withPreserveLuminosity:(bool)preserveLuminosity
{
    
    if (!((cyan >= -100 && cyan <= 100) 
          || (magenta >= -100 && magenta <= 100)
          || (yellow >= -100 && yellow <= 100)))
    {
        return;
    }
    double  cyan_red[3];
	double  magenta_green[3];
	double  yellow_blue[3];
    
    //初始化色彩调整区域参数
    //0代表阴影tranfermode，1代表中间调，2代表高光
    for (int i = ETransferShadows; i <= ETransferHighlights; i++)
	{
		cyan_red[i] = 0.0;
		magenta_green[i] = 0.0;
		yellow_blue[i] = 0.0;
	}
	cyan_red[mode] = cyan;
	magenta_green[mode] = magenta;
	yellow_blue[mode] = yellow;
    
    //初始化转换用的数组
    if (!tranferInit) 
    {
        for (int i = 0; i < 256; ++i)
        {
            shadowsSub[255 - i] = (1.075 - 1/((double)i/16.0 +1));
            highlightsAdd[i] = shadowsSub[255 - i];
            
            midtonesSub[i] =  0.667 *(1 - SQR(((double)i  - 127.0)/127.0));
            midtonesAdd[i]= midtonesSub[i];
            highlightsSub[i]=  0.667 *(1 - SQR(((double)i - 127.0)/127.0));
            shadowsAdd[i] = highlightsSub[i];
        }
        tranferInit = true;
    }
    
    //创建lookup table
    double *cyanRedTransfer[3];
    double *magentaGreenTransfer[3];
    double *yellowBlueTransfer[3];
    int red,green,blue;
    unsigned char rLookup[256],gLookup[256],bLookup[256];
    
    //    ETransferShadows, //阴影
    //    ETransferMidtones,//中间调
    //    ETransferHighlights//高光
    
    //设置转换数组
    cyanRedTransfer[ETransferShadows] = (cyan_red[ETransferShadows] > 0)?shadowsAdd:shadowsSub;
    cyanRedTransfer[ETransferMidtones] = (cyan_red[ETransferMidtones] > 0)?midtonesAdd:midtonesSub;
    cyanRedTransfer[ETransferHighlights] = (cyan_red[ETransferHighlights] > 0)?highlightsAdd:highlightsSub;
    
    magentaGreenTransfer[ETransferShadows] = (magenta_green[ETransferShadows] > 0)?shadowsAdd:shadowsSub;
    magentaGreenTransfer[ETransferMidtones] = (magenta_green[ETransferMidtones] > 0)?midtonesAdd:midtonesSub;
    magentaGreenTransfer[ETransferHighlights] = (magenta_green[ETransferHighlights] > 0)?highlightsAdd:highlightsSub;
    
    yellowBlueTransfer[ETransferShadows] = (yellow_blue[ETransferShadows] > 0)?shadowsAdd:shadowsSub;
    yellowBlueTransfer[ETransferMidtones] = (yellow_blue[ETransferMidtones] > 0)?midtonesAdd:midtonesSub;
    yellowBlueTransfer[ETransferHighlights] = (yellow_blue[ETransferHighlights] > 0)?highlightsAdd:highlightsSub;
    
    for (int i = 0; i < 256; ++i)
    {
        red = i;
        green = i;
        blue = i;
        
        red += (int)(cyan_red[ETransferShadows] * cyanRedTransfer[ETransferShadows][red]
                     + cyan_red[ETransferMidtones] * cyanRedTransfer[ETransferMidtones][red]
                     + cyan_red[ETransferHighlights] * cyanRedTransfer[ETransferHighlights][red]);
        
        red = CLAMP0255(red);
        
        green += (int)(magenta_green[ETransferShadows] * magentaGreenTransfer[ETransferShadows][green]
                       + magenta_green[ETransferMidtones] * magentaGreenTransfer[ETransferMidtones][green]
                       + magenta_green[ETransferHighlights] * magentaGreenTransfer[ETransferHighlights][green]);
        
        green = CLAMP0255(green);
        
        blue += (int)(yellow_blue[ETransferShadows] * yellowBlueTransfer[ETransferShadows][blue]
                      + yellow_blue[ETransferMidtones] * yellowBlueTransfer[ETransferMidtones][blue]
                      + yellow_blue[ETransferHighlights] * yellowBlueTransfer[ETransferHighlights][blue]);
        
        blue = CLAMP0255(blue);
        
        rLookup[i] = (unsigned char)red;
        gLookup[i] = (unsigned char)green;
        bLookup[i] = (unsigned char)blue;
    }
    
    if (!preserveLuminosity)
    {
        [EffectMethods adjustCurveWithInImage:imageInfo withRedLookup:rLookup withGreenLookup:gLookup withBlueLookup:bLookup];
    }
    else
    {
        [EffectMethods preserveLuminosityAdjustCurveWithInImage:imageInfo withRedLookup:rLookup withGreenLookup:gLookup withBlueLookup:bLookup];
    }
}

#pragma mark - adjust levels ---调整色阶
/**
 * @brief  调整色阶，使图片变暗，
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)adjustLevelsWithInImage:(ImageInfo *)imageInfo withBlackLimit:(int)blackTreshold withWhiteLimit:(int)whiteThreshold withGamma:(double)gamma withChanel:(int)chanel
{
    if (!(blackTreshold >= 0 && whiteThreshold > blackTreshold && whiteThreshold <= 255))
    {
        return;
    }
    if (!(gamma >= 0.0 && gamma <= 5.0))
    {
        return;
    }
    unsigned char lookup[256] = {0};
    //小于黑场阀值都设成0
    for (int i = 0; i < blackTreshold; ++i)
    {
        lookup[i] = 0;
    }
    //中间部分做gamma校正
    double ig = (gamma <= 0.000001 && gamma >= -0.000001)?0.0:1/gamma;
    double threshold = (double)(whiteThreshold - blackTreshold);
    for (int i = blackTreshold; i <= whiteThreshold; ++i)
    {
        lookup[i] = (unsigned char)CLAMP0255((int)(pow((i - blackTreshold)/threshold, ig) * 255 + 0.5));
    }
    
    //大于白场阀值都设为255
    for (int i = whiteThreshold; i < 255; ++i)
    {
        lookup[i] = 255;
    }
    [EffectMethods adjustCurveWithInImage:imageInfo withLookup:lookup withChanel:chanel];
}

#pragma mark - darken corner －－－－－添加暗角
/**
 * @brief  添加暗角
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)darkenCornerWithInImage:(ImageInfo *)imageInfo 
                withBrightRatio:(double)brightRatio 
                  withMaskAlpha:(unsigned char)maskAlpha
{
    if (!(brightRatio <= 1.0 && brightRatio >= 0.0))
    {
        return;
    }

	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;

    //构造椭圆
    int halfWidth	= ceilf(imgWidth / 2.0);
	int halfHeight	= ceilf(imgHeight/ 2.0);
    double effectWidth	= halfWidth * brightRatio; 
	double effectHeight	= halfHeight * brightRatio;
    int maxHalfWidthHeight	= (halfWidth > halfHeight) ? halfWidth : halfHeight;
    
	bool round		= (halfWidth == halfHeight);	
	bool focusOnX	= (halfWidth > halfHeight);
    double focus	= round ? 0.0 : sqrt(fabs(((effectWidth) * (effectWidth) - (effectHeight) * (effectHeight))));
	double f1X		= focusOnX ? focus : 0.0;
	double f1Y		= focusOnX ? 0.0 : focus;
	double f2X		= focusOnX ? -focus : 0.0;
	double f2Y		= focusOnX ? 0.0 : -focus;
	double mindist	= MAX(effectWidth, effectHeight) * 2;//椭圆周上距离，该点亮度为255
    //对角到椭圆心距离
    double maxdist = sqrt((halfWidth - f1X) * (halfWidth  -1 - f1X) + (halfHeight -1 - f1Y) * (halfHeight -1 - f1Y))
    + sqrt((halfWidth - f2X) * (halfWidth -1 - f2X) + (halfHeight -1 - f2Y) * (halfHeight -1 - f2Y));
    
    assert(fabs(mindist - effectWidth *2) < 0.000001 || fabs(mindist - effectHeight *2) < 0.000001);
    
    double	effectHeightSQR = SQR(effectHeight);
	double	effectWidthSQR  = SQR(effectWidth);
	double	effectAreaSQR   = SQR(effectHeight * effectWidth);
	double lookupSQR[maxHalfWidthHeight];//构造平方数的lookup table
    for (int i = 0; i < maxHalfWidthHeight; i ++)
	{
        
		lookupSQR[i] = ((double)i) * i;
	}
    
    //构造四块蒙层
    TinyRGBARef leftTopMask = malloc(halfWidth * halfHeight * sizeof(TinyRGBA));//[halfWidth *halfHeight] ;
    TinyRGBARef leftBottomMask = malloc(halfWidth * halfHeight * sizeof(TinyRGBA));//[halfWidth *halfHeight];
    TinyRGBARef rightTopMask = malloc(halfWidth * halfHeight * sizeof(TinyRGBA));//[halfWidth *halfHeight];
    TinyRGBARef rightBottomMask = malloc(halfWidth * halfHeight * sizeof(TinyRGBA));//[halfWidth *halfHeight];
    TinyRGBARef dot = rightBottomMask;
    
    for (int j = 0; j < halfHeight; ++j) 
	{
		for (int i = 0; i < halfWidth; ++i) 
		{
			if (lookupSQR[i] * effectHeightSQR + lookupSQR[j] * effectWidthSQR < effectAreaSQR) 
			{
				// 椭圆内
				dot->m_alpha = 0;
				dot->m_blue = dot->m_red = dot->m_green = 0;
			} 
			else 
			{
				// 椭圆外，计算到两焦点距离和
				double dist = sqrt((i - f1X) * (i - f1X) + (j - f1Y) * (j - f1Y)) + sqrt((i - f2X) * (i - f2X) + (j - f2Y) * (j - f2Y));
				dist = MAX(dist, mindist);
				dist = MIN(dist, maxdist);
				assert(dist >= mindist && dist <= maxdist);
				double fact = (dist - mindist) / (maxdist - mindist);
				dot->m_alpha = (unsigned char)(255 * fact * fact);
				dot->m_blue = dot->m_red = dot->m_green = 0;
			}
			int xOffset = halfWidth-1-i;
			int yOffset =  halfWidth*(halfHeight - 1 - j);
            
			leftTopMask[xOffset + yOffset]			= *dot;
			leftBottomMask[xOffset +j*(halfWidth)]	= *dot;
			rightTopMask[yOffset + i]				= *dot;
			
			dot++;
            
		}
	}

    
	[EffectMethods blendLayerMaskWithInImage:imageInfo withTinyRGBA:leftTopMask withMaskX:0 withMaskY:0 withMaskWidth:halfWidth withMaskHeight:halfHeight withMaskAlpha:maskAlpha];
    [EffectMethods blendLayerMaskWithInImage:imageInfo withTinyRGBA:rightTopMask withMaskX:halfWidth withMaskY:0 withMaskWidth:halfWidth withMaskHeight:halfHeight withMaskAlpha:maskAlpha];
    [EffectMethods blendLayerMaskWithInImage:imageInfo withTinyRGBA:leftBottomMask withMaskX:0 withMaskY:halfHeight withMaskWidth:halfWidth withMaskHeight:halfHeight withMaskAlpha:maskAlpha];
    [EffectMethods blendLayerMaskWithInImage:imageInfo withTinyRGBA:rightBottomMask withMaskX:halfWidth withMaskY:halfHeight withMaskWidth:halfWidth withMaskHeight:halfHeight withMaskAlpha:maskAlpha];
    if (leftTopMask)
    {
        free(leftTopMask);
    }
    leftTopMask = NULL;
    
    if (leftBottomMask)
    {
        free(leftBottomMask);
    }
    leftBottomMask = NULL;
    
    if (rightTopMask)
    {
        free(rightTopMask);
    }
    rightTopMask = NULL;
    
    if (rightBottomMask)
    {
        free(rightBottomMask);
    }
    rightBottomMask = NULL;
    
}

/**
 * @brief  
 * 添加蒙板
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendLayerMaskWithInImage:(ImageInfo *)imageInfo 
                     withTinyRGBA:(TinyRGBARef)mask 
                        withMaskX:(int)maskX 
                        withMaskY:(int)maskY 
                    withMaskWidth:(int)maskWidth
                   withMaskHeight:(int)maskHeight 
                    withMaskAlpha:(unsigned char)maskAlpha
{
    unsigned char *imgPixel = imageInfo.data;
	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;
    
    if (!mask)
    {
        return;
    }
    if (!(maskX >= 0 && maskX + maskWidth <= imgWidth + 1))
    {
        return;
    }
    if (!(maskY >= 0 && maskY + maskHeight <= imgHeight + 1)) 
    {
        return;
    }
    
    //蒙板图需要扫描的范围
    int maskStartX = 0;
    int maskStartY = 0;
    
    //Bitmap扫描的范围
    int startY	= maskY;
	int endY	= maskY + maskHeight;
	int startX	= maskX;
	int endX	= maskX + maskWidth;
    
	for (int j = startY; j < endY; j ++)
	{
		int maskj = j - startY;
		int i = startX;
		unsigned char *bmpData = imgPixel + j * imgBytesPerRow + i * imgBpp;
		for (; i < endX; i++)
		{
			int maski = i - startX;
			TinyRGBARef layerMaskColor = mask +(maski + maskStartX) +(maskj + maskStartY) * maskWidth;
            
            
            [EffectMethods blendWithBgColor:(TinyRGBRef)bmpData withBgColorAlpha:255 withFgColor:layerMaskColor withDstColor:(TinyRGBRef)bmpData withCoverAlpha:maskAlpha];
			bmpData += imgBpp;
		}
	}
}

/**
 * @brief  lomo中间算法
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char)fastScaleByteByByte:(unsigned char)a andByte:(unsigned char)b;
{
	unsigned int r1 = a * b + 0x80;
	unsigned int r2 = ((r1 >> 8) + r1) >> 8;
	return (unsigned char)r2;
}

/**
 * @brief  lomo中间算法
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendWithBgColor:(TinyRGBRef)bgColor 
        withBgColorAlpha:(unsigned char)bgColorAlpha
             withFgColor:(TinyRGBARef)fgColor 
            withDstColor:(TinyRGBRef)dstColor 
          withCoverAlpha:(unsigned char)coverAlpha
{
	assert(bgColor);
	assert(fgColor);
	assert(dstColor);
    
	unsigned int bgAlpha, fgAlpha, mixAlpha, r, g, b;
    bgAlpha = (unsigned int)[EffectMethods fastScaleByteByByte:(unsigned char)(255 - coverAlpha) andByte:255];
    fgAlpha = (unsigned int)[EffectMethods fastScaleByteByByte:coverAlpha andByte:fgColor->m_alpha];
	mixAlpha = bgAlpha + fgAlpha;
    
	if (0 == mixAlpha) 
	{
		r = 0;
		g = 0;
		b = 0;
	}
	else 
	{
        r = ((bgColor->m_red * bgAlpha) + (fgColor->m_red * fgAlpha)) / mixAlpha;
		g = ((bgColor->m_green * bgAlpha) + (fgColor->m_green * fgAlpha)) / mixAlpha;
		b = ((bgColor->m_blue * bgAlpha) + (fgColor->m_blue * fgAlpha)) / mixAlpha;
	}
    
	dstColor->m_blue = (unsigned char)b;
	dstColor->m_green = (unsigned char)g;
	dstColor->m_red = (unsigned char)r;
    
}

#pragma mark - gaussian blur －－－－－高斯模糊
/**
 * @brief  灰度化
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)grayScaleWithImageInfo:(ImageInfo *)imageInfo
{
    unsigned char *imgPixel = imageInfo.data;
	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;
    
    int offset = imgBytesPerRow - imgWidth * imgBpp;
    
    for (int i = 0; i < imgHeight; ++i)
    {
        for (int j = 0; j < imgWidth; ++j)
        {
            int red = (unsigned char)imgPixel[0];
            int green = (unsigned char)imgPixel[1];
            int blue = (unsigned char)imgPixel[2];
            
            unsigned char luminace = [EffectMethods getLuminaceWithRed:red withGreen:green withBlue:blue];
            imgPixel[0] = luminace;
            imgPixel[1] = luminace;
            imgPixel[2] = luminace;
            imgPixel += imgBpp;
        }
        imgPixel += offset;
    }
}

/**
 * @brief  获取灰度值
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char)getLuminaceFromTinyRGB:(TinyRGBRef)tinyRGB
{
    unsigned char luminace = CLAMP0255(ROUND(RGB_LUMINACE(tinyRGB->m_red, tinyRGB->m_green, tinyRGB->m_blue)));
    return luminace;
    
}

/**
 * @brief  获取灰度值
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char)getLuminaceWithRed:(unsigned char)red withGreen:(unsigned char)green withBlue:(unsigned char)blue
{
    unsigned char luminace = CLAMP0255(ROUND(RGB_LUMINACE(red, green, blue)));
    return luminace;
    
}
/**
 * @brief  高斯模糊
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)gaussianBlurWithImageInfo:(ImageInfo *)imageInfo andRadius:(long)radius
{
	GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;
    
    
    // generate convolution matrix and make sure it's smaller than each dimension
	float *cmatrix = NULL;
	int cmatrix_length = [EffectMethods genConvolveMatrixWithRadius:radius andMatrix:&cmatrix];
    
	// generate lookup table
	float *ctable = [EffectMethods genLookupTableWithMatrix:cmatrix andMatrixLen:cmatrix_length];
    
	ImageInfo *clone = [imageInfo clone];
    
	//横向
	for (int i = 0; i < imgHeight; i++)
	{
        [EffectMethods blurLineWithLookupTable:ctable 
                                    withMatrix:cmatrix 
                                 withMatrixLen:cmatrix_length 
                                   withSrcLine:[imageInfo getRowWithLine:i]
                                   withDstLine:[clone getRowWithLine:i]
                                     withWidth:imgWidth 
                                       withBpp:imgBpp];
		
	}
    
	//纵向
	unsigned char *srcLine = malloc(imgBpp * imgHeight * sizeof(unsigned char));
	unsigned char *dstLine = malloc(imgBpp * imgHeight * sizeof(unsigned char));
	for (int i = 0; i < imgWidth; i++)
	{
        [clone getColumnWithColomn:srcLine Withline:i];
        [EffectMethods blurLineWithLookupTable:ctable 
                                    withMatrix:cmatrix 
                                 withMatrixLen:cmatrix_length 
                                   withSrcLine:srcLine 
                                   withDstLine:dstLine 
                                     withWidth:imgHeight 
                                       withBpp:imgBpp];
		
        [clone setColumnWithColumn:dstLine WithLine:i];
        
	}
   
	size_t size = (size_t)imgBytesPerRow * imgHeight;
	memcpy(imageInfo.data,clone.data,size);
    
    if (srcLine)
    {
        free(srcLine);
    }
    srcLine = NULL;
    if (dstLine)
    {
        free(dstLine);
    }
    dstLine = NULL;
    
    if (cmatrix)
    {
        free(cmatrix);
    }
    cmatrix = NULL;
    [clone release];
    if (ctable)
    {
        free(ctable);
    }
    ctable = NULL;
}

/**
 * @brief  
 * generate a matrix that goes out a certain radius
 * from the center, so we have to go out ceil(rad-0.5) pixels,
 * inlcuding the center pixel. 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (int)genConvolveMatrixWithRadius:(float)radius andMatrix:(float **)matrix;
{
	int matrix_length;
	float *cMatrix;
	int i,j;
	float std_dev;
	float sum;
	
	/* we want to generate a matrix that goes out a certain radius
     * from the center, so we have to go out ceil(rad-0.5) pixels,
     * inlcuding the center pixel.  Of course, that's only in one direction,
     * so we have to go the same amount in the other direction, but not count
     * the center pixel again.  So we double the previous result and subtract
     * one.
     * The radius parameter that is passed to this function is used as
     * the standard deviation, and the radius of effect is the
     * standard deviation * 2.  It's a little confusing.
     * <DP> modified scaling, so that matrix_lenght = 1+2*radius parameter
     */
	radius = (float)fabs(0.5*radius) + 0.25f;
	
	std_dev = radius;
	radius = std_dev * 2;
	
	/* go out 'radius' in each direction */
	matrix_length = (int)(2 * ceil(radius-0.5) + 1);
	if (matrix_length <= 0) matrix_length = 1;
//	matrix_midpoint = matrix_length/2 + 1;
	*matrix = malloc(matrix_length * sizeof(float));
    cMatrix = *matrix;

	
	
	/*  Now we fill the matrix by doing a numeric integration approximation
     * from -2*std_dev to 2*std_dev, sampling 50 points per pixel.
     * We do the bottom half, mirror it to the top half, then compute the
     * center point.  Otherwise asymmetric quantization errors will occur.
     *  The formula to integrate is e^-(x^2/2s^2).
     */
	
	/* first we do the top (right) half of matrix */
	for (i = matrix_length/2 + 1; i < matrix_length; i++)
    {
		float base_x = i - (float)floor((float)(matrix_length/2)) - 0.5f;
		sum = 0;
		for (j = 1; j <= 50; j++)
		{
			if ( base_x+0.02*j <= radius ) 
				sum += (float)exp (-(base_x+0.02*j)*(base_x+0.02*j) / 
                                   (2*std_dev*std_dev));
		}
		cMatrix[i] = sum/50;
    }
	
	/* mirror the thing to the bottom half */
	for (i=0; i<=matrix_length/2; i++) {
		cMatrix[i] = cMatrix[matrix_length-1-i];
	}
	
	/* find center val -- calculate an odd number of quanta to make it symmetric,
     * even if the center point is weighted slightly higher than others. */
	sum = 0;
	for (j=0; j<=50; j++)
    {
		sum += (float)exp (-(0.5+0.02*j)*(0.5+0.02*j) /
                           (2*std_dev*std_dev));
    }
	cMatrix[matrix_length/2] = sum/51;
	
	/* normalize the distribution by scaling the total sum to one */
	sum=0;
	for (i=0; i<matrix_length; i++) 
    {
        sum += cMatrix[i];
    }
	for (i=0; i<matrix_length; i++) 
    {
        cMatrix[i] = cMatrix[i] / sum;
    }
	
    
	return matrix_length;
}

/**
 * @brief  
 * generates a lookup table for every possible product of 0-255 and
 * each value in the convolution matrix.  The returned array is
 * indexed first by matrix position, then by input multiplicand (?)
 * value. 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (float *)genLookupTableWithMatrix:(float *)cMatrix andMatrixLen:(int)cMatrixLen;
{
	float *lookup_table = malloc(cMatrixLen * 256 *sizeof(float));
	float *lookup_table_p = lookup_table;
	float *cmatrix_p      = cMatrix;
	
	for (int i = 0; i < cMatrixLen; i++)
    {
        
		for (int j=0; j<256; j++)
		{
			*(lookup_table_p++) = *cmatrix_p * (float)j;
		}
        
		cmatrix_p++;
    }
	
	return lookup_table;
}

/**
 * @brief  素描的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blurLineWithLookupTable:(float *)lookupTable 
                     withMatrix:(float *)matrix 
                  withMatrixLen:(int)matrixLength 
                    withSrcLine:(unsigned char *)srcLine 
                    withDstLine:(unsigned char *)dstLine 
                      withWidth:(int)width 
                        withBpp:(int)bpp;
{
	ASSERT_VOID(lookupTable);
	ASSERT_VOID(matrix);
	ASSERT_VOID(matrixLength >= 0);
	ASSERT_VOID(srcLine);
	ASSERT_VOID(dstLine);
	ASSERT_VOID(width > 0);
	ASSERT_VOID(bpp == 3 || bpp == 4);
    
    
    
	float scale;
	float sum;
	int i=0, j=0;
	int row;
	int matrixMiddle = matrixLength/2;
	
	float *cmatrix_p;
	unsigned char  *cur_col_p;
	unsigned char  *cur_col_p1;
	unsigned char  *dest_col_p;
	float *ctable_p;
	
	/* this first block is the same as the non-optimized version --
     * it is only used for very small pictures, so speed isn't a
     * big concern.
     */
	if (matrixLength > width)
    {
		for (row = 0; row < width ; row++)
		{
			scale=0;
			/* find the scale factor */
			for (j = 0; j < width ; j++)
			{
				/* if the index is in bounds, add it to the scale counter */
				if ((j + matrixMiddle - row >= 0) &&
					(j + matrixMiddle - row < matrixLength))
					scale += matrix[j + matrixMiddle - row];
			}
			for (i = 0; i<bpp; i++)
			{
				sum = 0;
				for (j = 0; j < width; j++)
				{
					if ((j >= row - matrixMiddle) &&
						(j <= row + matrixMiddle))
						sum += srcLine[j*bpp + i] * matrix[j];
				}
				dstLine[row*bpp + i] = (unsigned char)(0.5f + sum / scale);
			}
		}
    }
	else
    {
		/* for the edge condition, we only use available info and scale to one */
		for (row = 0; row < matrixMiddle; row++)
		{
			/* find scale factor */
			scale=0;
			for (j = matrixMiddle - row; j<matrixLength; j++)
				scale += matrix[j];
			for (i = 0; i<bpp; i++)
			{
				sum = 0;
				for (j = matrixMiddle - row; j<matrixLength; j++)
				{
					sum += srcLine[(row + j-matrixMiddle)*bpp + i] * matrix[j];
				}
				dstLine[row*bpp + i] = (unsigned char)(0.5f + sum / scale);
			}
		}
		/* go through each pixel in each col */
		dest_col_p = dstLine + row*bpp;
		for (; row < width-matrixMiddle; row++)
		{
			cur_col_p = (row - matrixMiddle) * bpp + srcLine;
			for (i = 0; i<bpp; i++)
			{
				sum = 0;
				cmatrix_p = matrix;
				cur_col_p1 = cur_col_p;
				ctable_p = lookupTable;
				for (j = matrixLength; j>0; j--)
				{
					sum += *(ctable_p + *cur_col_p1);
					cur_col_p1 += bpp;
					ctable_p += 256;
				}
				cur_col_p++;
				*(dest_col_p++) = (unsigned char)(0.5f + sum);
			}
		}
		
		/* for the edge condition , we only use available info, and scale to one */
		for (; row < width; row++)
		{
			/* find scale factor */
			scale=0;
			for (j = 0; j< width-row + matrixMiddle; j++)
				scale += matrix[j];
			for (i = 0; i<bpp; i++)
			{
				sum = 0;
				for (j = 0; j<width-row + matrixMiddle; j++)
				{
					sum += srcLine[(row + j-matrixMiddle)*bpp + i] * matrix[j];
				}
				dstLine[row*bpp + i] = (unsigned char) (0.5f + sum / scale);
			}
		}
    }
}

/**
 * @brief  色彩减淡
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_ColorDodge(unsigned char *lookup,double opacity)
{
	ASSERT_VOID(opacity >= 0 && opacity <= 1.0);
    
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0; j < 255; j++)
		{
			lookup[i * 256 + j] = (unsigned char)(i * (1-opacity) + MIN( i * 255 / (255 - j),255) * opacity);
		}
        
	}
	double mixColor = 255 * opacity;
	for (int i = 0; i < 256; i++)
	{
		lookup[i * 256 + 255] = (unsigned char)(i * (1-opacity) + mixColor);
	}
}

/**
 * @brief  素描的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GenerateLookupTable(unsigned char *lookup,double opacity)
{
	//初始化LookupTable默认值
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0 ; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)i;
		}
	}
    
	ASSERT_VOID(opacity >= 0 && opacity <= 1.0);
    GLT_ColorDodge(lookup,opacity);
    
}

/**
 * @brief  素描的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void	AdjustBlendModeCurve(ImageInfo *srcBitmap,
							 ImageInfo *blendBitmap,
                             unsigned char *lookup)
{
    
	int width		= srcBitmap.width;
	int height		= srcBitmap.height;
	int bpp			= srcBitmap.bytesPerPixel;
	unsigned char *srcBmp	= srcBitmap.data;
	int stride		= srcBitmap.bytesPerRow;
	int blendWidth	= blendBitmap.width;
	int blendHeight	= blendBitmap.height;
	int blendBpp	= blendBitmap.bytesPerPixel;
	unsigned char *blendBmp	= blendBitmap.data;
    
	int offset	= stride - width * bpp;
//    int offset2 = blendBitmap.bytesPerRow - blendWidth * blendBpp;
    
	ASSERT_VOID(width == blendWidth);
	ASSERT_VOID(height == blendHeight);
	ASSERT_VOID(bpp == blendBpp);
    
    //如果两个都是全通道
    {
        for (int i = 0; i < height; ++i)
        {
            for (int j = 0; j < width; ++j)
            {
                int red1 = srcBmp[0];
                int red2 = blendBmp[0];
                int green1 = srcBmp[1];
                int green2 = blendBmp[1];
                int blue1 = srcBmp[2];
                int blue2 = blendBmp[2];
                int r  = red1 *256 + red2;
                int g = green1 *256 + green2;
                int b = blue1 *256 + blue2;
                srcBmp[0] = lookup[r];
                srcBmp[1] = lookup[g];
                srcBmp[2] = lookup[b];
                srcBmp	+= bpp;
                blendBmp+= bpp;
                
            }
            srcBmp  += offset;
            blendBmp+= offset;
        }
    }
		
		
}
/**
 * @brief 调整两个图层
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)BlendModeCurve:(ImageInfo *)srcBitmap 
             withBlend:(ImageInfo *)blendBitmap 
            withlookup:(unsigned char *)lookup
{
    
	int width		= srcBitmap.width;
	int height		= srcBitmap.height;
	int bpp			= srcBitmap.bytesPerPixel;
	unsigned char *srcBmp	= srcBitmap.data;
	int stride		= srcBitmap.bytesPerRow;
	int blendWidth	= blendBitmap.width;
	int blendHeight	= blendBitmap.height;
	int blendBpp	= blendBitmap.bytesPerPixel;
	unsigned char *blendBmp	= blendBitmap.data;
    
	int offset	= stride - width * bpp;
    //    int offset2 = blendBitmap.bytesPerRow - blendWidth * blendBpp;
    
	ASSERT_VOID(width == blendWidth);
	ASSERT_VOID(height == blendHeight);
	ASSERT_VOID(bpp == blendBpp);
    
    //如果两个都是全通道
    {
        for (int i = 0; i < height; ++i)
        {
            for (int j = 0; j < width; ++j)
            {
                int red1 = srcBmp[0];
                int red2 = blendBmp[0];
                int green1 = srcBmp[1];
                int green2 = blendBmp[1];
                int blue1 = srcBmp[2];
                int blue2 = blendBmp[2];
                int r  = red1 - red2;
                int g = green1 - green2;
                int b = blue1 - blue2;
                srcBmp[0] = CLAMP0255(r);
                srcBmp[1] = CLAMP0255(g);
                srcBmp[2] = CLAMP0255(b);
                srcBmp	+= bpp;
                blendBmp+= bpp;
                
            }
            srcBmp  += offset;
            blendBmp+= offset;
        }
    }  
}
/**
 * @brief  
 * 两个图层做滤色混合
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendMode:(ImageInfo *)srcBitmap withBlend:(ImageInfo *)blendBitmap withOpacity:(double)opacity
{
	int width		= srcBitmap.width;
	int height		= srcBitmap.height;
	int bpp			= srcBitmap.bytesPerPixel;
	int blendWidth	= blendBitmap.width;
	int blendHeight	= blendBitmap.height;
	int blendBpp	= blendBitmap.bytesPerPixel;
    
	ASSERT_VOID(width == blendWidth);
	ASSERT_VOID(height == blendHeight);
	ASSERT_VOID(bpp == blendBpp);
	ASSERT_VOID(opacity >= 0 &&opacity <= 1.0);
    
	//构造Lookup Table
	unsigned char *lookupTable = malloc(256 * 256 * sizeof(unsigned char ));//256 * 256
	GenerateLookupTable(lookupTable,opacity);
    
	//进行调整
	AdjustBlendModeCurve(srcBitmap,blendBitmap,lookupTable);
    if (lookupTable)
    {
        free(lookupTable);
    }
    lookupTable = NULL;
}
/**
 * @brief  
 * 混合两个图层
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendMode:(ImageInfo *)srcBitmap withBlend:(ImageInfo *)blendBitmap 
                                          withMode:(int)mode 
                                       withOpacity:(double)opacity
{
	int width		= srcBitmap.width;
	int height		= srcBitmap.height;
	int bpp			= srcBitmap.bytesPerPixel;
	int blendWidth	= blendBitmap.width;
	int blendHeight	= blendBitmap.height;
	int blendBpp	= blendBitmap.bytesPerPixel;
    
	ASSERT_VOID(width == blendWidth);
	ASSERT_VOID(height == blendHeight);
	ASSERT_VOID(bpp == blendBpp);
	ASSERT_VOID(opacity >= 0 &&opacity <= 1.0);
    
	//构造Lookup Table
	unsigned char *lookupTable = malloc(256 * 256 * sizeof(unsigned char ));//256 * 256
    
    //初始化LookupTable默认值
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0 ; j < 256; j++)
		{
			lookupTable[i * 256 + j] = (unsigned char)i;
		}
	}    
	ASSERT_VOID(opacity >= 0 && opacity <= 1.0);
    switch (mode) 
    {
        case KBlendModeSoftLight:
            GLT_SoftLight(lookupTable, opacity);
            break;
        case KBlendModeReversalfilm:
            GLT_Overlay(lookupTable, opacity);
            break;
        case KBlendModeHardLight:
            GLT_HardLight(lookupTable, opacity);
            break;
        case KBlendModeNeon:
            GLT_Lighten(lookupTable, opacity);
//            GLT_Add(lookupTable, opacity);            
            break;
        default:
//            GLT_Multiply(lookupTable, opacity);
//            GLT_Screen(lookupTable, opacity);   
            break;
    }  
	//进行调整
	AdjustBlendModeCurve(srcBitmap,blendBitmap,lookupTable);
    if (lookupTable)
    {
        free(lookupTable);
    }
    lookupTable = NULL;
}
/**
 * @brief  柔和
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_SoftLight(unsigned char *lookup,double opacity)
{
	ASSERT_VOID(opacity >= 0 && opacity <= 1.0);
    
	for (int i = 0; i < 256; i++)
	{
#if 1
        // 小于等于1/2
		for (int j = 0; j <= 128; j++)
		{
            double result = i + (2 * j / 255.0 - 1) * (i / 255.0 - i * i / 65025.0) * 255.0;
			lookup[i * 256 + j] = (unsigned char)(i * (1-opacity) + result * opacity);
		}
        // 大于1/2
        for (int j = 129; j < 256; j++)
		{
            double result = i + ( 2 * j / 255.0 - 1) * (sqrt(i / 255.0) - i / 255.0) * 255.0;
			lookup[i * 256 + j] = (unsigned char)(i * (1-opacity) + result * opacity);
		}        
#endif
#if 0
        for (int j = 0; j < 256; j++)
        {
            double result = i + j - i * j / 255;
            lookup[i * 256 + j] = (i * (1-opacity) + result * opacity);
        }
#endif
	}
}
/**
 * @brief  强光
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_HardLight(unsigned char *lookup,double opacity)
{	
	for (int i = 0; i < 256; i++)
	{
		// 小于等于1/2
		for (int j = 0; j <= 128; j++)
		{
			lookup[i * 256 + j] = (unsigned char)(i * (1 - opacity) + 2 * i * j / 255.0 * opacity);
		}        
		// 大于1/2
		for (int j = 129; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)(i * (1 - opacity) + ( 255 - 2 * (255 - i) * (255 - j) / 255 ) * opacity);
		}
	}
}
/**
 * @brief  变亮
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_Lighten(unsigned char *lookup,double opacity)
{
    ASSERT_VOID(opacity >= 0 && opacity <= 1.0);    
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)(i * (1 - opacity) + MAX(i, j) * opacity);
		}        
	}
}

#if 0
 
/**
 * @brief  滤色
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_Screen(unsigned char *lookup,double opacity)
{
    ASSERT_VOID(opacity >= 0 && opacity <= 1.0);    
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)( i * (1-opacity) + (255 - (255 - i) * (255 - j) / 255) * opacity);
		}        
	}
}
/**
 * @brief  正片叠底
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_Multiply(unsigned char *lookup,double opacity)
{
    ASSERT_VOID(opacity >= 0 && opacity <= 1.0);    
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)( i * (1-opacity) + i * j / 255 * opacity);
		}        
	}
}

#endif

/**
 * @brief  叠加
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_Overlay(unsigned char *lookup,double opacity)
{
    ASSERT_VOID(opacity >= 0 && opacity <= 1.0);    

    //小于等于 1/2
	for (int i = 0; i <= 128; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)( i * (1-opacity) + 2 * i * j / 255.0 * opacity );
		}
	}
	
	//大于1/2
	for (int i = 129; i < 256; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			lookup[i * 256 + j] = (unsigned char)( i * (1-opacity) + ( 255 - CLAMP0255(2 * (255 - i) * (255 - j) / 255 ))* opacity );
		}
	}
}


/**
 * @brief 增加杂点，杂点幅度[0,255]
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)addNoiseWithImageInfo:(ImageInfo *)imageInfo andDegree:(int)degree
{
    int width = imageInfo.width;
	int height = imageInfo.height;
	int bpp	= imageInfo.bytesPerPixel;
	unsigned char *imgPiexl = imageInfo.data;
	int stride = imageInfo.bytesPerRow;    
	int offset	= stride - width * bpp;
    
    srand((unsigned)time(0));
    for (int i = 0; i < height; ++i)
    {
        for (int j = 0; j < width; ++j)
        {
            int noise = rand() % (2 * degree) - degree;
            
            int r = imgPiexl[0];
            int g = imgPiexl[1];
            int b = imgPiexl[2];
            imgPiexl[0] = CLAMP0255(r + noise);
            imgPiexl[1] = CLAMP0255(g + noise);
            imgPiexl[2] = CLAMP0255(b + noise);
            imgPiexl += bpp;
        }
        imgPiexl += offset;
    }
}
/**
 * @brief  像素霓虹处理 
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)neonWithInImage:(ImageInfo *)imageInfo;
{
    ImageInfo *clone = [imageInfo clone];
    int width = imageInfo.width;
	int height = imageInfo.height;
	int bpp	= imageInfo.bytesPerPixel;
	unsigned char *srcBmp = clone.data;
    int stride = imageInfo.bytesPerRow;
	int offset = stride - width * bpp;
    
#if 0    
    // 第一种方式检测霓虹灯边缘算法
    for (int j = 0; j < height; ++j)
    {
        for (int i = 0; i < width; ++i)
        {
            int r1 = srcBmp[0];
            int g1 = srcBmp[1];
            int b1 = srcBmp[2];  
            int r2, g2, b2;
            if (i == width-1) 
            {
                r2 = g2 = b2 = 255;
            }
           else
           {
               r2 = (srcBmp + bpp)[0];
               g2 = (srcBmp + bpp)[1];
               b2 = (srcBmp + bpp)[2];
           }
                int r3, g3, b3;
            if (j == height - 1) 
            {
                r3 = g3 = b3 = 255;
            }
            else 
            {
                r3 = (srcBmp + stride)[0];
                g3 = (srcBmp + stride)[1];
                b3 = (srcBmp + stride)[2];
            }

            int rr = 3 * sqrt((r1 - r2) * (r1 - r2) + (r1 - r3) * (r1 - r3));
            int gg = 3 * sqrt((g1 - g2) * (g1 - g2) + (g1 - g3) * (g1 - g3));
            int bb = 3 * sqrt((b1 - b2) * (b1 - b2) + (b1 - b3) * (b1 - b3));
            srcBmp[0] = CLAMP0255(rr);
            srcBmp[1] = CLAMP0255(gg);
            srcBmp[2] = CLAMP0255(bb);
            
            srcBmp += bpp;           
        }
        srcBmp += offset;
    }
#endif
    
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
                dst[i] = (int)sqrt((a - d) * (a - d) + (b - c) * (b - c));
            } // i
#if 0
            if (sum < 50)//60
            {
                dst[3] = 0;
            }
            else if (sum > 120)
            {
                dst[0] = 255;
                dst[1] = 255;
                dst[2] = 255;
            }
            else if (50 < sum < 120)
            {
                dst[0] = red;//121;
                dst[1] = green;//0;
                dst[2] = blue;
            }
#endif
            srcBmp += bpp;
            dst += bpp;
        } // x
        srcBmp += offset;
        dst += offset;
    } // y
    // 处理图片最上边和最左边的像素 用相邻的像素填充
    unsigned char *pixelArray = imageInfo.data;
    for (int j = 0; j < height; j++)
    {
        for (int i = 0; i < width; i++)
        {
            if (i == 0 && j == 0)
            {
                pixelArray[0] = (pixelArray + stride + bpp)[0];
                pixelArray[1] = (pixelArray + stride + bpp)[1];
                pixelArray[2] = (pixelArray + stride + bpp)[2];
            }
            else if (j == 0 && i > 0) 
            {
                pixelArray[0] = (pixelArray + stride)[0];
                pixelArray[1] = (pixelArray + stride)[1];
                pixelArray[2] = (pixelArray + stride)[2];
            }
            else if (i == 0 && j > 0) 
            {
                pixelArray[0] = (pixelArray + bpp)[0];
                pixelArray[1] = (pixelArray + bpp)[1];
                pixelArray[2] = (pixelArray + bpp)[2];
            }
            pixelArray += bpp;
        }
        pixelArray += offset;
    }
    [clone release];
}
/**
 * @brief  
 * 给图层着色
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)addColourToImageInfo:(ImageInfo *)imageInfo hue:(float)h saturation:(float)sat;
{
    NSLog(@"%f,%f", h, sat);
    
    int width = imageInfo.width;
	int height = imageInfo.height;
	int bpp	= imageInfo.bytesPerPixel;
	unsigned char *srcBmp = imageInfo.data;
    int stride = imageInfo.bytesPerRow;
	int offset = stride - width * bpp;    
    
    float hue = 0.0, saturation = 0.0, bright = 0.0;
    unsigned char r, g, b, r1, g1, b1;
    for (int j = 0; j < height; j++)
    {
        for (int i = 0; i < width; i++)
        {
            r = srcBmp[0];
            g = srcBmp[1];
            b = srcBmp[2];
            [Common red:r green:g blue:b toHue:&hue saturation:&saturation brightness:&bright];
            if (bright > 40) 
            {
                srcBmp[0] = 255;
                srcBmp[1] = 255;
                srcBmp[2] = 255;
            }
            else if (bright <= 40 && bright > 30)
            {
                bright += 200;  
                bright = CLAMP0255(bright);
                [Common hue:h saturation:sat brightness:bright toRed:&r1 green:&g1 blue:&b1];
                srcBmp[0] = r1;
                srcBmp[1] = g1;
                srcBmp[2] = b1;
            }
            else if (bright <= 30 && bright > 20)
            {
                bright += 180;
                bright = CLAMP0255(bright);
                [Common hue:h saturation:sat brightness:bright toRed:&r1 green:&g1 blue:&b1];
                srcBmp[0] = r1;
                srcBmp[1] = g1;
                srcBmp[2] = b1;
            }
            else if (bright <= 20)
            {
                srcBmp[3] = 0;
            }
            
            srcBmp += bpp; 
        }
        srcBmp += offset;
    }
}
/**
 * @brief  
 * 克隆图层赋值给原图层
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendMode:(ImageInfo *)imageInfo withClone:(ImageInfo *)clone 
{
    int width = imageInfo.width;
	int height = imageInfo.height;
	int bpp	= imageInfo.bytesPerPixel;
	unsigned char *srcBmp = imageInfo.data;
    int stride = imageInfo.bytesPerRow;
	int offset = stride - width * bpp;    
    
    unsigned char *cloneBmp = clone.data;
    
    for (int j = 0; j < height; j++)
    {
        for (int i = 0; i < width; i++)
        {
            int alpha = srcBmp[3];
            if (alpha == 0)
            {
                srcBmp[0] = cloneBmp[0];
                srcBmp[1] = cloneBmp[1];
                srcBmp[2] = cloneBmp[2];
                srcBmp[3] = cloneBmp[3];                
            }            
            srcBmp += bpp; 
            cloneBmp += bpp;
        }
        srcBmp += offset;
        cloneBmp += offset;
    }
}
/**
 * @brief  单色化
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)piexlSingleWithInImageInfo:(ImageInfo *)imageInfo
{
    unsigned char *imgPixel = imageInfo.data;
	int imgWidth = imageInfo.width;
	int imgHeight = imageInfo.height;
    // 获取每个像素字节数
    int imgBpp = imageInfo.bytesPerPixel;
    // 跨距，一行像素的宽度
    int imgBytesPerRow = imageInfo.bytesPerRow;
    int offset = imgBytesPerRow - imgWidth * imgBpp;
  
    for (int i = 0; i < imgHeight; ++i)
    {
        for (int j = 0; j < imgWidth; ++j)
        {
            int red = (unsigned char)imgPixel[0];
            int green = (unsigned char)imgPixel[1];
            int blue = (unsigned char)imgPixel[2];
//            unsigned char luminace = (unsigned char)(0.2 * red + 0.88 * green + 0.1 * blue);
            unsigned char luminace = (unsigned char)(0.299 * red + 0.58 * green + 0.11 * blue);
            imgPixel[0] = luminace;
            imgPixel[1] = luminace;
            imgPixel[2] = luminace;
            imgPixel += imgBpp;
        }
        imgPixel += offset;
    }
#if 0  
    imgPixel += imgBytesPerRow;
    for (int i = 1; i < imgHeight; ++i)
    {
        imgPixel += imgBpp;
        for (int j = 1; j < imgWidth; ++j)
        {
            int red = (unsigned char)imgPixel[0];
            int green = (unsigned char)imgPixel[1];
            int blue = (unsigned char)imgPixel[2];
            int total = red + green + blue;
            if (total < 36*3) 
            {
                imgPixel[3] = 0.0;
            }
            if (36*3 < total < 128*3)
            {
                imgPixel[0] = 255;
                imgPixel[1] = 0;
                imgPixel[2] = 0;  
            }
            if (total > 128*3)
            {
                imgPixel[0] = 255;
                imgPixel[1] = 255;
                imgPixel[2] = 255; 
            }
            imgPixel += imgBpp;
        }
        imgPixel += offset;
    }
 #endif   
}
/**
 * @brief  
 * 模拟hdr
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)exposure: (ImageInfo*)info 
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
	[EffectMethods adjustCurveWithInImage:info withLookup:lookup withChanel:EChanelRGB];
}

#pragma mark -
#pragma mark ConcentricCircle  ---- 圆形裁剪算法

/**
 * @brief 获取给定点在同心圆中的位置
 * 
 * @param [in] pt: 指定的点
 * @param [in] pCircle: 聚光灯的参数信息
 * @return
 * @note 
 */
+ (PositionTypeOfPointInConcentricCircle)getPositionTypeInCircle:(CGPoint)pt circle:(ConcentricCirclePtr)pCircle;
{
	CGFloat xMin = pCircle->x - pCircle->maxRadius;
	CGFloat xMax = pCircle->x + pCircle->maxRadius;
	CGFloat yMin = pCircle->y - pCircle->maxRadius;
	CGFloat yMax = pCircle->y + pCircle->maxRadius;
	
	if (!(pt.x >= xMin && pt.x <= xMax && pt.y >=yMin && pt.y <= yMax)) 
	{
		return PositionOutMaxCircle;
	}
	
	pt.x -= pCircle->x;
	pt.y -= pCircle->y;
	
	CGFloat distance = pt.x*pt.x + pt.y*pt.y;
	if (distance > pCircle->maxRadius * pCircle->maxRadius)
		return PositionOutMaxCircle;
	else if (distance <= pCircle->minRadius * pCircle->minRadius)
		return PositionInMinCircle;
	else
		return PositionInRing;
}

/**
 * @brief 同心圆裁剪算法 在环形范围内，亮度一次递减，类似于聚光灯效果
 * 
 * @param [in] info: 图片对象
 * @param [in] pCircle: 聚光灯的参数信息
 * @param [out]
 * @return
 * @note 
 */
+ (void)concentricCircleClip:(ImageInfo*)info circle:(ConcentricCirclePtr)pCircle
{
	int width	= info.width;
	int height	= info.height;
	int stride	= info.bytesPerRow;
	int bpp		= info.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char* data	= info.data;
	unsigned char* endData = info.data + height * stride;
	
	CGPoint pt;
	CGFloat dis, delta;
	CGFloat offsetx,offsety;
	CGFloat ringDis = pCircle->maxRadius - pCircle->minRadius;
	
	int i = 0, j = 0;
	while (data != endData)
	{
		pt = CGPointMake(i, j);
		
		int pos = [EffectMethods getPositionTypeInCircle:pt circle:pCircle];
		if (pos == PositionOutMaxCircle)
		{
			data[0] = 0;
			data[1] = 0;
			data[2] = 0;
		}
		else if (pos != PositionInMinCircle)
		{
			offsetx = pCircle->x - i;
			offsety = pCircle->y - j;
			dis = sqrtf(offsetx*offsetx + offsety*offsety) - pCircle->minRadius;
			delta = 1.0f - dis / ringDis;
			data[0] = (unsigned char)(data[0] * delta + 0.5f);
			data[1] = (unsigned char)(data[1] * delta + 0.5f);
			data[2] = (unsigned char)(data[2] * delta + 0.5f);
		}
		
		data += bpp;
		if (++i == width)
		{
			++j;
			i = 0;
			data += offset;
		}
	}
}

/**
 * @brief  在矩形范围外，图片模糊
 * viewArray为空时，是用来处理特效列表的缩略图的
 * @param [in] info: 图片对象
 * @param [in] pRectangle: 矩形的参数信息
 * @param [in] viewArray :包含三个元素，第一个是父视图的imageview，第二个是RectangleClipView，第三个是RectangleClipView中的clearview
 * @param [in] scale:是图片与imageview的大小比例
 * @param [out]
 * @return
 * @note 
 */
+(void)rectangleClip:(ImageInfo *)imageInfo withClearView:(UIView *)clearView withRotationAngle:(CGFloat)rotationAngle withScale:(CGFloat)scale
{
#if 1

    int theheight = imageInfo.height;
    int thewidth = imageInfo.width;
 
    unsigned char *inbits = imageInfo.data;
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    CGPoint clearCenter = clearView.center;
    UIView *superView = clearView.superview.superview;
    clearCenter = [clearView.superview convertPoint:clearCenter toView:superView];
    CGRect clearBounds = clearView.bounds;
    CGFloat clearHeight = clearBounds.size.height/2;
    CGFloat offset ;
    CGFloat cosValue = fabsf(cosf(rotationAngle));
    if (cosValue < 0.000001)
    {
        offset = clearHeight;
    }
    else
    {
        offset = (clearHeight)/cosValue;
    }
    
    BOOL isIn = NO;
    for (int y = 0; y < theheight; ++y)
    {
        for (int x = 0; x < thewidth; ++x)
        {
            //判断像素点是否在矩形区域内
            CGFloat xView = x/scale;
            CGFloat yView = y/scale;
            CGFloat xLine,yLine;
            if (isnan(tanf(rotationAngle)))
            {
                xLine = clearCenter.x;
                if (x > xLine - clearHeight && x < xLine + clearHeight) 
                {
                    isIn = YES;
                }
                else
                {
                    isIn = NO;
                }
            }
            else
            {
                yLine = tanf(rotationAngle) *(xView - clearCenter.x) + clearCenter.y;
                if (yView < yLine + offset && yView > yLine - offset)
                {
                    isIn = YES;
                }
                else
                {
                    isIn = NO;
                }
            }
            //如果点在矩形区域内，将像素点的像素设置为透明，显示底下原图
            if (isIn)
            {
                int currentIndex = ((y * thewidth) + x) * 4;
                inbits[currentIndex] = red;
                inbits[currentIndex + 1] = green;
                inbits[currentIndex + 2] = blue;
                inbits[currentIndex + 3] = alpha;
            }
        }
    }

#else
    GLuint imgWidth = imageInfo.width;
	GLuint imgHeight = imageInfo.height;
    //获取number of bytes/Pixel
    GLuint imgBpp = imageInfo.bytesPerPixel;
    //跨距，一行像素的宽度
    GLuint imgBytesPerRow = imageInfo.bytesPerRow;
    
    int radius = 2;
    // generate convolution matrix and make sure it's smaller than each dimension
	float *cmatrix = NULL;
	int cmatrix_length = [EffectMethods genConvolveMatrixWithRadius:radius andMatrix:&cmatrix];
    
	// generate lookup table
	float *ctable = [EffectMethods genLookupTableWithMatrix:cmatrix andMatrixLen:cmatrix_length];
    
	ImageInfo *clone = [imageInfo clone];
    
    
	//横向
	for (int i = 0; i < imgHeight; i++)
	{
        [EffectMethods tiltShiftBlurLineWithLookupTable:ctable
                                             withMatrix:cmatrix
                                          withMatrixLen:cmatrix_length
                                            withSrcLine:[imageInfo getRowWithLine:i]
                                            withDstLine:[clone getRowWithLine:i]
                                              withWidth:imgWidth
                                                withBpp:imgBpp
                                          withViewArray:viewArray
                                              withScale:scale
                                                withNum:i
                                               withFlag:YES];

	}
    
	//纵向
	unsigned char *srcLine = malloc(imgBpp * imgHeight * sizeof(unsigned char));
	unsigned char *dstLine = malloc(imgBpp * imgHeight * sizeof(unsigned char));
	for (int i = 0; i < imgWidth; i++)
	{
        [clone getColumnWithColomn:srcLine Withline:i];
        [EffectMethods tiltShiftBlurLineWithLookupTable:ctable
                                             withMatrix:cmatrix
                                          withMatrixLen:cmatrix_length
                                            withSrcLine:srcLine
                                            withDstLine:dstLine
                                              withWidth:imgHeight
                                                withBpp:imgBpp
                                          withViewArray:viewArray 
                                              withScale:scale
                                                withNum:i
                                               withFlag:NO];
        [clone setColumnWithColumn:dstLine WithLine:i];
        
	}
    
	size_t size = (size_t)imgBytesPerRow * imgHeight;
	memcpy(imageInfo.data,clone.data,size);
    
    if (srcLine)
    {
        free(srcLine);
    }
    srcLine = NULL;
    if (dstLine)
    {
        free(dstLine);
    }
    dstLine = NULL;
    
    if (cmatrix)
    {
        free(cmatrix);
    }
    cmatrix = NULL;
    [clone release];
    if (ctable)
    {
        free(ctable);
    }
    ctable = NULL;
#endif
}


/**
 * @brief  移轴中模糊的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)tiltShiftBlurLineWithLookupTable:(float *)lookupTable 
                              withMatrix:(float *)matrix 
                           withMatrixLen:(int)matrixLength 
                             withSrcLine:(unsigned char *)srcLine 
                             withDstLine:(unsigned char *)dstLine 
                               withWidth:(int)width 
                                 withBpp:(int)bpp
                           withViewArray:(NSArray *)viewArray
                               withScale:(CGFloat)sizeScale
                                 withNum:(int)num
                                withFlag:(BOOL)flag
{
	ASSERT_VOID(lookupTable);
	ASSERT_VOID(matrix);
	ASSERT_VOID(matrixLength >= 0);
	ASSERT_VOID(srcLine);
	ASSERT_VOID(dstLine);
	ASSERT_VOID(width > 0);
	ASSERT_VOID(bpp == 3 || bpp == 4);
    
    
    
	float scale;
	float sum;
	int i=0, j=0;
	int row;
	int matrixMiddle = matrixLength/2;
	
	float *cmatrix_p;
	unsigned char  *cur_col_p;
	unsigned char  *cur_col_p1;
	unsigned char  *dest_col_p;
	float *ctable_p;
	
	/* this first block is the same as the non-optimized version --
     * it is only used for very small pictures, so speed isn't a
     * big concern.
     */
	if (matrixLength > width)
    {
		for (row = 0; row < width ; row++)
		{
            CGPoint pointInImage;
            if (flag)
            {
                pointInImage.x = row;
                pointInImage.y = num;
            }
            else
            {
                pointInImage.x = num;
                pointInImage.y = row;
            }
            BOOL isIn = [EffectMethods isInClearView:pointInImage withViewArray:viewArray withScale:sizeScale];
            if (isIn) 
            {
                for (i = 0; i<bpp; i++)
                {
                    dstLine[row *bpp + i] = srcLine[row *bpp + i];
                }
                
                
            }
            else
            {
                scale=0;
                /* find the scale factor */
                for (j = 0; j < width ; j++)
                {
                    /* if the index is in bounds, add it to the scale counter */
                    if ((j + matrixMiddle - row >= 0) &&
                        (j + matrixMiddle - row < matrixLength))
                        scale += matrix[j + matrixMiddle - row];
                }
                for (i = 0; i<bpp; i++)
                {
                    sum = 0;
                    for (j = 0; j < width; j++)
                    {
                        if ((j >= row - matrixMiddle) &&
                            (j <= row + matrixMiddle))
                            sum += srcLine[j*bpp + i] * matrix[j];
                    }
                    dstLine[row*bpp + i] = (unsigned char)(0.5f + sum / scale);
                }
            }
			
		}
    }
	else
    {
		/* for the edge condition, we only use available info and scale to one */
		for (row = 0; row < matrixMiddle; row++)
		{
            CGPoint pointInImage;
            if (flag)
            {
                pointInImage.x = row;
                pointInImage.y = num;
            }
            else
            {
                pointInImage.x = num;
                pointInImage.y = row;
            }
            BOOL isIn = [EffectMethods isInClearView:pointInImage withViewArray:viewArray withScale:sizeScale];
            if (isIn) 
            {
                for (i = 0; i<bpp; i++)
                {
                    dstLine[row *bpp + i] = srcLine[row *bpp + i];
                }
                
                
            }
            else
            {
                /* find scale factor */
                scale=0;
                for (j = matrixMiddle - row; j<matrixLength; j++)
                    scale += matrix[j];
                for (i = 0; i<bpp; i++)
                {
                    sum = 0;
                    for (j = matrixMiddle - row; j<matrixLength; j++)
                    {
                        sum += srcLine[(row + j-matrixMiddle)*bpp + i] * matrix[j];
                    }
                    dstLine[row*bpp + i] = (unsigned char)(0.5f + sum / scale);
                }
                
            }
        }
		/* go through each pixel in each col */
		dest_col_p = dstLine + row*bpp;
		for (; row < width-matrixMiddle; row++)
		{
			cur_col_p = (row - matrixMiddle) * bpp + srcLine;
            CGPoint pointInImage;
            if (flag)
            {
                pointInImage.x = row;
                pointInImage.y = num;
            }
            else
            {
                pointInImage.x = num;
                pointInImage.y = row;
            }
            BOOL isIn = [EffectMethods isInClearView:pointInImage withViewArray:viewArray withScale:sizeScale];
            if (isIn)
            {
                for (i = 0; i<bpp; i++)
                {
                    *(dest_col_p++) = *(cur_col_p++);
                }
            }
            else
            {
                for (i = 0; i<bpp; i++)
                {
                    sum = 0;
                    cmatrix_p = matrix;
                    cur_col_p1 = cur_col_p;
                    ctable_p = lookupTable;
                    for (j = matrixLength; j>0; j--)
                    {
                        sum += *(ctable_p + *cur_col_p1);
                        cur_col_p1 += bpp;
                        ctable_p += 256;
                    }
                    cur_col_p++;
                    *(dest_col_p++) = (unsigned char)(0.5f + sum);
                }
            }
		}
		
		/* for the edge condition , we only use available info, and scale to one */
		for (; row < width; row++)
		{
            CGPoint pointInImage;
            if (flag)
            {
                pointInImage.x = row;
                pointInImage.y = num;
            }
            else
            {
                pointInImage.x = num;
                pointInImage.y = row;
            }
            BOOL isIn = [EffectMethods isInClearView:pointInImage withViewArray:viewArray withScale:sizeScale];
            if (isIn)
            {
                for (i = 0; i<bpp; i++)
                {
                    *(dest_col_p++) = srcLine[row * bpp + i];
                }
            }
            else
            {
                /* find scale factor */
                scale=0;
                for (j = 0; j< width-row + matrixMiddle; j++)
                    scale += matrix[j];
                for (i = 0; i<bpp; i++)
                {
                    sum = 0;
                    for (j = 0; j<width-row + matrixMiddle; j++)
                    {
                        sum += srcLine[(row + j-matrixMiddle)*bpp + i] * matrix[j];
                    }
                    dstLine[row*bpp + i] = (unsigned char) (0.5f + sum / scale);
                }
            }
			
		}
    }
}

/**
 * @brief  判断图片上的点pointInImage是否在viewArray第三个view上
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (BOOL)isInClearView:(CGPoint)pointInImage withViewArray:(NSArray *)viewArray withScale:(CGFloat)scale
{
    CGFloat xView = pointInImage.x/scale;
    CGFloat yView = pointInImage.y/scale;
    BOOL isIn = YES;
    if (viewArray == nil)
    {
        if (yView < 40 && yView > 20)
        {
            isIn = YES;
        }
        else
        {
            isIn = NO;
        }
    }
    else
    {
        UIView *superView1 = [viewArray objectAtIndex:0];
        UIView *view = [viewArray objectAtIndex:2];

        CGPoint xyInView = [superView1 convertPoint:CGPointMake(roundf(xView), roundf(yView)) toView:view];

        if (xyInView.x < 0 || xyInView.y < 0 || xyInView.x > view.bounds.size.width || xyInView.y > view.bounds.size.height)
        {
            isIn = NO;
        }
    }

    return isIn;
}


@end
