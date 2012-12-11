//
//  Common.m
//  Aico
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGL.h>
#import "Common.h"
#import <OpenGLES/ES2/gl.h>
#import "ReUnManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+extend.h"
#import "UIColor+extend.h"
#import "XMLUtils.h"

UIView *g_toastViewBelow = nil;
#define kToastViewTagAbove          9999
#define kToastViewTagBelow          9997
#define kToastLabelTagBelow         9995


//static UIImage *globalSrcImage = nil;
static void * g_bitmapData = NULL;
//static NSMutableArray *imageProcessArray = nil;
//static NSMutableArray *undoImageProcessArray = nil;
//static UIImage *globalSrcImage = nil;
//static NSArray *


@implementation Common

//+ (UIImage *)getGlobalSrcImage
//{
//    return globalSrcImage;
//}
//+ (void)setGlobalSrcImage:(UIImage *)image
//{
//    if(imageProcessArray == nil)
//    {
//        imageProcessArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    [imageProcessArray addObject:image];
//    NSLog(@"global %f,%f",globalSrcImage.size.width,globalSrcImage.size.height);
//    NSLog(@"%f,%f",image.size.width,image.size.height);
//    globalSrcImage = image;
//    
//}
//+ (NSMutableArray *)getAllSrcImage
//{
//    return imageProcessArray;
//}
//
//+ (UIImage *)getNextStepImage;
//{
////    NSMutableArray *imageProcessArray = [Common getAllSrcImage];
//    if ([undoImageProcessArray count] == 0)
//    {
//        return nil;
//    }
//    UIImage *image = [undoImageProcessArray lastObject];
//    [imageProcessArray addObject:image];
//    [undoImageProcessArray removeLastObject];
//    return  image;
//}
//+ (UIImage *)getPreStepImage
//{
////    NSMutableArray *imageProcessArray = [Common getAllSrcImage];
//    if ([imageProcessArray count] == 0)
//    {
//        return nil;
//    }
//    if (undoImageProcessArray  == nil)
//    {
//        undoImageProcessArray = [[NSMutableArray alloc] initWithCapacity:0];
//    }
//    UIImage *image = (UIImage *)[imageProcessArray lastObject];
//    [undoImageProcessArray addObject:image];
//    [imageProcessArray removeLastObject];
//    return  (UIImage *)[imageProcessArray lastObject];
//}

/**
 * @brief  Return a bitmap context using alpha/red/green/blue byte values 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (CGContextRef)CreateRGBABitmapContext:(CGImageRef)inImage
{
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
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char *)RequestImagePixelData:(UIImage *)inImage 
{
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
	CGContextRef cgctx = [Common CreateRGBABitmapContext:img];//CreateRGBABitmapContext(img); 	
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

/**
 * @brief  Generate image from data bytes 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)GenerateImageFromData:(unsigned char *)imgPixelData 
                 withImgPixelWidth:(NSUInteger) imgPixelWidth 
                withImgPixelHeight:(NSUInteger)imgPixelHeight
{
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
 * @brief  翻转图片 
 *
 * @param [in] Type 0:Horizontal 1:Vertical
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageRotatedFlip:(UIImage *)image withType:(NSUInteger)flipType
{
    unsigned char *imgPixel = [Common RequestImagePixelData:image];
    
//    NSLog(@"%lu",strlen((const char *)imgPixel));
	CGImageRef inImageRef = [image CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
	
    int pixOff = 0;
	int wpixOff = 0;	
    
    switch (flipType) {
        case 0:           
            for (GLuint x=0; x<w/2; x++) {
                for (GLuint y=0; y<h; y++) {
                    pixOff = (x+y*w)*4;
                    int red = (unsigned char)imgPixel[pixOff];
                    int green = (unsigned char)imgPixel[pixOff+1];
                    int blue = (unsigned char)imgPixel[pixOff+2];
                    int alpha = (unsigned char)imgPixel[pixOff+3];
                    
                    wpixOff = ((w-x-1)+y*w)*4;
                    int nred = (unsigned char)imgPixel[wpixOff];
                    int ngreen = (unsigned char)imgPixel[wpixOff+1];
                    int nblue = (unsigned char)imgPixel[wpixOff+2];
                    int nalpha = (unsigned char)imgPixel[wpixOff+3];
                    
                    imgPixel[pixOff]   = nred;
                    imgPixel[pixOff+1] = ngreen;
                    imgPixel[pixOff+2] = nblue;
                    imgPixel[pixOff+3] = nalpha;
                    
                    imgPixel[wpixOff]   = red;
                    imgPixel[wpixOff+1] = green;
                    imgPixel[wpixOff+2] = blue;
                    imgPixel[wpixOff+3] = alpha;
                }
            }
      break;
            
        case 1:
            for (GLuint x=0; x<w; x++) {
                for (GLuint y=0; y<h/2; y++) {
                    pixOff = (x+y*w)*4;
                    int red = (unsigned char)imgPixel[pixOff];
                    int green = (unsigned char)imgPixel[pixOff+1];
                    int blue = (unsigned char)imgPixel[pixOff+2];
                    int alpha = (unsigned char)imgPixel[pixOff+3];
                    
                    wpixOff = (x+(h-1-y)*w)*4;
                    
                    imgPixel[pixOff] = (unsigned char)imgPixel[wpixOff];
                    imgPixel[pixOff+1] = (unsigned char)imgPixel[wpixOff+1];
                    imgPixel[pixOff+2] = (unsigned char)imgPixel[wpixOff+2];
                    imgPixel[pixOff+3] = (unsigned char)imgPixel[wpixOff+3];
                    
                    imgPixel[wpixOff] = (unsigned char)red;
                    imgPixel[wpixOff+1] = (unsigned char)green;
                    imgPixel[wpixOff+2] = (unsigned char)blue;
                    imgPixel[wpixOff+3] = (unsigned char)alpha;
                }
            }
            break;
            
        default:
            break;
    }
    
	return [Common GenerateImageFromData:imgPixel withImgPixelWidth:w withImgPixelHeight:h];
}

#pragma mark -
#pragma mark Color Transfer (RGB -> HSB, HSB -> RGB)

// RGB -> HSB 
+ (void)red: (unsigned char)r 
	  green: (unsigned char)g 
	   blue: (unsigned char)b 
	  toHue: (CGFloat*)pH 
 saturation: (CGFloat*)pS 
 brightness: (CGFloat*)pV
{
	CGFloat h,s,v;
	
	// From Foley and Van Dam
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	CGFloat dis = max - min;
    
	// Brightness
	v = max;
	
	// Saturation
	s = (max != 0.0f) ? (dis / max) : 0.0f;
	
	if (s == 0.0f) 
	{	// No saturation, so undefined hue
		h = 0.0f;
	}
	else
	{	// Determine hue
		CGFloat rc = (max - r) / dis;		// Distance of color from red
		CGFloat gc = (max - g) / dis;		// Distance of color from green
		CGFloat bc = (max - b) / dis;		// Distance of color from blue
		
		if (r == max) 
			h = bc - gc;							// resulting color between yellow and magenta
		else if (g == max) 
			h = 2 + rc - bc;						// resulting color between cyan and yellow
		else 
			h = 4 + gc - rc;						// resulting color between magenta and cyan
		
		h *= 60.0f;									// Convert to degrees
		if (h < 0.0f) 
			h += 360.0f;							// Make non-negative
	}
	
	if (pH) *pH = h;
	if (pS) *pS = s;
	if (pV) *pV = v;
}

// HSB -> RGB
+ (void)hue: (CGFloat)h 
 saturation: (CGFloat)s 
 brightness: (CGFloat)v 
	  toRed: (unsigned char*)pR 
	  green: (unsigned char*)pG 
	   blue: (unsigned char*)pB 
{
	unsigned char r,g,b;
	
	// From Foley and Van Dam
	if (s == 0.0f) 
	{
		// Achromatic color: there is no hue
		r = g = b = v;
	}
	else
	{	// Chromatic color: there is a hue
		if (h == 360.0f) 
		{
			h = 0.0f;
		}
		h /= 60.0f;										// h is now in [0, 6)
		
		int i = floorf(h);								// largest integer <= h
		CGFloat f = h - i;								// fractional part of h
		CGFloat p = v * (1 - s);
		CGFloat q = v * (1 - (s * f));
		CGFloat t = v * (1 - (s * (1 - f)));
		
		switch (i) 
		{
			case 0:	r = v; g = t; b = p;	break;
			case 1:	r = q; g = v; b = p;	break;
			case 2:	r = p; g = v; b = t;	break;
			case 3:	r = p; g = q; b = v;	break;
			case 4:	r = t; g = p; b = v;	break;
			case 5:	r = v; g = p; b = q;	break;
		}
	}
	
	if (pR) *pR = r;
	if (pG) *pG = g;
	if (pB) *pB = b;
}

/**
 * @brief 设置不固定大小NavigationController标题 
 *
 * @param [in]　N/A
 * @param [out]　N/A
 * @return　　void
 * @note
 */
+ (void)customizeTitle:(NSString *)titleString 
  targetViewController:(UIViewController *)viewController 
             viewFrame:(CGRect)rect
		    titleColor:(UIColor *)targetColor
{	
	UIView *titleView = [[UIView alloc] initWithFrame:rect];	
	[titleView setBackgroundColor:[UIColor clearColor]];	
	[titleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];	
	
	UILabel *nameLabel = [[UILabel alloc] init];	
	[nameLabel setFrame:rect];	
	[nameLabel setBackgroundColor:[UIColor clearColor]];	
	[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | 
	 UIViewAutoresizingFlexibleBottomMargin |
	 UIViewAutoresizingFlexibleRightMargin | 
	 UIViewAutoresizingFlexibleLeftMargin];	
	[nameLabel setTextColor: targetColor];	
	[nameLabel setFont:[UIFont boldSystemFontOfSize:17]];	
	[nameLabel setText: titleString];	
	[nameLabel setTextAlignment:UITextAlignmentCenter];	
	[titleView addSubview:nameLabel];		
	viewController.navigationItem.titleView = titleView;	
	[nameLabel release];	
	[titleView release];	
}

/**
 * @brief  ios5设置导航栏背景图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)setNavigationBarBackgroundBkg:(UINavigationBar *)navigationBar
{
    navigationBar.barStyle = UIBarStyleBlackTranslucent;
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        UIImage *navigationBarImg = [UIImage imageNamed:@"navigationbarBkg.png"] ;
        [navigationBar setBackgroundImage:navigationBarImg forBarMetrics:UIBarMetricsDefault];
    }
#endif
}

/**
 * @brief 
 * 根据区域截取图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{ 
	CGImageRef sourceImageRef = [image CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect); 
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef]; 
    CGImageRelease(newImageRef);
	return newImage;      
}  

/**
 * @brief 
 * 根据比例缩放图片,将图片缩放在(10, 55, 300, 360)区域中
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+(CGRect)adaptImageToScreen:(UIImage *)image
{
	CGSize imageSize = image.size;
	CGSize viewSize = CGSizeMake(320, 425);
	
    if (image) 
        return [Common size:imageSize autoFitSize:viewSize offset:CGPointMake(0, kNavigationHeight) margin:CGPointMake(10, 10)];
    else
		return kBackgroundImageViewRect;
}

/**
 * @brief  将图片写入Aico相册方法
 *
 * @param [in] path为图片的绝对地址
 * @param [out]
 * @return
 * @note 
 */
+ (BOOL)writeIconAico:(NSString *)path
{
    if (path == nil)
    {
        return NO;
    }
    NSArray *nameArr = [path componentsSeparatedByString:@"/"];
    NSString *newName = [nameArr lastObject];
    
    if (newName == nil)
    {
        return NO;
    }
    
    NSString *pathIcon = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    pathIcon = [pathIcon stringByAppendingPathComponent:@"Icon"];
    NSString *newPath = [pathIcon stringByAppendingPathComponent:newName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image == nil)
    {
        return NO;
    }

    UIImage *newImage = [image imageByScalingProportionallyToSize:CGSizeMake(200, 200)];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0);
    UIImage *compressImage = [UIImage imageWithData:imageData];
    [UIImagePNGRepresentation(compressImage) writeToFile:newPath atomically:YES];
    return YES;
}


/**
 * @brief 
 * 图片写入aico文件夹
 *
 * @param [in]  image 需要写入的图片数据
 * @param [in]  name 图片名字，如果为空则按照时间自动生成一个
 * @param [out]
 * @return 
 * @note
 */
+ (BOOL)writeImageAico:(UIImage *)image withName:(NSString *)name
{
    if (image == nil)
    {
        NSLog(@"image is empty =%d=", __LINE__);
        return NO;
    }
    NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    path = [path stringByAppendingPathComponent:@"Favorite"];
    
    if (name == nil)
    {
        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
//        [formatter setDateFormat:@"YY-MM-dd HH:MM:SS"];
//        NSString *str = [formatter stringFromDate:date];
        NSString *newName = [NSString stringWithFormat:@"%@.png", [date description]];
        NSString *newPath = [path stringByAppendingPathComponent:newName];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:newName])
        {
            [fm removeItemAtPath:newName error:nil];
        }
        [UIImagePNGRepresentation(image) writeToFile:newPath atomically:YES];
        [Common writeIconAico:newPath];
        ReUnManager *rm = [ReUnManager sharedReUnManager];
        rm.currentImageName = newName;
    }
    else
    {
        NSString *nameString = [NSString stringWithFormat:@"%@", name];
        NSString *imagePath = [path stringByAppendingPathComponent:nameString];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:imagePath])
        {
            [fm removeItemAtPath:imagePath error:nil];
        }
        
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    }
    
    [Common showToastView:@"图片已经保存到天天相册" hiddenInTime:2.0f];
    return YES;
}

/**
 * @brief 
 * 窗口通知
 *
 * @param [in]  onView 载体试图
 * @param [in]  titleText 提示信息
 * @param [in]  timeDelay 提示框消失前持续时间
 * @param [out]
 * @return 
 * @note
 */
+ (void)setMyNotifyView:(UIView *)onView withText:(NSString *)titleText hiddenInTime:(NSTimeInterval)timeDelay{
    
    CGSize optimalTextSize = [titleText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290.0f, 100.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    if (g_toastViewBelow == nil) {
        g_toastViewBelow = [[UIView alloc] init];
        g_toastViewBelow.tag = kToastViewTagBelow;
        [g_toastViewBelow setBackgroundColor:[UIColor blackColor]];
        g_toastViewBelow.layer.masksToBounds = YES;
        g_toastViewBelow.layer.cornerRadius = 8.0f;
        g_toastViewBelow.layer.borderColor = [UIColor whiteColor].CGColor;
        g_toastViewBelow.layer.borderWidth = 3.0f;
        g_toastViewBelow.alpha = 0.6f;
        
        // 左右边距15 上下间距10
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, optimalTextSize.width, optimalTextSize.height)];
        [textLabel setTag:kToastLabelTagBelow];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setNumberOfLines:0];
        [textLabel setTextAlignment:UITextAlignmentCenter];
        [textLabel setLineBreakMode:UILineBreakModeWordWrap];
        [g_toastViewBelow addSubview:textLabel];
        [textLabel release];
        [g_toastViewBelow setHidden:YES];
    }
    else
    {
        [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyHidden:) object:g_toastViewBelow];
    }
    
    CGRect toastViewBounds = CGRectMake(0, 0, optimalTextSize.width + 2 *15, optimalTextSize.height + 2 * 10);
    
    // tabBar的高度48，toastView和tabBar的间隔15 window框架的高度480
    g_toastViewBelow.frame = CGRectMake((320 - toastViewBounds.size.width)/2, 480 - 48 - 15 - toastViewBounds.size.height, toastViewBounds.size.width, toastViewBounds.size.height);
    
    // 重设frame大小
    UILabel *tmpLabel = (UILabel *)[g_toastViewBelow viewWithTag:kToastLabelTagBelow];
    [tmpLabel setFrame:CGRectMake(15, 10, optimalTextSize.width, optimalTextSize.height)];
    
	[onView addSubview:g_toastViewBelow];
    
    if ([g_toastViewBelow isHidden]) {
        [g_toastViewBelow setHidden:NO];
        UILabel *tmpLabel = (UILabel *)[g_toastViewBelow viewWithTag:kToastLabelTagBelow];
        [tmpLabel setText:titleText];
        [self performSelector:@selector(notifyHidden:) withObject:g_toastViewBelow afterDelay:timeDelay];
    }
    else {
        UILabel *tmpLabel = (UILabel *)[g_toastViewBelow viewWithTag:kToastLabelTagBelow];
        [tmpLabel setText:titleText];
        [self performSelector:@selector(notifyHidden:) withObject:g_toastViewBelow afterDelay:timeDelay];
    }
}

+ (void)notifyHidden:(UIButton *)hiddenView
{
	[hiddenView setHidden:TRUE];
}

/**
 * @brief 
 * 提示框 移植于dsmiphone
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (void)showToastView:(NSString *)titleText hiddenInTime:(NSTimeInterval)timeDelay {
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow *window = [array lastObject];
    
    [Common setMyNotifyView:window withText:titleText hiddenInTime:timeDelay];
}


/**
 * @brief  给图片加圆角区域
 * @param [in]　 context 
 * @param [in]	rect
 * @param [in]	ovalWidth
 * @param [in]  ovalHeight
 * @param [out] N/A
 * @return　　　
 * @note
 */
+(void)addRoundedRectToPathwithCGContextRef:(CGContextRef )context Rect:(CGRect)rect withWidth:(float)ovalWidth withHeight:(float)ovalHeight{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
/**
 * @brief  将图片转换成圆角图片
 * @param [in]　 image 待转换的图片指针
 * @param [in]	size 转换后的尺寸
 * @param [out] N/A
 * @return　　id 转换后的对象　
 * @note
 */
+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    if(image == nil)return nil;
	int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
	[self addRoundedRectToPathwithCGContextRef:context 
										  Rect:rect
									 withWidth:2 
									withHeight:2];    
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	UIImage *result = [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	CGImageRelease(imageMasked);
    return result;
}

/**
 * @brief  
 *
 * 根据图片质量返回处理后的图片路径
 * @param [in] N/A
 * @param [out] N/A
 * @return 调整后的图片路径
 * @note N/A
 */
+ (UIImage *) adjustedImagePathForImage:(UIImage *)image
{
    CGSize stdSize = image.size;
	CGFloat origWidth = image.size.width;
	CGFloat origHeight = image.size.height;
	CGFloat radio = origWidth/origHeight;
	CGFloat radio1 = origHeight/origWidth;
    CGFloat width = 640.0;
    CGFloat height = 960.0;
    if(origHeight > height)
    {
        if(origWidth < width)
        {
            stdSize = CGSizeMake((height * radio), height);
        }
        else 
        {
            if(width/height > radio)
            {
                stdSize = CGSizeMake((height * radio), height);
                
            }
            else
            {
                stdSize = CGSizeMake(width, (width * radio1));
            }
            
        }
    }
    else if(origWidth > width)
    {
        if((height * radio) > width)
        {
            stdSize = CGSizeMake(width, (width * radio1));
        }
        else
        {
            stdSize = CGSizeMake((height * radio), height);
        }
    }

    
    CGSize imgSize = image.size;
    NSLog(@"imgSize = {%f, %f}",imgSize.width, imgSize.height);
    CGSize finalSize = image.size;
    BOOL imageOrientation = image.imageOrientation == UIImageOrientationRight ||
    image.imageOrientation == UIImageOrientationLeft || 
    image.imageOrientation == UIImageOrientationLeftMirrored ||
    image.imageOrientation == UIImageOrientationRightMirrored;
    
    if (imageOrientation) {
        
        imgSize.height = CGImageGetWidth(image.CGImage);
        imgSize.width = CGImageGetHeight(image.CGImage);
        
    } 
	
    UIImage *finalImage = image;
    /*if (factor != kHighQuality) */{
        
        if (imgSize.width < stdSize.width && imgSize.height < stdSize.height) {
            finalSize.width = imgSize.width;
            finalSize.height = imgSize.height;
        }
        else if (imgSize.height / imgSize.width < 1.5) {
            finalSize.width = stdSize.width;
            finalSize.height = imgSize.height * stdSize.width / imgSize.width;
            
        } else {
            finalSize.height = stdSize.height;
            finalSize.width = imgSize.width * stdSize.height / imgSize.height;
            
        }
        //加!imageOrientation判断，解决前置摄像头拍张 图片旋转90度的问题  
        //add by jiang liyin 2012－4－26
        
        if (!imageOrientation && finalSize.width == imgSize.width && finalSize.height == imgSize.height)
        {
            //不return，否则会出现图片倒置或者旋转90度的问题
//            return nil;
        }
		
        finalImage = [image imageByScalingProportionallyToSize:finalSize];
    } 
    NSData *imgData = UIImageJPEGRepresentation(finalImage, 0.5);
    finalImage = [UIImage imageWithData:imgData];
    NSLog(@"finalSize = {%f, %f}",finalSize.width, finalSize.height);
    return finalImage;

}

/**
 * @brief 将origin按照原有比例缩放显示在target上
 *
 * @param [in] sizeTarget: 目标区域大小
 * @param [in] ptOffset: 缩放后显示在target上的偏移量
 * @param [in] ptMargin: 缩放后距离target边框的距离
 * @param [out]
 * @return 调整后的显示区域
 * @note 
 */
+ (CGRect)size:(CGSize)sizeOrigin autoFitSize:(CGSize)sizeTarget offset:(CGPoint)ptOffset margin:(CGPoint)ptMargin
{
	CGFloat imageWidth = sizeOrigin.width;
	CGFloat imageHeight = sizeOrigin.height;
	
	CGFloat viewWidth = sizeTarget.width - ptOffset.x - ptMargin.x*2;
	CGFloat viewHeight = sizeTarget.height - ptOffset.y - ptMargin.y*2;
	
	CGSize size;
	
	CGFloat imageRate = imageWidth / imageHeight;
	CGFloat viewRate = viewWidth / viewHeight;
    
    
//    imageWidth = imageWidth > viewWidth ? 
    
	if (imageRate > viewRate)
	{
//		if (imageWidth <= viewWidth)
//		{
//			size.width = imageWidth;
//			size.height = imageHeight;
//		}
//		else
//		{
			size.width = viewWidth;
			size.height = viewWidth / imageRate;
//		}
	}
	else
	{
//		if (imageHeight <= viewHeight)
//		{
//			size.height = imageHeight;
//			size.width = imageWidth;
//		}
//		else
//		{
			size.height = viewHeight;
			size.width = viewHeight * imageRate;
//		}
	}
	
	CGPoint pt;
	pt.x = (viewWidth - size.width) / 2;
	pt.y = (viewHeight - size.height) / 2;
	
	return CGRectMake(ptOffset.x + ptMargin.x + pt.x, ptOffset.y + ptMargin.y + pt.y, size.width, size.height);
}

/**
 * @brief 将imageview上的图片按照原有比例缩放显示在指定view上
 *
 * @param [in] view: 目标view
 * @param [in] ptMargin: 缩放后距离view边框的距离
 * @param [out]
 * @return 调整后的显示区域
 * @note 
 */
+ (void)imageView:(UIImageView *)imageView autoFitView:(UIView *)view margin:(CGPoint)ptMargin
{
	CGSize imageSize = imageView.image.size;
	CGSize viewSize = view.bounds.size;
	
	imageView.frame = [Common size:imageSize autoFitSize:viewSize offset:CGPointMake(0, kNavigationHeight) margin:ptMargin];
}

/**
 * @brief 将imageview上的图片按照原有比例缩放显示在指定view上
 *
 * @param [in] view: 目标view
 * @param [in] ptOffset: 缩放后显示在view上的偏移量
 * @param [in] ptMargin: 缩放后距离view边框的距离
 * @param [out]
 * @return 调整后的显示区域
 * @note 
 */
+ (void)imageView:(UIImageView *)imageView autoFitView:(UIView *)view offset:(CGPoint)ptOffset margin:(CGPoint)ptMargin
{
	CGSize imageSize = imageView.image.size;
	CGSize viewSize = view.bounds.size;
	
	imageView.frame = [Common size:imageSize autoFitSize:viewSize offset:ptOffset margin:ptMargin];
}

/**
 * @brief 把twoImg合并到oneImg的subImgRect区域
 * @param N/A
 * @param N/A
 * @return N/A
 * @note N/A
 */
+ (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(NSString *)twoImgName toRect:(CGRect)subImgRect 
{
    UIImage *frameImage = [UIImage imageNamed:twoImgName];
    UIGraphicsBeginImageContext(oneImg.size);
           [oneImg drawInRect:CGRectMake(1, 1, oneImg.size.width - 2, oneImg.size.height - 2)];
    //[twoImg drawInRect:CGRectMake(0, 0, twoImg.size.width, twoImg.size.height)];
    [frameImage drawInRect:subImgRect];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}

/**
 * @brief 从UIColor中获取RGBA分量的值，范围[0,1]
 *
 * @param [out] red: 红色值
 * @param [out] green: 绿色值
 * @param [out] blue: 蓝色值
 * @param [out] alpha: 透明度值
 * @param [in] color: 指定的颜色
 * @return 
 * @note 
 */
+ (void)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromUIColor:(UIColor *)color
{
    CGColorRef colorRef = [color CGColor];
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(colorRef));
    const CGFloat *components = CGColorGetComponents(colorRef);
    
    switch (model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            if (red   != NULL) *red   = components[0];
            if (green != NULL) *green = components[0];
            if (blue  != NULL) *blue  = components[0];
            if (alpha != NULL) *alpha = components[1];
            break;
        }
        case kCGColorSpaceModelRGB:
        {
            if (red   != NULL) *red   = components[0];
            if (green != NULL) *green = components[1];
            if (blue  != NULL) *blue  = components[2];
            if (alpha != NULL) *alpha = components[3];
            break;
        }
        default:
        {
            NSLog(@"Unsupported gradient color format: %i", model);
            if (red   != NULL) *red   = 0.0f;
            if (green != NULL) *green = 0.0f;
            if (blue  != NULL) *blue  = 0.0f;
            if (alpha != NULL) *alpha = 0.0f;
            break;
        }
    }
}

/**
 * @brief 
 * 生成随机数，包括from,to
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (int)getRandomNumber:(int)from to:(int)to
{
    return from + (arc4random()%(to + 1 - from + 1));
}

/**
 * @brief 
 * 计算旋转角度，
 * begin和end以origin为原点形成的夹角
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (CGFloat)makeRotate:(CGPoint)origin withBegin:(CGPoint) begin andEnd:(CGPoint) end
{
    //考虑斜率无限大问题
    if (origin.x == begin.x) 
    {
        if (origin.x==end.x || 
            end.y==origin.y || 
            origin.y==begin.y) 
        {
            return 0.0;
        }
        //成90度问题，此时tan值无限大/小
        else if (end.y==origin.y)
        {
            if ((end.x>origin.x&&begin.y>origin.y)||
                (end.x<origin.x&&begin.y<origin.y))
            {
                return M_PI/2;
            }
            else if ((end.x>origin.x&&begin.y<origin.y)||
                     (end.x<origin.x&&begin.y>origin.y))
            {
                return -M_PI/2;
            }
            return M_PI/2;
        }
        else
        {
            CGFloat tanA = (end.x-origin.x)/(end.y-origin.y);
            return atanf(tanA);
        }
    }
    if (origin.x == end.x) 
    {
        if (origin.x==begin.x ||
            end.y==origin.y ||
            begin.y==origin.y) 
        {
            return 0.0;
        }
        //成90度问题，此时tan值无限大/小
        else if (begin.y==origin.y)
        {
            if ((end.y>origin.y&&begin.x<origin.x)||
                (end.y<origin.y&&begin.x>origin.x))
            {
                return M_PI/2;
            }
            else if ((end.y>origin.y&&begin.x>origin.x)||
                     (end.y<origin.y&&begin.x<origin.x))
            {
                return -M_PI/2;
            }
            return M_PI/2;
        }
        else
        {
            CGFloat tanA = (begin.x-origin.x)/(begin.y-origin.y);
            return atanf(tanA);
        }
    }
    
    CGFloat k1 = (begin.y-origin.y)/(begin.x-origin.x);
    CGFloat k2 = (end.y-origin.y)/(end.x-origin.x);
    
    CGFloat tanA = (k2-k1)/(1+k1*k2);
    return atanf(tanA);
}

/**
 * @brief 
 * 计算拉伸比例，
 * begin和end以origin为原点形成的两线段比例
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (CGFloat)makeScale:(CGPoint)origin beginPoint:(CGPoint)begin andEndPoint:(CGPoint)end
{
    CGFloat original = 1.0;
    if (begin.x==origin.x&&begin.y==origin.y)
    {
        original = 1.0;
    }
    else
    {
        original = sqrtf((begin.x-origin.x)*(begin.x-origin.x) + (begin.y-origin.y)*(begin.y-origin.y));
    }
    CGFloat now = sqrtf((end.x-origin.x)*(end.x-origin.x) + (end.y-origin.y)*(end.y-origin.y));
    return now/original;
}

/**
 * @brief 
 * 在发表微博结果alert上添加标签和图片
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (void)addLabelAndImageViewToAlertView:(UIAlertView *)alertView 
                            inLabelRect:(CGRect)labelRect 
                        inImageViewRect:(CGRect)imageViewRect
                               useImage:(BOOL)successOrFail
                             labelTitle:(NSString *)title
{
    UIImage *successImage = [UIImage imageNamed:@"shareOK.png"];
    UIImage *failImage = [UIImage imageNamed:@"shareError.png"];
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.text = title;
    label.textColor = [UIColor getColor:@"ffffff"];
    label.backgroundColor = [UIColor clearColor];
    [alertView addSubview:label];    
    [label release];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
    if (successOrFail)
    {
        imageView.image = successImage;
    }
    else
    {
        imageView.image = failImage;
    }
    
    [alertView addSubview:imageView];
    [imageView release];
    
    
}
/**
 * @brief 
 * 发表微博结果alert
 * @param [in] params －8个bool值 ，各个微博是否配置且开关是否打开，各自的分享结果
 * @param [out]
 * @return 
 * @note
 */
+ (void)showCustomAlertInfo:(NSDictionary *)params number:(NSUInteger)number
{
    BOOL isConfigSina = [(NSNumber *)[params objectForKey:kConfigSina] boolValue];
    BOOL isConfigQQ = [(NSNumber *)[params objectForKey:kConfigQQ] boolValue];
    BOOL isConfigKaiXin = [(NSNumber *)[params objectForKey:kConfigKaiXin] boolValue];
    BOOL isConfigRenRen = [(NSNumber *)[params objectForKey:kConfigRenRen] boolValue];
    BOOL isShareToSina = [(NSNumber *)[params objectForKey:kShareToSina] boolValue];
    BOOL isShareToQQ = [(NSNumber *)[params objectForKey:kShareToQQ] boolValue];
    BOOL isShareToKaiXin = [(NSNumber *)[params objectForKey:kShareToKaiXin] boolValue];
    BOOL isShareToRenRen = [(NSNumber *)[params objectForKey:kShareToRenRen] boolValue];
    
    int labelOriYOffset = 30;//label的origin.y的值
    int imageViewOriYoffset = 60;
	NSInteger lineHeight = 25;
    
    UIAlertView *av = [[UIAlertView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    av.title = @"分享结果";
	av.message = @"\n";
	NSMutableString *str = [NSMutableString stringWithCapacity:10];
	[str appendString:@"\n"];
	while (number--) {
		[str appendString:@"\n"];
	}    
	av.message = str;
    [av addButtonWithTitle:@"确定"];    

    if (isConfigSina)
    {
        CGRect sinaLabelRect = CGRectMake(20, labelOriYOffset, 80, 80);
        CGRect sinaImageViewRect = CGRectMake(250, imageViewOriYoffset, 16, 16);
        [Common addLabelAndImageViewToAlertView:av
                                  inLabelRect:sinaLabelRect
                              inImageViewRect:sinaImageViewRect
                                     useImage:isShareToSina
                                   labelTitle:@"新浪微博"];
        labelOriYOffset += lineHeight;
        imageViewOriYoffset += lineHeight;
    }
    
    if (isConfigQQ)
    {
        CGRect qqLabelRect = CGRectMake(20, labelOriYOffset, 80, 80);
        CGRect qqImageViewRect = CGRectMake(250, imageViewOriYoffset, 16, 16);
        [Common addLabelAndImageViewToAlertView:av
                                  inLabelRect:qqLabelRect
                              inImageViewRect:qqImageViewRect
                                     useImage:isShareToQQ
                                   labelTitle:@"腾讯微博"];
        labelOriYOffset += lineHeight;
        imageViewOriYoffset += lineHeight;
    }
    
    if (isConfigKaiXin)
    {
        CGRect kaiXinLabelRect = CGRectMake(20, labelOriYOffset, 80, 80);
        CGRect kaiXinImageViewRect = CGRectMake(250, imageViewOriYoffset, 16, 16);
        [Common addLabelAndImageViewToAlertView:av
                                  inLabelRect:kaiXinLabelRect
                              inImageViewRect:kaiXinImageViewRect
                                     useImage:isShareToKaiXin
                                   labelTitle:@"开心网"];
        
        labelOriYOffset += lineHeight;
        imageViewOriYoffset += lineHeight;
    }
    
    if (isConfigRenRen)
    {
        CGRect rrLabelRect = CGRectMake(20, labelOriYOffset, 80, 80);
        CGRect rrImageViewRect = CGRectMake(250, imageViewOriYoffset, 16, 16);
        [Common addLabelAndImageViewToAlertView:av
                                  inLabelRect:rrLabelRect
                              inImageViewRect:rrImageViewRect
                                     useImage:isShareToRenRen
                                   labelTitle:@"人人网"];
        
    }
    
    
    [av show];
    [av release]; 
     
    
}

/**
 * @brief 
 * 图片放缩
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (UIImage*)resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize size = CGSizeMake(width, height);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    else
        UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), image.CGImage);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

/**
 * @brief 
 * 调整图片大小
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 * @brief  解析svg中viewBox数据
 * @param [in] rspData  响应数据
 * @param [out]
 * @return 返回数据width 和 height
 * @note
 */
+ (CGSize)parseLoginResAndSaveInfo:(NSString *)rspData
{
    GDataXMLDocument *doc = [XMLUtils initDocumentWithFile:rspData];
//    GDataXMLElement *retCode = [[doc.rootElement elementsForName:@"svg"] objectAtIndex:0];
//    if (0 == [[retCode stringValue] intValue]) 
//    {
        //保存userID,userName,mobileNumber,userPassward
        GDataXMLNode *userId = [doc.rootElement attributeForName:@"viewBox"];
        NSString *string = [userId stringValue];
//    }
    NSArray *array = [string componentsSeparatedByString:@" "];
    CGFloat width = 75;
    CGFloat height = 75;
    
    if (array && [array count] > 0)
    {
        width = [[array objectAtIndex:2] floatValue];
        height = [[array objectAtIndex:3] floatValue];
    }
    
    return CGSizeMake(width, height);
}


/**
 * @brief  获取本地时间
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (NSString *)localTimer 
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMddHHmmss"];      
	NSString *showtime = [formatter stringFromDate:[NSDate date]];
	[formatter release];
	return showtime;
}


/**
 * @brief  是否激活过
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (BOOL)isNeedActived
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults objectForKey:@"version"];
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //如果版本号一致，
    if (version && [version isEqualToString:curVersion])
    {
        NSNumber *success = [defaults objectForKey:@"result"];
        return ![success boolValue];
    }
    else
    {
        return YES;
    }
    return YES;
}

/**
 * @brief  保存激活结果
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (void)saveActiveResult:(BOOL)isSuccess
{
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [defaluts setValue:curVersion forKey:@"version"];
    [defaluts setValue:[NSNumber numberWithBool:isSuccess] forKey:@"result"];
    [defaluts synchronize];
}

+ (NSString *)getUTCFormateDate:(NSDate *)localDate
{   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];    
    [dateFormatter setTimeZone:timeZone];    
    [dateFormatter setDateFormat:@"YYYYMMDDHHMMSS"];   
    NSString *dateString = [dateFormatter stringFromDate:localDate];    
    [dateFormatter release];    
    return dateString;
}

/**
 * @brief get download directory
 *
 * @param [in]
 * @param [out]　
 * @return　download directory 
 * @note
 */
+ (NSString *)downloadDirectory 
{
	NSString *path = [[[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] autorelease];
	path = [path  stringByAppendingPathComponent:@"Downloads"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
    {
        if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil])
        {
            return nil;
        }
    }
    path = [path stringByAppendingString:@"/"];
	return path;
}

/**
 * @brief 通过url地址获取名称
 *
 * @param [in]
 * @param [out]　
 * @return　
 * @note
 */
+ (NSString *)getNameFromUrl:(NSString *)url 
{
    if (url == nil || [url isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    NSArray *urlInfo = [url componentsSeparatedByString:@"/"];
    
    NSString *fileName = nil;
    if ([urlInfo count] > 0)
    {
        
        fileName = [[[NSString alloc] initWithString:[urlInfo lastObject]] autorelease];
    }        
    
    return fileName;
    
}

/**
 * @brief 通过url地址获取本地存储路径
 *
 * @param [in]
 * @param [out]　
 * @return　
 * @note
 */
+ (NSString *)getLocalPathFromUrl:(NSString *)url 
{
    if (url == nil || [url isKindOfClass:[NSNull class]]) 
    {
        return nil;
    }
    NSString *name = [Common getNameFromUrl:url];
    NSString *filePath = nil; //= [[[NSString alloc] initWithString:@""] autorelease];
    if (name != nil 
        && ![@"" isEqualToString:[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) 
    {
        filePath = [[Common downloadDirectory] stringByAppendingPathComponent:name];
        return filePath;
        
    } 
    else 
    {
        return nil;
    }
}
@end

