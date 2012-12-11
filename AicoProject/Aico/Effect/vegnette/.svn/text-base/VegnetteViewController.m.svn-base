//
//  VegnetteViewController.m
//  Aico
//
//  Created by chentao on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VegnetteViewController.h"
#import "ReUnManager.h"
#import "MainViewController.h"

@implementation VegnetteViewController
@synthesize srcImage = srcImage_;
@synthesize vegnetteView = vegnetteView_;
@synthesize activityIndicatorView = activityIndicatorView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    //添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    //添加确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    // set the title
    colorBtn_ = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [colorBtn_.layer setMasksToBounds:YES];
    [colorBtn_.layer setCornerRadius:2];
    [colorBtn_ addTarget:self action:@selector(colorBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colorBtn_ setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]];
    
    //原来按钮太小,点击不便
    UIButton *tapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [tapButton setBackgroundColor:[UIColor clearColor]];
    [tapButton addTarget:self 
                  action:@selector(colorBtnPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 44)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    titleLabel.text = @"边缘模糊";
    [titleView addSubview:titleLabel];
    [titleView addSubview:colorBtn_];
    [titleView addSubview:tapButton];
    self.navigationItem.titleView = titleView;
    [titleLabel release];
    [titleView release];
    [tapButton release];
    // 获取原图片
    self.srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
 	imageScrollVC_ = [[ImageScrollViewController alloc] init];
    imageScrollVC_.imageScrollViewRect = CGRectMake(0, 44, 320, 396);
    [self.view insertSubview:imageScrollVC_.view atIndex:0];
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    imageView.frame = [Common adaptImageToScreen:[[ReUnManager sharedReUnManager] getGlobalSrcImage]];
    vegnetteView_ = [[VegnetteView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    [imageView addSubview:vegnetteView_];  
    
    radiusMin_ =  MIN(srcImage_.size.width, srcImage_.size.height)/20;
    radiusMax_ = sqrtf(srcImage_.size.width * srcImage_.size.width + srcImage_.size.height * srcImage_.size.height)/2;
    opacity_ = 0.75;
    chooseColorButtonPressed_ = NO;
    
    //ios5设置导航栏背景图片
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];   
    //添加滑块
    effectSlider_ = [[CustomSlider alloc] initWithTarget:self frame:kSliderRect showBkgroundImage:YES];
    effectSlider_.slider.minimumValue = -100;
    effectSlider_.slider.maximumValue = 100;
    effectSlider_.slider.value = 100;
    effectSlider_.step = 2.0f;
    effectSlider_.minimumShowPercentValue = 0;
    effectSlider_.maximumShowPercentValue = 100;
    effectSlider_.slider.continuous = YES;
    effectSlider_.isShowProgress = YES;
    [self.view addSubview:effectSlider_];
    
    [self addActivityIndicatorView];
//    [self performSelectorInBackground:@selector(makeEffect) withObject:nil];
    [self performSelector:@selector(makeEffect) withObject:nil afterDelay:0.05];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    RELEASE_OBJECT(imageScrollVC_);
    RELEASE_OBJECT(effectSlider_);
    self.srcImage = nil;
    self.activityIndicatorView = nil;
    self.vegnetteView = nil;
    RELEASE_OBJECT(colorBtn_);
}

- (void)dealloc
{
    [colorBtn_ release];
    self.vegnetteView = nil;
    RELEASE_OBJECT(popViewCtrl_);
    self.activityIndicatorView = nil;
    self.srcImage = nil;
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)makeEffect
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
//    imageView.frame = [Common adaptImageToScreen:[[ReUnManager sharedReUnManager] getGlobalSrcImage]];
//    if (vegnetteView_ == nil)
//    {
//        vegnetteView_ = [[VegnetteView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    }  
    self.vegnetteView.opacityValue = 0.75;
    self.vegnetteView.radius = radiusMin_;
    [self.vegnetteView setNeedsDisplay]; 
    
    [self sliderTouchUp];
    [self removeActivityIndicatorView];
    
    [pool release];    
}
#pragma mark
#pragma mark Button Method
/**
 * @brief 
 * 取消按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancelButtonPressed:(id)sender
{
    //必须加这句话，否则crash,这里改成yes，下面removepopover，就不会remove，而是在effectslider_的dealloc中移除
    effectSlider_.isCurrentValueViewOnLastWindow = YES;
    
    [self removeActivityIndicatorView];
    [ReUnManager sharedReUnManager].snapImage = nil;
    [effectSlider_ removePopover];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * @brief 
 * 确定按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)confirmButtonPressed:(id)sender
{
    //必须加这句话，否则crash,这里改成yes，下面removepopover，就不会remove，而是在effectslider_的dealloc中移除
    effectSlider_.isCurrentValueViewOnLastWindow = YES;
    
    [effectSlider_ removePopover];   
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];    
    self.srcImage = imageView.image;
    UIImage *currentImage = nil;
    UIImage *image = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    
    if (image.size.width<=150 && image.size.height<=150)
    {
        UIGraphicsBeginImageContext(imageView.bounds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, image.size.width/imageView.bounds.size.width) ;
    }    
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.srcImage = currentImage;
    [[ReUnManager sharedReUnManager] storeImage:self.srcImage];
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}
/**
 * @brief 
 * 点击透明块按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)colorBtnPressed:(id)sender
{
    chooseColorButtonPressed_ = YES;
    effectSlider_.isCurrentValueViewOnLastWindow = NO;
    
    if (popViewCtrl_)
    {
        RELEASE_OBJECT(popViewCtrl_);
    }
    // 设置透明块   
    ColorPickerViewController *colorPickerCtrl = [[ColorPickerViewController alloc] init];
    colorPickerCtrl.fromViewControllerID = (3 + 2451);
    colorPickerCtrl.delegate = self;
    colorPickerCtrl.view.frame = CGRectMake(0, 0, 317, 132);
    [colorPickerCtrl setHue:1 saturation:1 brightness:1 opacity:self.vegnetteView.opacityValue];
	popViewCtrl_ = [[IMPopoverController alloc] initWithContentViewController:colorPickerCtrl];
    popViewCtrl_.deletage = self;     
	popViewCtrl_.popOverSize = colorPickerCtrl.view.bounds.size;
    [colorPickerCtrl release]; 
    //弹出框动画
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [popViewCtrl_.popOverWindow.layer addAnimation:transition forKey:@"Transition"];
    
	[popViewCtrl_ presentPopoverFromRect:CGRectMake(1.5, 50, 317, 132) inView:self.view animated:YES];
      
}
#pragma mark
#pragma mark ColorPaletteViewController Delegate Method
- (void)closeViewAndSetColorHue:(float)hue saturation:(float)sat brightness:(float)bri opacity:(float)opa
{
    [popViewCtrl_ dismissPopoverAnimated:YES];
    opacity_ = opa;
    NSLog(@"%f", opacity_);
    self.vegnetteView.opacityValue = opacity_;
    [self.vegnetteView setNeedsDisplay];
    [colorBtn_ setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:opacity_]];
}

#pragma mark
#pragma mark CustomSlider Delegate Method
- (void)sliderTouchUp
{
    //如果不是原图，则保存，是原图则不保存
    if (fabsf(effectSlider_.slider.value) > 0.000001)
    {
        UIImage *currentImage = nil;
        UIGraphicsBeginImageContext(self.vegnetteView.bounds.size);
        [self.vegnetteView.layer renderInContext:UIGraphicsGetCurrentContext()];
        currentImage = UIGraphicsGetImageFromCurrentImageContext();	
        UIGraphicsEndImageContext();
        [[ReUnManager sharedReUnManager] storeSnap:currentImage];
    }
}

- (void)sliderValueChanged:(float)value
{
    [self removeActivityIndicatorView]; 
    [self performSelectorInBackground:@selector(addActivityIndicatorView) withObject:nil]; 
    
    self.vegnetteView.radius = radiusMax_ + (value + 100)/200.0 * (radiusMin_-radiusMax_);
    self.vegnetteView.opacityValue = opacity_;
    [self.vegnetteView setNeedsDisplay];

    //0.01会导致：进特效界面调节滑块，转圈不会消失，所以不能用0.01
    [self performSelector:@selector(removeActivityIndicatorView) withObject:nil afterDelay:0.05];
}

/**
 * @brief 
 * 特效结束，移除activityindicatorview
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)removeActivityIndicatorView
{
    //这个一定要加，在ios4上会报内存泄露
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (self.activityIndicatorView && [self.activityIndicatorView isAnimating])
    {
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView = nil;
    }
    //根据是否点击设置透明度按钮，移除指示器
    UIWindow *lastWindow = nil;
    if (chooseColorButtonPressed_)
    {
        int count = [[[UIApplication sharedApplication]windows] count];
        lastWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:count-2];
    }
    else
    {
        lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    }
    
    for (UIView *view in [lastWindow subviews])
    {
        if (view.tag == kEffectActivityBkgTag)
        {
            if ([view isKindOfClass:[UIActivityIndicatorView class]])
            {
                UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)view;
                if ([activityView isAnimating])
                {
                    [activityView stopAnimating];
                }
            }
            [view removeFromSuperview];
        }
    }
    [pool release];
}
/**
 * @brief 
 * 特效开始，添加activityindicatorview
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)addActivityIndicatorView
{
    [self removeActivityIndicatorView];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
	
    UIView *activityView = [[UIView alloc] initWithFrame:self.view.bounds];
    activityView.tag = kEffectActivityBkgTag;
    activityView.backgroundColor = [UIColor clearColor];
    CGRect rect = activityView.bounds;
    
    activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    rect.size = CGSizeMake(40, 40);
    rect.origin.x = (activityView.frame.size.width - rect.size.width)/2;
    rect.origin.y = (activityView.frame.size.height - 44 - rect.size.height)/2;
    self.activityIndicatorView.frame = rect;
    [self.activityIndicatorView startAnimating];
    [activityView addSubview:self.activityIndicatorView];
    //根据是否点击设置透明度按钮，移除指示器
    UIWindow *lastWindow = nil;
    if (chooseColorButtonPressed_)
    {
        int count = [[[UIApplication sharedApplication]windows] count];
        lastWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:count-2];
    }
    else
    {
        lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    }
    [lastWindow addSubview:activityView];
    [activityView release];
	
    [pool release];
}
@end
