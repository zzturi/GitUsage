//
//  RedEyeProcess.m
//  Aico
//
//  Created by Mike on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RedEyeProcess.h"
#import <OpenGLES/ES2/gl.h>
#import "UIImage+extend.h"

@implementation RedEyeProcess

@synthesize recoveryArray = recoveryArray_;

static void * g_bitmapData = NULL;

/**
 * @brief  初始化设置
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (id)init 
{
    
    self = [super init];
    if (self) 
    {
        recoveryArray_ = [[NSMutableArray alloc]init];
        remainedOnView = 0;
    }
    return self;
}

/**
 * @brief  析构类对象
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)dealloc
{
    if(g_bitmapData != NULL)
    {
        free (g_bitmapData); 
        g_bitmapData = NULL;
    }
    self.recoveryArray = nil;
    [super dealloc];
}

#pragma -
#pragma mark Public Method

/**
 * @brief  Return a bitmap context using alpha/red/green/blue byte values 
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
CGContextRef CreateRGBABitmapContext (CGImageRef inImage) {
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	int bitmapByteCount; 
	int bitmapBytesPerRow;
	size_t pixelsWide = CGImageGetWidth(inImage); 
	size_t pixelsHigh = CGImageGetHeight(inImage); 
	bitmapBytesPerRow = (pixelsWide * 4); 
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); 
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) {
		fprintf(stderr, "Error allocating color space\n"); 
        return NULL;
	}
    
	// allocate the bitmap & create context 
    if(g_bitmapData != NULL) {
        free (g_bitmapData); 
        g_bitmapData = NULL;
    }
    
	g_bitmapData = malloc(bitmapByteCount); 
    
	if (g_bitmapData == NULL) {
		fprintf (stderr, "Memory not allocated!"); 
		CGColorSpaceRelease( colorSpace ); 
		return NULL;
	}
    //此处用的是kCGImageAlphaPremultipliedLast，可改用kCGImageAlphaNone，以提高效率，因为alpha值用不到
	context = CGBitmapContextCreate (g_bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    
	if (context == NULL) {
		free (g_bitmapData); 
        g_bitmapData = NULL;
		fprintf (stderr, "Context not created!");
	} 
    
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

/**
 * @brief  Return Image Pixel data as an RGBA bitmap 
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
unsigned char *RequestImagePixelData(UIImage *inImage) {
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
	CGContextRef cgctx = CreateRGBABitmapContext(img); 	
	if (cgctx == NULL) { 
		return NULL;
    }	
	CGRect rect = {{0,0},{size.width, size.height}}; 
	CGContextDrawImage(cgctx, rect, img); 
	unsigned char *data = CGBitmapContextGetData (cgctx); 
	CGContextRelease (cgctx);
	return data;
}

/**
 * @brief  Generate image from data bytes 
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
UIImage *GenerateImageFromData(unsigned char* imgPixelData, NSUInteger imgPixelWidth, NSUInteger imgPixelHeight) {
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixelData, imgPixelWidth * imgPixelHeight * 4, NULL);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * imgPixelWidth;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(imgPixelWidth, imgPixelHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
	
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
    return finalImage;
}

/**
 * @brief  由RGB的值计算出HSI模型中Hue的值
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (float)getHueOfHSIModelFromRed:(int)red Green:(int)green Blue:(int)blue
{
    float R = red/255.0;
    float G = green/255.0;
    float B = blue/255.0;
    float min = MIN(MIN(R, G), B);
    float H;
    if (R >= G && R >= B)
    {
        H = (1/3)*M_PI*((G-B)/(R-min));
        return H<0 ? (H+2*M_PI) : H;
    }
    if (G >= R && G >= B)
    {
        H = (1/3)*M_PI*((B-R)/(G-min))+(2/3)*M_PI;
        return H<0 ? (H+2*M_PI) : H;
    }
    if (B >= R && B >= G)
    {
        H = (1/3)*M_PI*((R-G)/(B-min))+(4/3)*M_PI;
        return H<0 ? (H+2*M_PI) : H;
    }
    return 0;
}

/**
 * @brief  由RGB的值计算出HSI模型中Saturation的值
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (float)getSaturationOfHSIModelFromRed:(int)red Green:(int)green Blue:(int)blue
{
    float R = red/255.0;
    float G = green/255.0;
    float B = blue/255.0;
    return (MAX(MAX(R, G), B) - MIN(MIN(R, G), B));
}

/**
 * @brief  由RGB的值计算出HSI模型中Intensity的值
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (float)getIntensityOfHSIModelFromRed:(int)red Green:(int)green Blue:(int)blue
{
    float R = red/255.0;
    float G = green/255.0;
    float B = blue/255.0;
    return (MAX(MAX(R, G), B) + MIN(MIN(R, G), B))/2;
}
/**
 * @brief  源图片经过此函数处理后，一进入去红眼页面拖动图片会不卡（why？）
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)initializeOriginalPicture:(UIImage *)inImage
{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);//宽里面像素点的个数
	GLuint h = CGImageGetHeight(inImageRef);//高里面像素点的个数
    return [GenerateImageFromData(imgPixel, w, h) imageRotatedByDegrees:0];

}

/**
 * @brief  这是点击Fix Red-Eye页面中间的圆后，进行修复红眼的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)fixRedEye:(UIImage *)inImage roundCenter:(CGPoint)center andRadius:(int)r
{
	unsigned char *imgPixel = RequestImagePixelData(inImage);
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);//宽里面像素点的个数
	GLuint h = CGImageGetHeight(inImageRef);//高里面像素点的个数
    
	long wOff = 0;
	long pixOff = 0;	
    
    float hue;
    float sat;
    float intensity;
    
    int arrayCount = [self.recoveryArray count];
    
    if ([self.recoveryArray count] != remainedOnView)
    {
        //有时候你后退几步，然后进行去红眼操作（此时redo按钮会变成灰色），下面的操作去掉数组中保存的多余步骤
        for (int i = remainedOnView; i < arrayCount; i++)
        {
            [self.recoveryArray removeLastObject];
        }
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc]init]; 
    [self.recoveryArray addObject:tempArray];
    remainedOnView++;
	for(GLuint y = 0;y< h;y++) //高
    {
		pixOff = wOff;		
		for (GLuint x = 0; x<w; x++)//宽
        {
            //在圆内
            if ((x - center.x)*(x - center.x) + (y - center.y)*(y - center.y) <= r*r) 
            {
                
                int red = (unsigned char)imgPixel[pixOff];
                int green = (unsigned char)imgPixel[pixOff+1];
                int blue = (unsigned char)imgPixel[pixOff+2];
                hue = [self getHueOfHSIModelFromRed:red Green:green Blue:blue];
                sat = [self getSaturationOfHSIModelFromRed:red Green:green Blue:blue];
                intensity = [self getIntensityOfHSIModelFromRed:red Green:green Blue:blue];
                if (hue > -M_PI/4 && hue < M_PI/4 && sat > 0.15)//hue > -M_PI/4 && hue < M_PI/4 && sat > 0.3
                {
                    [[self.recoveryArray lastObject] addObject:[NSString stringWithFormat:@"%d",pixOff]];//0,pixoff
                    [[self.recoveryArray lastObject] addObject:[NSString stringWithFormat:@"%d",red]];//1,red
                    [[self.recoveryArray lastObject] addObject:[NSString stringWithFormat:@"%d",green]];//2,green
                    [[self.recoveryArray lastObject] addObject:[NSString stringWithFormat:@"%d",blue]];//3,blue
                    
                    int bw = (int)(intensity * 255)/2.5;//(int)(intensity * 255)
                    imgPixel[pixOff] = bw;
                    imgPixel[pixOff+1] = bw;
                    imgPixel[pixOff+2] = bw;
                }
            }
			pixOff += 4;
		}
		wOff += w * 4;
	}
    [tempArray release];
    
    //直接返回GenerateImageFromData(imgPixel, w, h)，会出现莫名其妙的问题，图片全部变成黑色，但调用imageRotatedByDegrees方法，将图片旋转0度后，问题就解决了（why？）
    return [GenerateImageFromData(imgPixel, w, h) imageRotatedByDegrees:0];
//	return GenerateImageFromData(imgPixel, w, h);
}

/**
 * @brief  这是点击Fix Red-Eye页面的后退按钮后，撤销上一步修复红眼操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)backward:(UIImage *)inImage
{
    if (remainedOnView == 0)
    {
        return inImage;
    }
    NSArray *temp = [self.recoveryArray objectAtIndex:(remainedOnView - 1)];
    
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    
    //int足够吗？
    long pixelCount = [temp count];//即像素点个数的四倍
    for (long i = 0; i < pixelCount; i=i+4)
    {
        long number = [[temp objectAtIndex:i]intValue];
        imgPixel[number] = [[temp objectAtIndex:i+1]intValue];  
        imgPixel[number+1] = [[temp objectAtIndex:i+2]intValue]; 
        imgPixel[number+2] = [[temp objectAtIndex:i+3]intValue]; 
    }
    
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	remainedOnView--;//屏幕上显示的点少了一个
    
    return [GenerateImageFromData(imgPixel, w, h) imageRotatedByDegrees:0];
}

/**
 * @brief  这是点击Fix Red-Eye页面的前进按钮后，恢复上一步撤销的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)forward:(UIImage *)inImage
{
    //如果屏幕上圆的个数大于等于recoveryArray中元素的个数，那么直接返回
    if (remainedOnView == [self.recoveryArray count]) 
    {
        return inImage;
    }
    NSArray *temp = [self.recoveryArray objectAtIndex:remainedOnView];
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    //int足够吗？
    long pixelCount = [temp count];//即像素点个数的四倍
    for (long i = 0; i < pixelCount; i=i+4)
    {
        long number = [[temp objectAtIndex:i]intValue];
        float intensity = [self getIntensityOfHSIModelFromRed:[[temp objectAtIndex:i+1]intValue] 
                                                        Green:[[temp objectAtIndex:i+2]intValue] 
                                                         Blue:[[temp objectAtIndex:i+3]intValue]];
        int bw = (int)(intensity * 255)/2.5;
        imgPixel[number] = bw;
        imgPixel[number+1] = bw;
        imgPixel[number+2] = bw;
    }
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	remainedOnView++;//屏幕上显示的点多了一个
    
    return [GenerateImageFromData(imgPixel, w, h) imageRotatedByDegrees:0];
}
@end
