//
//  TwistHandle.m
//  Aico
//
//  Created by rongtaowu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TwistHandle.h"
#import "ImageInfo.h"
@implementation TwistHandle


unsigned char imgOrg[4096][4096];
unsigned char imgSph[4096][4096];
unsigned char imgRot[4096][4096];


#if 0
// Return a bitmap context using alpha/red/green/blue byte values 
+ (CGContextRef) CreateRGBABitmapContext:(CGImageRef)inImage 
{
    void  *g_bitmapData = NULL;
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	int bitmapByteCount; 
	int bitmapBytesPerRow;
	size_t pixelsWide = CGImageGetWidth(inImage); 
	size_t pixelsHigh = CGImageGetHeight(inImage); 
	bitmapBytesPerRow = (pixelsWide * 4); 
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); 
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
    {
		fprintf(stderr, "Error allocating color space\n"); 
        return NULL;
	}
    
	// allocate the bitmap & create context 
    if(g_bitmapData != NULL)
    {
        free (g_bitmapData); 
        g_bitmapData = NULL;
    }
    
	g_bitmapData = malloc(bitmapByteCount);     
	if (g_bitmapData == NULL) 
    {
		fprintf (stderr, "Memory not allocated!"); 
		CGColorSpaceRelease( colorSpace ); 
		return NULL;
	}
	context = CGBitmapContextCreate (g_bitmapData, 
                                     pixelsWide, 
                                     pixelsHigh, 
                                     8, 
                                     bitmapBytesPerRow, 
                                     colorSpace, 
                                     kCGImageAlphaPremultipliedLast);
    
	if (context == NULL)
    {
		free (g_bitmapData); 
        g_bitmapData = NULL;
		fprintf (stderr, "Context not created!");
	} 
//    free(g_bitmapData);
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

// Return Image Pixel data as an RGBA bitmap 
+ (unsigned char*)RequestImagePixelData:(UIImage *)inImage
{
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
//	CGContextRef cgctx = CreateRGBABitmapContext(img); 	
    CGContextRef cgctx = [TwistHandle CreateRGBABitmapContext:img];
	if (cgctx == NULL) 
    { 
		return NULL;
    }	
	CGRect rect = {{0,0},{size.width, size.height}}; 
	CGContextDrawImage(cgctx, rect, img); 
	unsigned char *data = CGBitmapContextGetData (cgctx); 
	CGContextRelease (cgctx);
	return data;
}

// Generate image from data bytes 
+(UIImage *)GenerateImageFromData:(unsigned char*)imgPixelData PixelWidth:(NSUInteger)imgPixelWidth PixelHeight:(NSUInteger) imgPixelHeight
{
	CGDataProviderRef provider = CGDataProviderCreateWithData(
                                                              NULL,
                                                              imgPixelData, 
                                                              imgPixelWidth * imgPixelHeight * 4,
                                                              NULL);
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

+ (UIImage *)blackWhite:(UIImage *)inImage 
{
//	unsigned char *imgPixel = RequestImagePixelData(inImage);
    unsigned char *imgPixel = [TwistHandle RequestImagePixelData:inImage];
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
	int wOff = 0;
	int pixOff = 0;	
	for(GLuint y = 0;y< h;y++) 
    {
		pixOff = wOff;		
		for (GLuint x = 0; x<w; x++) 
        {
			//int alpha = (unsigned char)imgPixel[pixOff];
			int red = (unsigned char)imgPixel[pixOff];
			int green = (unsigned char)imgPixel[pixOff+1];
			int blue = (unsigned char)imgPixel[pixOff+2];
			
			int bw = (int)((red+green+blue)/3.0);
			
			imgPixel[pixOff] = bw;
			imgPixel[pixOff+1] = bw;
			imgPixel[pixOff+2] = bw;
			
			pixOff += 4;
		}
		wOff += w * 4;
	}
//	return GenerateImageFromData(imgPixel, w, h);
    return [TwistHandle GenerateImageFromData:imgPixel PixelWidth:w PixelHeight:h];
    
}
#endif

unsigned char Insertion_Bilinear(double x, double y)
{
	int isrtValue;
	int x_base = (int)x;
	int y_base = (int)y;
	isrtValue = (int)( imgOrg[y_base][x_base]*(x_base+1-x)*(y_base+1-y)+imgOrg[y_base+1][x_base]*(x_base+1-x)*(y-y_base)+imgOrg[y_base][x_base+1]*(x-x_base)*(y_base+1-y)+imgOrg[y_base+1][x_base+1]*(x-x_base)*(y-y_base) );
	return (unsigned char)isrtValue;	
}

//旋转特效

+ (void)rotate:(ImageInfo *)inImage 
     destImage:(ImageInfo *)dstImage 
   CycleCenter:(CGPoint)centerPoint 
        degree:(CGFloat)degree
        radius:(CGFloat)inRadius
{
    if (degree < 1) degree = 1;
    if (degree > 100) degree = 100;
    double swirlDegree = degree / 3000.0;
    
    int width = inImage.width;
    int height = inImage.height;
    int midX = centerPoint.x;
    int midY = centerPoint.y;
    
    unsigned char *src = (unsigned char *)inImage.data;
    unsigned char *dst = (unsigned char *)dstImage.data;
    
    int stride = inImage.bytesPerRow;
    int BPP = inImage.bytesPerPixel;
    int offset = stride - width * BPP;
    
   
//    byte* src = (byte*)srcScan0;
//    byte* dst = (byte*)dstScan0;
    
    int X, Y;
    int offsetX, offsetY;
    
    // 弧度、半径
    double radian, radius;
    
    
    
    
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            if (sqrtf((x - midX) * (x - midX) + (y - midY) * (y - midY)) < inRadius)
            {
                // 当前点与图像中心点的偏移量
                offsetX = x - midX;
                offsetY = y - midY;
                
                // 弧度
                radian = atan2(offsetY, offsetX);
                
                // 半径，即两点间的距离
                radius =sqrt(offsetX * offsetX + offsetY * offsetY);
                
                //            if (sqrt(offsetX * offsetX + offsetY * offsetY) < 60)
                //            {
                // 映射实际像素点
                X = (int)(radius * cos(radian + swirlDegree * radius)) + midX;
                Y = (int)(radius * sin(radian + swirlDegree * radius)) + midY;
                
                // 边界约束
                if (X < 0) X = 0;
                if (X >= width) X = width - 1;
                if (Y < 0) Y = 0;
                if (Y >= height) Y = height - 1;
                
                src = (unsigned char *)inImage.data  + Y * stride + X * BPP;

            }
            else 
            {
                src = (unsigned char *)inImage.data + y * stride + x * BPP;                
            }
//            }
//            else
//            {
//                src = (unsigned char *)inImage.data  + y * stride + x * BPP;                
//            }
            
            dst[3] = src[3]; // A
            dst[2] = src[2]; // R
            dst[1] = src[1]; // G
            dst[0] = src[0]; // B
            
            dst += BPP;
        } // x
        dst += offset;
    } // y

    
//    return dstImage;
}

/*圆形发散*/
+ (void)pinch:(ImageInfo *)inImage 
    destImage:(ImageInfo *)dstImage
  CycleCenter:(CGPoint)centerPoint 
       degree:(CGFloat)degree
     inRadius:(CGFloat)inRadius
{
    if (degree < 1) degree = 1;
    if (degree > 32) degree = 32;
    
    int width = inImage.width;
    int height = inImage.height;
    
    int midX = centerPoint.x;
    int midY = centerPoint.y;
    
    
    unsigned char *src = (unsigned char *)inImage.data;
    unsigned char *dst = (unsigned char *)dstImage.data;
    
    int stride = inImage.bytesPerRow;
    int BPP = inImage.bytesPerPixel;
    int offset = stride - width * BPP;
    
   
//    unsigned char *src = (unsigned char *)inImage.data;
//    unsigned char *dst = (unsigned char *)dstImage.data;
    
    int X, Y;
    int offsetX, offsetY;
    
    // 弧度、半径
    double radian, radius;
    
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            if ((x - midX) * (x - midX) + (y - midY) * (y - midY) >= inRadius * inRadius)
            {
                // 当前点与图像中心点的偏移量
                offsetX = x - midX;
                offsetY = y - midY;
                
                // 弧度
                radian = atan2(offsetY, offsetX);
                
                // 半径
                radius = sqrt(offsetX * offsetX + offsetY * offsetY);
                radius = sqrt(radius) * degree;
                
                // 映射实际像素点
                X = (int)(radius * cos(radian)) + midX;
                Y = (int)(radius * sin(radian)) + midY;
                
                // 边界约束
                if (X < 0) X = 0;
                if (X >= width) X = width - 1;
                if (Y < 0) Y = 0;
                if (Y >= height) Y = height - 1;
                
                //            src = (byte*)srcScan0 + Y * stride + X * BPP;
                src = (unsigned char *)inImage.data + Y * stride + X * BPP;
            }
            else 
            {
                src = (unsigned char *)inImage.data + y * stride + x * BPP;
                
            }
           
            
            dst[3] = src[3]; // A
            dst[2] = src[2]; // R
            dst[1] = src[1]; // G
            dst[0] = src[0]; // B
            
            dst += BPP;
        } // x
        dst += offset;
    } // y
    
//    return dstImage;
}
//球面化
+ (void)spherize:(ImageInfo *)inImage 
        destImage:(ImageInfo *)dstImage
      CycleCenter:(CGPoint)centerPoint 
           Radius:(CGFloat)inRadius
       scaleRatio:(CGFloat)ratio
{
    int width = inImage.width;
    int height = inImage.height;
    int midX = centerPoint.x;
    int midY = centerPoint.y;
//    int maxMidXY = inRadius;
    
//    int SX = (midX - inRadius/2) > 0 ? (midX - inRadius/2) : 0;
//    int EX = (midX + inRadius/2) > inImage.width ? inImage.width : (midX + inRadius/2);
//    int SY = (midY - inRadius/2) > 0 ? (midY - inRadius/2) : 0;
//    int EY = (midY + inRadius/2) > inImage.height ? inImage.height : (midY + inRadius/2);
    
//    unsigned char *srcScan0 = inImage.data;
//    unsigned char *dstScan0 = dstImage.data;
    unsigned char *src = (unsigned char *)inImage.data;
    unsigned char *dst = (unsigned char *)dstImage.data;
    
    int stride = inImage.bytesPerRow;
    int BPP = inImage.bytesPerPixel;
    int offset = stride - width * BPP;
    
//    int xOffset, yOffset;
    int offsetX, offsetY;
    double radian, radius;
    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
//            if ((x >= SX && x <= EX) && (y >= SY && y<= EY))
            if (sqrt((x - midX) * (x - midX) + (y - midY) * (y - midY)) <= inRadius) 
            {
                src = (unsigned char *)inImage.data + y * stride + x * BPP;
                dst = (unsigned char *)dstImage.data + y * stride + x * BPP;
                
                offsetX = x - midX;
                offsetY = y - midY;
                
                // 弧度
                radian = atan2(offsetY, offsetX);
//                radian = 2.0;
                
//                NSLog(@"radian is %f",radian);
                
                //调节扭曲效果幅度
//                float ss = powf(inRadius, ratio);
                float  num1 = powf(inRadius, ratio) / inRadius;
                
//                float b = sqrtf(offsetX * offsetX + offsetY * offsetY);
                float num2 = powf(sqrtf(offsetX * offsetX + offsetY * offsetY), ratio);
                radius = num2 / num1;

                
//                radius = (offsetX * offsetX + offsetY * offsetY) / maxMidXY;
                
                // 映射实际像素点
                int X = (int)(radius * cos(radian)) + midX;
                int Y = (int)(radius * sin(radian)) + midY;
                
                // 边界约束
                if (X < 0) X = 0;
                if (X >= width) X = width - 1;
                if (Y < 0) Y = 0;
                if (Y >= height) Y = height - 1;
                
                src = (unsigned char *)inImage.data + Y * stride + X * BPP;
                
                dst[3] = src[3]; // A
                dst[2] = src[2]; // R
                dst[1] = src[1]; // G
                dst[0] = src[0]; // B

            }
        }
        dst += offset;
    }    
}

@end
