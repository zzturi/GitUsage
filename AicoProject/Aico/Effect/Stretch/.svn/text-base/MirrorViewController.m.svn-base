//
//  MirrorViewController.m
//  Mirror
//
//  Created by yu cao on 12-6-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MirrorViewController.h"
#import "ReUnManager.h"
#import "Common.h"


@implementation MirrorViewController

/**
 * @brief 镜像效果 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)mirrorEffect:(UIImage *)image
{
    unsigned char *imagePixel = [Common RequestImagePixelData:image];
    
    int row=0;
    int col=0;
    int index=0;
    int mirrorIndex=0;
    
    //镜像
    for (row=0; row<image.size.height; ++row) 
    {
		for (col=0; col<image.size.width/2; ++col) 
        {
			index = 4*(row*image.size.width+col);
            mirrorIndex = 4*(row*image.size.width+(image.size.width-col-1));
            
            imagePixel[mirrorIndex] = imagePixel[index];
            imagePixel[mirrorIndex+1] = imagePixel[index+1];
            imagePixel[mirrorIndex+2] = imagePixel[index+2]; 
            imagePixel[mirrorIndex+3] = imagePixel[index+3];	
		}
	}
    
    return [Common GenerateImageFromData:imagePixel 
                       withImgPixelWidth:image.size.width 
                      withImgPixelHeight:image.size.height];    
}

/**
 * @brief 镜像效果 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)mirrorEffect
{  
    int row = 0;
    int col = 0;
    int index = 0;
    int mirrorIndex = 0;
    
    int imageHeight = srcImage_.size.height;
    int imageWidth = srcImage_.size.width;
    int halfWidth = imageWidth/2;
    
    NSLog(@"%mirrorEffect begin");
    
    //镜像
    for (row=0; row<imageHeight; ++row) 
    {
		for (col=0; col<imageWidth; ++col) 
        {
			index = 4*(row*imageWidth+col);
            mirrorIndex = 4*(row*imageWidth+(imageWidth-col-1));
            
            if (leftMirror_) 
            {
                if (col < halfWidth)
                {
                    destImagePixel_[index] = imagePixel_[index];
                    destImagePixel_[index+1] = imagePixel_[index+1];
                    destImagePixel_[index+2] = imagePixel_[index+2]; 
                    destImagePixel_[index+3] = imagePixel_[index+3];	
                }
                else
                {
                    destImagePixel_[index] = imagePixel_[mirrorIndex];
                    destImagePixel_[index+1] = imagePixel_[mirrorIndex+1];
                    destImagePixel_[index+2] = imagePixel_[mirrorIndex+2]; 
                    destImagePixel_[index+3] = imagePixel_[mirrorIndex+3];	
                }
            }
            else
            {
                if (col < halfWidth)
                {
                    destImagePixel_[index] = imagePixel_[mirrorIndex];
                    destImagePixel_[index+1] = imagePixel_[mirrorIndex+1];
                    destImagePixel_[index+2] = imagePixel_[mirrorIndex+2]; 
                    destImagePixel_[index+3] = imagePixel_[mirrorIndex+3];	
                }
                else
                {
                    destImagePixel_[index] = imagePixel_[index];
                    destImagePixel_[index+1] = imagePixel_[index+1];
                    destImagePixel_[index+2] = imagePixel_[index+2]; 
                    destImagePixel_[index+3] = imagePixel_[index+3];	
                }
            }
		}
	}
    
    NSLog(@"%mirrorEffect end");
    
    return [Common GenerateImageFromData:destImagePixel_ 
                       withImgPixelWidth:srcImage_.size.width 
                      withImgPixelHeight:srcImage_.size.height]; 
}

/**
 * @brief 图片显示区域 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (CGRect)showImageRect 
{
    return CGRectMake(0, 44, 320, 436);
}

/**
 * @brief 视图加载 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"镜像";	
    
    //imageScrollVC_
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    imageScrollVC_.imageScrollViewRect = CGRectMake(0, 44, 320, 436);
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];    
    imageView.frame = imageRect_;
    imageView.image = srcImage_;	
	[self.view insertSubview:imageScrollVC_.view atIndex:0];
    
    imageScrollVC_.singleTapDelegate = self;
    
    leftMirror_ = NO;
    [self singleTap];
}

/**
 * @brief 视图消失
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidDisappear:(BOOL)animated
{   
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    
    [super viewDidDisappear:animated];    
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
    RELEASE_OBJECT(imageScrollVC_);
    
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
    RELEASE_OBJECT(imageScrollVC_);
    
    [super dealloc];
}

#pragma mark - singleTap

/**
 * @brief 单击
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)singleTap
{
	leftMirror_ = !leftMirror_;	
    UIImage *mirrorImage = [[self mirrorEffect] retain];
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    imageView.image = mirrorImage;
    [destImage_ release];
	destImage_ = mirrorImage;
    
    if (nil != destImage_) 
    {        
        [[ReUnManager sharedReUnManager] storeSnap:destImage_];
    } 
}

@end
