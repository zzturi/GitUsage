//
//  DizzinessViewController.m
//  Aico
//
//  Created by cienet on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DizzinessViewController.h"
#import "ReUnManager.h"
#import "MainViewController.h"
#import "CustomSlider.h"
#import "ImageScrollViewController.h"

#define kImageViewWidth             300.0
#define kImageViewHeight            375.0
#define kHeight                     54.0
#define kWidth                      10.0

@implementation DizzinessViewController
@synthesize currentImageView = currentImageView_;
@synthesize sourcePicture = sourcePicture_;
@synthesize movedImageView = movedImageView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"重影";
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] 
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelOperation)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] 
                forState:UIControlStateNormal];
    [confirmBtn addTarget:self 
                   action:@selector(confirmOperation) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    
    self.sourcePicture = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    float originX;
    float originY;
    float imageViewWidth;
    float imageViewHeight;
    
    if (self.sourcePicture.size.width/self.sourcePicture.size.height >= kImageViewWidth/kImageViewHeight)
    {
        originX = kWidth;
        imageViewWidth = kImageViewWidth;
        imageViewHeight = kImageViewWidth*self.sourcePicture.size.height/self.sourcePicture.size.width;
        originY = kHeight + (kImageViewHeight - imageViewHeight)/2;
    }
    else
    {
        originY = kHeight;
        imageViewWidth = kImageViewHeight*self.sourcePicture.size.width/self.sourcePicture.size.height;
        imageViewHeight = kImageViewHeight;
        originX = kWidth + (kImageViewWidth - imageViewWidth)/2;
    }
    //scroll view
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    imageScrollVC_.imageScrollViewRect = CGRectMake(0, 44, 320, 396);
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    imageView.frame = CGRectMake(originX, originY, imageViewWidth, imageViewHeight);
	[self.view insertSubview:imageScrollVC_.view 
                     atIndex:10];
    
    currentImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    self.currentImageView.image = self.sourcePicture;
    [self.currentImageView setClipsToBounds:YES];
    [self.currentImageView setUserInteractionEnabled:YES];
    
	[imageView addSubview:currentImageView_];
    
    //加在currentimageview上的可以移动的半透明的图
    movedImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentImageView_.frame.size.width, currentImageView_.frame.size.height)];
    movedImageView_.image = self.sourcePicture;
    [self.currentImageView addSubview:movedImageView_];
    [self.movedImageView setClipsToBounds:YES];
    self.movedImageView.alpha = 0.5;
    
    center_ = movedImageView_.center;
    if (self.sourcePicture.size.height < self.sourcePicture.size.width)
    {
        //短边可以移动的最大像素
        int shiftPixels_ = (int)imageViewHeight/25.0;
        moveWidth_ = shiftPixels_*imageViewWidth/imageViewHeight;
        moveHeight_ = shiftPixels_;
    }
    else
    {
        int shiftPixels_ = (int)imageViewWidth/25.0;
        moveWidth_  = shiftPixels_;
        moveHeight_ = shiftPixels_*imageViewHeight/imageViewWidth;
    }
    
    //添加滑块
    effectSlider_ = [[CustomSlider alloc] initWithTarget:self frame:kSliderRect showBkgroundImage:YES];
    effectSlider_.slider.minimumValue = 0;
    effectSlider_.slider.maximumValue = 1;
    effectSlider_.slider.value = 0.5;
    effectSlider_.step = 0.005f;
    effectSlider_.slider.continuous = YES;
    [self.view addSubview:effectSlider_];
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    self.sourcePicture = nil;
    self.currentImageView = nil;
    self.movedImageView = nil;
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
    [super viewDidUnload];
}

- (void)dealloc
{
    self.sourcePicture = nil;
    self.currentImageView = nil;
    self.movedImageView = nil;
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
    [super dealloc];
}
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

/**
 * @brief 
 * 不保存返回上层页面
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (IBAction)cancelOperation
{
    [ReUnManager sharedReUnManager].snapImage = nil;
    [effectSlider_ removePopover];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 
 * 保存图片，回到main页面
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (IBAction)confirmOperation
{
    [effectSlider_ removePopover];
    UIImage *currentImage = nil;
    if (self.currentImageView.image.size.width<=150 
        && self.currentImageView.image.size.height<=150) 
    {
        UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(self.currentImageView.bounds.size, YES, self.currentImageView.image.size.width/self.currentImageView.bounds.size.width) ; 
    }
    [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	currentImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
    [[ReUnManager sharedReUnManager] storeImage:currentImage];
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}

/**
 * @brief 
 * 生成特效列表cell中的缩略图
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (UIImage *)getSmallImage:(UIImage *)inImage
{
    UIImage *image = nil;
    UIGraphicsBeginImageContext(inImage.size);
    CGContextRef thisctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(thisctx, M_PI);
    CGContextTranslateCTM(thisctx, -inImage.size.width, 0);
    CGContextScaleCTM(thisctx, -1, 1);
    CGContextDrawImage(thisctx, CGRectMake(-inImage.size.width, -inImage.size.height, inImage.size.width, inImage.size.height), [inImage CGImage]);
    CGContextSetAlpha(thisctx, 0.5);
    CGContextDrawImage(thisctx, CGRectMake(-inImage.size.width+2, -inImage.size.height+2, inImage.size.width, inImage.size.height), [inImage CGImage]);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -  
#pragma mark CustomSlider Delegate Method
/**
 * @brief 
 * 拖动滑块,改变重影位置
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)sliderValueChanged:(float)value
{
    float width;
    float height;
    if (value < 0.5)
    {
        width = -moveWidth_*(0.5-value)/0.5;
        height = -moveHeight_*(0.5-value)/0.5;
    }
    else 
    {
        width = moveWidth_*(value-0.5)/0.5;
        height = moveHeight_*(value-0.5)/0.5;
    }
    self.movedImageView.center = CGPointMake(center_.x+width, center_.y+height);
    
    UIImage *currentImage = nil;
    UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
    [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    currentImage = UIGraphicsGetImageFromCurrentImageContext();	
    UIGraphicsEndImageContext();
    [[ReUnManager sharedReUnManager] storeSnap:currentImage];
}
@end
