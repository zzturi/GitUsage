//
//  DistirtBaseViewController.m
//  Aico
//
//  Created by 操 于 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DistirtBaseViewController.h"
#import "MainViewController.h"
#import "CustomSlider.h"
#import "GlobalDef.h"
#import "ReUnManager.h"
#import "UIImage+extend.h"



@implementation DistirtBaseViewController

#pragma mark -
#pragma mark CustomSliderDelegate Methods

/**
 * @brief  
 *
 * 根据图片质量返回处理后的图片路径
 * @param [in] N/A
 * @param [out] N/A
 * @return 调整后的图片路径
 * @note N/A
 */
+ (UIImage *) adjustedImagePathForImage:(UIImage *)image imageSize:(CGSize)imagesize
{
    CGSize stdSize = image.size;
	CGFloat origWidth = image.size.width;
	CGFloat origHeight = image.size.height;
	CGFloat radio = origWidth/origHeight;
	CGFloat radio1 = origHeight/origWidth;
    CGFloat width = imagesize.width;
    CGFloat height = imagesize.height;
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
 * @brief slider值改变
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)sliderValueChanged:(float)value
{
}

/**
 * @brief 手指从slider上移开时的处理函数 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)sliderTouchUp
{
}

/**
 * @brief 点击导航栏上的确定按钮 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)confirmButtonPressed
{
    if (nil != slider_) 
    {
        [slider_ removePopover];
    }

    if (nil != destImage_)
    {
        [[ReUnManager sharedReUnManager] storeImage:destImage_];
    }
    
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}

/**
 * @brief 点击导航栏上的取消按钮 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)cancelButtonPressed
{
    if (nil != slider_) 
    {
        [slider_ removePopover];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief setSlider
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setSlider
{
    slider_ = [[CustomSlider alloc] initWithTarget:self frame:kSliderRect showBkgroundImage:YES];
    slider_.slider.minimumValue = -100;
	slider_.slider.maximumValue = 100;
	slider_.slider.value = 100;
	slider_.step = 1.0f;
    slider_.slider.continuous = YES;
    [self.view addSubview:slider_];
}

/**
 * @brief showImageRect
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (CGRect)showImageRect
{
    return CGRectZero;
}

#pragma mark - viewDidLoad 

/**
 * @brief viewDidLoad
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    CGRect imageRc = [Common adaptImageToScreen:[rm getGlobalSrcImage]];
    srcImage_ = [rm getGlobalSrcImage];
    
//    UIImage *afterImg = [DistirtBaseViewController adjustedImagePathForImage:srcImage_
//                                                                   imageSize:imageRc.size];
    
    UIImage *afterImg = [DistirtBaseViewController adjustedImagePathForImage:srcImage_
                                                                   imageSize:CGSizeMake(320, 480)];
    if (afterImg != nil)
    {
        srcImage_ = afterImg;
    }
    srcImage_ = [Common scaleFromImage:srcImage_ toSize:imageRc.size];
    
    CGRect showImageRect = [self showImageRect];
    CGFloat imageFrameWidth = srcImage_.size.width; 
    CGFloat imageFrameHeight = srcImage_.size.height;

    imageRect_ = CGRectMake((int)(showImageRect.origin.x+(showImageRect.size.width-imageFrameWidth)/2), 
                            (int)(showImageRect.origin.y+(showImageRect.size.height-imageFrameHeight)/2),
                            (int)(imageFrameWidth),
                            (int)(imageFrameHeight));       
    [srcImage_ retain];
    
    //图片像素
    imagePixel_ = [Common RequestImagePixelData:srcImage_];
    destImagePixel_ = (unsigned char *)malloc(4*srcImage_.size.width*srcImage_.size.height);
     
    //navigationItem
    self.navigationController.navigationBarHidden = NO;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]];
	[Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    
    //cancelBarBtn
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];	
    
    //confirmBtn
	UIButton *confirmBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];    
}

/**
 * @brief 旋转
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * @brief 视图卸载
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidUnload
{
    RELEASE_OBJECT(srcImage_)
	RELEASE_OBJECT(slider_)
    free(destImagePixel_);
    
    [super viewDidUnload];
}

/**
 * @brief 析构
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)dealloc
{
    RELEASE_OBJECT(srcImage_)
    RELEASE_OBJECT(destImage_)
	RELEASE_OBJECT(slider_)
    free(destImagePixel_);
    
    [super dealloc];
}

/**
 * @brief 释放图片数据 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
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
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, 
                                                              imgPixelData, 
                                                              imgPixelWidth * imgPixelHeight * 4,
                                                              ProviderReleaseData);
	// prep the ingredients
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * imgPixelWidth;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	
	// make the cgimage
	CGImageRef imageRef = CGImageCreate(imgPixelWidth, imgPixelHeight, 
                                        bitsPerComponent, bitsPerPixel, 
                                        bytesPerRow, colorSpaceRef, 
                                        bitmapInfo, provider, NULL, 
                                        NO, renderingIntent);
	
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	
	CFRelease(imageRef);
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
    return finalImage;
}

@end
