//
//  PhotoEffectsViewController.m
//  Aico
//
//  Created by Jiang Liyin on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PhotoEffectsViewController.h"
#import "UIImage+extend.h"
#import "ImageInfo.h"
#import "ImageScrollViewController.h"
#import "MainViewController.h"
#import "ReUnManager.h"
#import "EffectMethods.h"
#import "ColorEffectsCommon.h"
#import "VegnetteView.h"




@implementation PhotoEffectsViewController
@synthesize srcImage = srcImage_;
@synthesize effectType = effectType_;
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

- (void)dealloc
{
    self.srcImage = nil;
    RELEASE_OBJECT(effectImgScrollView_);
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
	RELEASE_OBJECT(viewClip_);
    self.activityIndicatorView = nil;
    RELEASE_OBJECT(cloneImgInfo_);
    RELEASE_OBJECT(popViewCtrl_);
    RELEASE_OBJECT(rectangleView_);
    RELEASE_OBJECT(rainbowMaskView_);
    RELEASE_OBJECT(colorArray_);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    
	
	[self customView];

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
    if (effectType_ == EEffectDuoTone)
    {
        //点击具有效果的按钮
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        leftButton.tag = 4820;
        [leftButton addTarget:self action:@selector(selectButtonLeftPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 0, 44, 44)];
        [rightButton setBackgroundColor:[UIColor clearColor]];
        rightButton.tag = 4821;
        [rightButton addTarget:self action:@selector(selectButtonRightPressed:) forControlEvents:UIControlEventTouchUpInside];
         
        //只显示颜色的按钮
        UIButton *selectButtonLeft = [[UIButton alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
        selectButtonLeft.tag = 4822;
        [selectButtonLeft.layer setMasksToBounds:YES];
        [selectButtonLeft.layer setCornerRadius:2];        
        [selectButtonLeft setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:0.75 ]];
        
        
        UIButton *selectButtonRight = [[UIButton alloc] initWithFrame:CGRectMake(115, 12, 20, 20)];
        selectButtonRight.tag = 4823;
        [selectButtonRight.layer setMasksToBounds:YES];
        [selectButtonRight.layer setCornerRadius:2];        
        [selectButtonRight setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:0.75]]; 
      
        //初始的黄蓝色调颜色数组
        NSNumber *r1, *g1, *b1, *r2, *g2, *b2;
        r1 = [NSNumber numberWithInt: 0];
        g1 = [NSNumber numberWithInt: 0];
        b1 = [NSNumber numberWithInt: 255];
        r2 = [NSNumber numberWithInt: 255];
        g2 = [NSNumber numberWithInt: 255];
        b2 = [NSNumber numberWithInt: 0];
        colorArray_ = [[NSMutableArray alloc] initWithObjects:r1, g1, b1, r2, g2, b2, nil];    
              
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 44)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        titleLabel.text = @"双色调";
        
        [titleView addSubview:titleLabel];
        [titleView addSubview:selectButtonLeft];
        [titleView addSubview:selectButtonRight];
        [titleView addSubview:leftButton];
        [titleView addSubview:rightButton];
        self.navigationItem.titleView = titleView;
        
        [titleLabel release];        
        [selectButtonLeft release];
        [selectButtonRight release];
        [leftButton release];
        [rightButton release];
        [titleView release];
    }
   
    
    if (effectType_ == EEffectNeon)
    {
        UIButton *colorBlockBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
        [colorBlockBtn.layer setMasksToBounds:YES];
        [colorBlockBtn.layer setCornerRadius:2];
        [colorBlockBtn addTarget:self action:@selector(colorBlockBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [colorBlockBtn setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
        colorBlockBtn.tag = 4741;
        
        //原来按钮太小,点击不便
        UIButton *tapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [tapButton setBackgroundColor:[UIColor clearColor]];
        [tapButton addTarget:self 
                      action:@selector(colorBlockBtnPressed:) 
            forControlEvents:UIControlEventTouchUpInside];
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 44)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        titleLabel.text = @"霓虹灯";
        [titleView addSubview:titleLabel];
        [titleView addSubview:colorBlockBtn];
        [titleView addSubview:tapButton];
        self.navigationItem.titleView = titleView;
        [titleLabel release];
        [titleView release];
        [colorBlockBtn release];
        [tapButton release];

        hue_ = 0.0;
        saturation_ = 1.0;
        bright_ = 191.25;
        opacity_ = 1.0;
        chooseColorButtonPressed_ = NO;
    }
      
    if (cloneImgInfo_ == nil)
    {
        [self cloneImgInfo];
    }
    [self addActivityIndicatorView];

    [self performSelectorInBackground:@selector(makeEffect) withObject:nil];
}

- (void)viewDidUnload
{
    self.srcImage = nil;
    RELEASE_OBJECT(effectImgScrollView_);
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
	RELEASE_OBJECT(viewClip_);
    self.activityIndicatorView = nil;
    RELEASE_OBJECT(cloneImgInfo_);
    RELEASE_OBJECT(rectangleView_);
    RELEASE_OBJECT(rainbowMaskView_);   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    [super viewDidDisappear:animated];
}
#pragma mark-
#pragma mark Custom Methods
/**
 * @brief 
 * 定制界面
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)customView
{
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    imageScrollVC_.effectType = effectType_;
    if (effectType_ == EEffectInvertId || effectType_ == EEffectTiltShiftId || effectType_ == EEffectHeatMap)
    {
        imageScrollVC_.imageScrollViewRect = CGRectMake(0, 44, 320, 436);
    }
    else if (effectType_ == EEffectSpotlightId || effectType_ == EEffectTiltShiftId)
    {
        imageScrollVC_.isEnableZoom = NO;
    }
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    imageView.frame = [Common adaptImageToScreen:[[ReUnManager sharedReUnManager] getGlobalSrcImage]];
    if (effectType_ == EEffectTiltShiftId)
    {
        UIView *view = [imageScrollVC_.view viewWithTag:1002];
        view.frame = imageView.frame;
        imageView.frame = view.bounds;
    }
    imageView.image = self.srcImage;
	
	[self.view insertSubview:imageScrollVC_.view atIndex:0];
    
    //ios5设置导航栏背景图片
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    
    if (effectType_ != EEffectInvertId && effectType_ != EEffectTiltShiftId && effectType_ != EEffectHeatMap)
    {
        //添加滑块
        effectSlider_ = [[CustomSlider alloc] initWithTarget:self frame:kSliderRect showBkgroundImage:YES];
        effectSlider_.slider.minimumValue = -100;
        effectSlider_.slider.maximumValue = 100;
        effectSlider_.slider.value = 100;
        effectSlider_.step = 1.0f;
        effectSlider_.slider.continuous = YES;
		[self.view addSubview:effectSlider_];
    }
    if (effectType_ == EEffectDuoTone) 
    {
        effectSlider_.slider.minimumValue = 0;
        effectSlider_.slider.maximumValue = 100;
        effectSlider_.slider.value = 100;
        effectSlider_.step = 1.0f;
        effectSlider_.minimumShowPercentValue = 0;
		effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
    }
    if (effectType_ == EEffectRainbowId)
    {
        effectSlider_.slider.minimumValue = 0;
        effectSlider_.slider.maximumValue = 100;
        effectSlider_.slider.value = 100;
        effectSlider_.step = 1.0f;
        effectSlider_.minimumShowPercentValue = 0;
		effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
        
        UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
        if (rainbowMaskView_ == nil)
        {
            rainbowMaskView_ = [[GradientView alloc] initWithFrame:imageView.bounds];
        }
        [imageView addSubview:rainbowMaskView_];
        
    }
    if (effectType_ == EEffectPaintingId)
    {
        effectSlider_.slider.minimumValue = 2;
        effectSlider_.slider.maximumValue = 52;
        effectSlider_.slider.value = 2;
        effectSlider_.step = 1.0f;
        effectSlider_.minimumShowPercentValue = 0;
		effectSlider_.maximumShowPercentValue = 50;
        effectSlider_.slider.continuous = YES;
    }
    if (effectType_ == EEffectNeon)
    {
        effectSlider_.step = 2.0f;
        effectSlider_.minimumShowPercentValue = 0;
        effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
    }
    if (effectType_ == EEffectSoftLight || effectType_ == EEffectReverseFilm)
    {
        effectSlider_.slider.minimumValue = -100;
        effectSlider_.slider.maximumValue = 100;
        effectSlider_.slider.value = 100;
        effectSlider_.step = 2.0f;
        effectSlider_.minimumShowPercentValue = 0;
        effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
    }
    if (effectType_ == EEffectGrayScaleId) 
    {
        effectSlider_.slider.minimumValue = -100;
        effectSlider_.slider.maximumValue = 100;
        effectSlider_.slider.value = 100;
        effectSlider_.step = 1.0f;
        effectSlider_.minimumShowPercentValue = -100;
        effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
    }
    if (effectType_ == EEffectBlackWhiteId)
    {
        effectSlider_.slider.minimumValue = 0;
        effectSlider_.slider.maximumValue = 255;
        effectSlider_.slider.value = 127;
        effectSlider_.step = 1.0f;
        effectSlider_.minimumShowPercentValue = -100;
        effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
        [self.view addSubview:effectSlider_];

    }
    if (effectType_ == EEffectRedScaleId)
    {
        effectSlider_.slider.minimumValue = 0;
        effectSlider_.slider.maximumValue = 100;
        effectSlider_.slider.value = 100;
        effectSlider_.step = 1.0f;
        effectSlider_.minimumShowPercentValue = 0;
        effectSlider_.maximumShowPercentValue = 100;
        effectSlider_.slider.continuous = YES;
        [self.view addSubview:effectSlider_];
    }
    
	if (effectType_ == EEffectSpotlightId)
	{
		effectSlider_.slider.minimumValue = 0;
		effectSlider_.slider.maximumValue = 200;
		effectSlider_.slider.value = 0;
		effectSlider_.step = 2.0f;
		effectSlider_.minimumShowPercentValue = 0;
		effectSlider_.maximumShowPercentValue = 100;
		
		imageScrollVC_.delegateDoPan = self;
		CGSize size = self.view.frame.size;
		imageScrollVC_.view.frame = CGRectMake(0, 0, size.width, size.height-kSliderRect.size.height);
		[Common imageView:imageView autoFitView:imageScrollVC_.view margin:CGPointMake(10, 10)];
		
		CGFloat imageWidth = self.srcImage.size.width;
		CGFloat imageHeight = self.srcImage.size.height;
		CGFloat scale = imageWidth / imageView.frame.size.width;
		CGFloat radius = 50.0f;	// 显示在界面上是50,其实在真正的图片上不是50，因为图片被缩小了
		
		CGRect rect = imageView.frame;
		ConcentricCircle circle;
		circle.xView = rect.origin.x + rect.size.width / 2;
		circle.yView = rect.origin.y + rect.size.height / 2;
		circle.x = imageWidth / 2;
		circle.y = imageHeight / 2;
		circle.minRadius = radius * scale;
		circle.maxRadius = circle.minRadius + effectSlider_.slider.value;
		
		CGPoint pt = {rect.origin.x + rect.size.width/2 - radius, rect.origin.y + rect.size.height/2 - radius};
		viewClip_ = [[CircleClipView alloc] initWithFrame:CGRectMake(pt.x, pt.y, radius*2, radius*2) circle:&circle imageView:imageView];
		viewClip_.scale = scale;
		viewClip_.layer.cornerRadius = radius;
		[self.view addSubview:viewClip_];
	}
    if (effectType_ == EEffectTiltShiftId)
    {
        CGSize size = self.view.frame.size;
		imageScrollVC_.view.frame = CGRectMake(0, 0, size.width, size.height);
		[Common imageView:imageView autoFitView:imageScrollVC_.view margin:CGPointMake(10, 10)];
        
        UIView *view = [imageScrollVC_.view viewWithTag:1002];
        view.frame = imageView.frame;
        imageView.frame = view.bounds;
		
		CGFloat imageWidth = self.srcImage.size.width;
		CGFloat imageHeight = self.srcImage.size.height;
		CGFloat scale = imageWidth / imageView.frame.size.width;
		CGFloat radius = 50.0f;	// 显示在界面上是50,其实在真正的图片上不是50，因为图片被缩小了
		
		CGRect rect = imageView.frame;
        Rectangle rectangle;
        rectangle.xView = rect.origin.x + rect.size.width/2;
        rectangle.yView = rect.origin.y + rect.size.height/2;
        rectangle.x = imageWidth/2;
        rectangle.y = imageHeight/2;
        rectangle.heightInView = radius;
        rectangle.widthInView = rect.size.width;
        rectangleView_ = [[RectangleClipView alloc] initWithFrame:rect rectangle:&rectangle imageView:imageView superController:self];
        rectangleView_.scale = scale;
        [view addSubview:rectangleView_];
    }
}
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
    if (effectType_ == EEffectNeon)
    {
        effectSlider_.isCurrentValueViewOnLastWindow = YES;
    }
    [ReUnManager sharedReUnManager].snapImage = nil;
    [effectSlider_ removePopover];
    [self removeActivityIndicatorView];
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
    if (effectType_ == EEffectNeon)
    {
        effectSlider_.isCurrentValueViewOnLastWindow = YES;
    }
    
    [effectSlider_ removePopover];
    self.srcImage = [self getCurrentImage];
    [[ReUnManager sharedReUnManager] storeImage:self.srcImage];
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}
/**
 * @brief 
 * 颜色块按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)colorBlockBtnPressed:(id)sender
{
    //解决滑块标签不显示问题
    if (effectType_ == EEffectNeon)
    {
        effectSlider_.isCurrentValueViewOnLastWindow = NO;
        chooseColorButtonPressed_ = YES;
    }
    
    if (popViewCtrl_)
    {
        [popViewCtrl_ release],popViewCtrl_ = nil;
    }
    // 设置颜色块   
    ColorPickerViewController *colorPickerCtrl = [[ColorPickerViewController alloc] init];
    colorPickerCtrl.delegate = self;
    colorPickerCtrl.fromViewControllerID = (4 + 2451);
    colorPickerCtrl.view.frame = CGRectMake(0, 0, 317, 190);
    [colorPickerCtrl setHue:hue_ saturation:saturation_ brightness:bright_ opacity:1.0];
	popViewCtrl_ = [[IMPopoverController alloc] initWithContentViewController:colorPickerCtrl];
    popViewCtrl_.deletage = self; 
  	popViewCtrl_.popOverSize = colorPickerCtrl.view.bounds.size;
    
    //弹出框动画
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [popViewCtrl_.popOverWindow.layer addAnimation:transition forKey:@"Transition"];
	[popViewCtrl_ presentPopoverFromRect:CGRectMake(1.5, 50, 317, 190) inView:self.view animated:YES];
    [colorPickerCtrl release];  
}
/**
* @brief 
* 双色调特效左边颜色块按钮事件
* @param [in]
* @param [out]
* @return
* @note
*/
- (void)selectButtonLeftPressed:(id)sender
{
    if (popViewCtrl_) 
    {
        [popViewCtrl_ release];
        popViewCtrl_ = nil;
    }
    
    UIButton *button = (UIButton *)sender;
    tag_ = button.tag;
    
    ColorPickerViewController *colorPickerViewControl = [[ColorPickerViewController alloc] init];
    colorPickerViewControl.delegate = self;
    colorPickerViewControl.fromViewControllerID = EDuoToneViewControllerID;
    colorPickerViewControl.view.frame = CGRectMake(0, 0, 300, 300);
    
    int r, g, b;    
    r = [[colorArray_ objectAtIndex:0] intValue];
    g = [[colorArray_ objectAtIndex:1] intValue];
    b = [[colorArray_ objectAtIndex:2] intValue];
    float hue, sat, bri;
    [Common red:r green:g  blue:b toHue:&hue saturation:&sat brightness:&bri];
    [colorPickerViewControl setHue:hue saturation:sat brightness:bri opacity:0.75];
    
    popViewCtrl_ = [[IMPopoverController alloc] initWithContentViewController:colorPickerViewControl];    
    popViewCtrl_.popOverSize = colorPickerViewControl.view.bounds.size;
    [colorPickerViewControl release];
    popViewCtrl_.deletage = self;
    [popViewCtrl_ presentPopoverFromRect:CGRectMake(1.5, 0, 300, 300) inView:self.view animated:YES];
}
/**
 * @brief 
 * 双色调特效右边颜色块按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)selectButtonRightPressed:(id)sender
{
    if (popViewCtrl_) {
        [popViewCtrl_ release];
        popViewCtrl_ = nil;
    }  

    UIButton *button = (UIButton *)sender;
    tag_ = button.tag;
    
    ColorPickerViewController *colorPickerViewControl = [[ColorPickerViewController alloc] init];
    colorPickerViewControl.delegate = self;
    colorPickerViewControl.fromViewControllerID = EDuoToneViewControllerID;
    colorPickerViewControl.view.frame = CGRectMake(0, 0, 300, 300);  
    
    int r, g, b;    
    r = [[colorArray_ objectAtIndex:3] intValue];
    g = [[colorArray_ objectAtIndex:4] intValue];
    b = [[colorArray_ objectAtIndex:5] intValue];
    float hue, sat, bri;
    [Common red:r green:g  blue:b toHue:&hue saturation:&sat brightness:&bri];
    [colorPickerViewControl setHue:hue saturation:sat brightness:bri opacity:0.75];
    
    popViewCtrl_ = [[IMPopoverController alloc] initWithContentViewController:colorPickerViewControl];    
    popViewCtrl_.popOverSize = colorPickerViewControl.view.bounds.size;
    [colorPickerViewControl release];
    popViewCtrl_.deletage = self;
    [popViewCtrl_ presentPopoverFromRect:CGRectMake(1.5, 0, 300, 300) inView:self.view animated:YES];
}



/**
 * @brief 
 * 特效
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)makeEffect
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    ImageInfo *imageInfo = [ImageInfo UIImageToImageInfo:self.srcImage];
	UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kZoomViewTag];
    switch (effectType_)
    {
        case EEffectTints:
        {
            [ColorEffectsCommon colorImage:imageInfo level:0];
            break;
        } 
        //Lomo
        case EEffectLomoId:
        {
            [UIImage lomoEffectAtImage:imageInfo withBrightRadius:1.0 needBalanceColor:YES];
            break;
        }
        //HDR渲染
        case EEffectHDRId:
        {
            float value = (effectSlider_.slider.value - effectSlider_.slider.minimumValue)/(effectSlider_.slider.maximumValue - effectSlider_.slider.minimumValue);
            //用0.95使效果与曝光度区别
            [UIImage HDREffectAtImage:imageInfo withGamma:(value + 0.95)/2];
            break;
        }
        //底片
        case EEffectInvertId:
        {
            [UIImage invertEffectAtImage:imageInfo];
            break;
        }

        //老照片
        case EEffectOldPhotoId:
        {
            [UIImage oldPhotoEffectAtImage:imageInfo withRatio:1 needGrayScale:YES];
            break;
        }
        //灰白
        case EEffectGrayScaleId:
        {
            [EffectMethods grayScaleWithImageInfo:imageInfo];
            [EffectMethods adjustLevelsWithInImage:imageInfo withBlackLimit:0 withWhiteLimit:255 withGamma:2.2 withChanel:EChanelRGB];
            break;
        }
        //黑白
        case EEffectBlackWhiteId:
        {
            [UIImage blackWhite:imageInfo withLevels:100];
            break;
        }
        //黄昏
        case EEffectRedScaleId:
        {
            [ColorEffectsCommon redScale:imageInfo level:100];
            break;
        }

        //素描
        case EEffectSketchId:
        {
            [UIImage sketchEffectAtImage:imageInfo withOpacity:1.0 needGrayScale:YES];
            break;
        }
        case EEffectSpotlightId:
        {
			ConcentricCircle circle = viewClip_.circle;
			[EffectMethods concentricCircleClip:imageInfo circle:&circle];
            break;
        }
        //电流色
        case EEffectHeatMap:
        {
            [UIImage heatMap: imageInfo];
            break;
        }
        //双色调
        case EEffectDuoTone:
        {
            [EffectMethods grayScaleWithImageInfo:imageInfo];
            [UIImage duoTone:imageInfo withColor:colorArray_ withLevel:28];
            break;
        }
          
        //彩虹
        case EEffectRainbowId:
        {
            rainbowMaskView_.alpha = 0.7f;
            break;
        }
        //水彩画
        case EEffectPaintingId:
        {
            [UIImage posterize:imageInfo withLevels:2];
            break;
        }
        // 柔和
        case EEffectSoftLight:
        {
            [UIImage softlightAtImage:imageInfo withOpacity:1.0f];
            break;
        }
        //移轴
        case EEffectTiltShiftId:
        {
            [rectangleView_ effect];
            break;
        }
        //反转片
        case EEffectReverseFilm:
        {
            [UIImage reversalFilmAtImage:imageInfo withOpacity:1.0f];
            break;
        }
        // 霓虹灯
        case EEffectNeon:
        {
            [UIImage neonAtImage:imageInfo hue:0.0 saturation:1.0 bright:191.25 withOpacity:1.0f];
//            [UIImage neonAtImage:imageInfo red:255 green:0 blue:0 withOpacity:1.0f];
            break;
        }
        default:
            break;
    }
    
    if (EEffectRainbowId != effectType_ && EEffectTiltShiftId != effectType_)
    {
        imageView.image = [ImageInfo ImageInfoToUIImage:imageInfo];
    }
    
	[self sliderTouchUp];
	//特效结束，移除activityindicatorview
	[self removeActivityIndicatorView];
    [pool release];
    
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
    if (effectType_ != EEffectSpotlightId)
	{
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
	}
    [pool release];
}
#pragma mark-
#pragma mark CustomSlider Delegate Method

//touchUpInside
- (void)sliderTouchUp
{
    //todo部分特效需要添加判断，是否是原图，如果是原图，则不需要做下面的操作
    if (!(effectType_ == EEffectRainbowId && [effectSlider_.labelValue.text isEqualToString:@"0%"]))
    {
        [[ReUnManager sharedReUnManager] storeSnap:[self getCurrentImage]];
    }
    
}
- (void)sliderValueChanged:(float)value
{
	[self removeActivityIndicatorView];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kZoomViewTag];
	if (effectType_ == EEffectSpotlightId) 
	{
		ConcentricCircle circle = viewClip_.circle;
		circle.maxRadius = circle.minRadius + value;
		viewClip_.circle = circle;
		
		ImageInfo *imageInfo = [ImageInfo UIImageToImageInfo:self.srcImage];
        [EffectMethods concentricCircleClip:imageInfo circle:&circle];
		UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
		
		imageView.image = afterImg;
	}
    else
    {
        [self performSelectorInBackground:@selector(addActivityIndicatorView) withObject:nil];
        if (effectType_ == EEffectLomoId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage lomoEffectAtImage:imageInfo withBrightRadius:(value + 100)/200.0 needBalanceColor:NO];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if(effectType_ == EEffectHDRId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            float value = (effectSlider_.slider.value - effectSlider_.slider.minimumValue)/(effectSlider_.slider.maximumValue - effectSlider_.slider.minimumValue);
            [UIImage HDREffectAtImage:imageInfo withGamma:(value + 1)/2.0];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if (effectType_ == EEffectOldPhotoId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage oldPhotoEffectAtImage:imageInfo withRatio:(value + 300)/400.0 needGrayScale:NO];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if (effectType_ == EEffectGrayScaleId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [EffectMethods adjustLevelsWithInImage:imageInfo withBlackLimit:0 withWhiteLimit:255 withGamma:(0.6 * value + 160)/100 withChanel:EChanelRGB];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if(effectType_ == EEffectBlackWhiteId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage blackWhite:imageInfo withLevels:value];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if(effectType_ == EEffectRedScaleId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [ColorEffectsCommon redScale:imageInfo level:value];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }

        else if (effectType_ == EEffectSketchId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage sketchEffectAtImage:imageInfo withOpacity:(value + 100)/200.0 needGrayScale:NO];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];            
        }
        else if(effectType_ == EEffectDuoTone)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage duoTone:imageInfo withColor:colorArray_ withLevel:(128 - value)];  
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];         
        }
        else if(effectType_ == EEffectRainbowId)
        {
            rainbowMaskView_.alpha = 0.7 *value/(effectSlider_.slider.maximumValue - effectSlider_.slider.minimumValue);
        }
        else if(effectType_ == EEffectPaintingId)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage posterize:imageInfo withLevels:roundf(value)];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if (effectType_ == EEffectSoftLight)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage softlightAtImage:imageInfo withOpacity:(value + 100)/200.0];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if (effectType_ == EEffectReverseFilm)
        {
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage reversalFilmAtImage:imageInfo withOpacity:(value + 100)/200.0];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }
        else if (effectType_ == EEffectNeon)
        {
            opacity_ = (value + 100)/200.0;
            NSLog(@"%f,%f,%f,%f", hue_, saturation_, bright_, opacity_);
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
//            [UIImage neonAtImage:imageInfo red:self.red green:self.green blue:self.blue withOpacity:opacity_];
            [UIImage neonAtImage:imageInfo hue:hue_ saturation:saturation_ bright:bright_ withOpacity:opacity_];
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            imageView.image = afterImg;
            [imageInfo release];
        }

        //0.01会导致：进特效界面调节滑块，转圈不会消失，所以不能用0.01
        [self performSelector:@selector(removeActivityIndicatorView) withObject:nil afterDelay:0.05];
    }
}

/**
 * @brief 
 * clone srcImg 图片信息，并添加相应特效的一部分操作
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)cloneImgInfo
{
    switch (effectType_) 
    {
        case EEffectLomoId:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            [EffectMethods balanceColorWithInImage:cloneImgInfo_ 
                                          withCyan:-80
                                       withMagenta:0 
                                        withYellow:-60 
                                  withTransferMode:ETransferMidtones
                            withPreserveLuminosity:true];
            break;
            
        }
        case EEffectHDRId:
        case EEffectPaintingId:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            break;
        }
        case EEffectOldPhotoId:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            [EffectMethods grayScaleWithImageInfo:cloneImgInfo_];
            break;
        }
        case EEffectGrayScaleId:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            [EffectMethods grayScaleWithImageInfo:cloneImgInfo_];
            break;
        }
        case EEffectBlackWhiteId:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            break;
        }
        case EEffectRedScaleId:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            break;
        }

        case EEffectSketchId:
        case EEffectDuoTone:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            [EffectMethods grayScaleWithImageInfo:cloneImgInfo_];
            break;
        }
        case EEffectSoftLight:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            break;
        }
        case EEffectReverseFilm:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            break;
        }
        case EEffectNeon:
        {
            cloneImgInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] retain];
            break;
        }
        default:
            break;
    }
}

- (void)doPanAdditional:(CGPoint)ptTranslation
{
	CGRect rect = viewClip_.frame;
	CGPoint ptOrigin = rect.origin;
	ptOrigin.x += ptTranslation.x;
	ptOrigin.y += ptTranslation.y;
	
	viewClip_.frame = CGRectMake(ptOrigin.x, ptOrigin.y, rect.size.width, rect.size.height);
	
	ConcentricCircle circle =  viewClip_.circle;
	circle.xView += ptTranslation.x;
	circle.yView += ptTranslation.y;
	viewClip_.circle = circle;
	
}
#pragma mark
#pragma mark ColorPickerViewController Delegate Method
- (void)closeViewAndSetColorHue:(float)hue saturation:(float)sat brightness:(float)bri opacity:(float)opa
{
    [popViewCtrl_ dismissPopoverAnimated:YES];
//    NSLog(@"%f,%f,%f,%f", hue, sat, bri, opa);
    UIButton *selectButton = nil;
    UIButton *selectLeftButton = nil;
    UIButton *selectRightButton = nil;
    UIButton *leftButton = nil;
    UIButton *rightButton = nil;
    
    
    if ( effectType_ == EEffectNeon )
    {
        selectButton = (UIButton *)[self.navigationItem.titleView viewWithTag:4741];
        [selectButton setBackgroundColor:[UIColor colorWithHue:hue/360.0 saturation:sat brightness:bri/255.0 alpha:opa]];        
        // 保存色调，饱和度和明亮度
        NSLog(@"%f", opacity_);
        hue_ = hue;
        saturation_ = sat;
        bright_ = bri;
        [self sliderValueChanged:(opacity_*200-100)];
    }
    if (effectType_ == EEffectDuoTone)
    {        
        leftButton = (UIButton *)[self.navigationItem.titleView viewWithTag:4820];
        rightButton = (UIButton *)[self.navigationItem.titleView viewWithTag:4821];
        selectLeftButton = (UIButton *)[self.navigationItem.titleView viewWithTag:4822];
        selectRightButton = (UIButton *)[self.navigationItem.titleView viewWithTag:4823];
        unsigned char red, green, blue;            
        [Common hue:hue saturation:sat brightness:bri toRed:&red green:&green blue:&blue];
        int r, g, b;
        r = red;
        g = green;
        b = blue;
        
        if (tag_ == leftButton.tag) 
        {
            [selectLeftButton setBackgroundColor:[UIColor colorWithHue:hue/360.0 saturation:sat brightness:bri/255.0 alpha:0.75]];            
            NSNumber *number0 = [NSNumber numberWithInt:r];
            NSNumber *number1 = [NSNumber numberWithInt:g];
            NSNumber *number2 = [NSNumber numberWithInt:b];            
            [colorArray_ replaceObjectAtIndex:0 withObject:number0 ];
            [colorArray_ replaceObjectAtIndex:1 withObject:number1 ];
            [colorArray_ replaceObjectAtIndex:2 withObject:number2 ]; 
            
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage duoTone:imageInfo withColor:colorArray_ withLevel:(128 - effectSlider_.slider.value)];  
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
            imageView.image = afterImg;
            [imageInfo release];
        }
        if (tag_ == rightButton.tag) 
        {
            [selectRightButton setBackgroundColor:[UIColor colorWithHue:hue/360.0 saturation:sat brightness:bri/255.0 alpha:0.75]];           
            NSNumber *number3 = [NSNumber numberWithInt:r];
            NSNumber *number4 = [NSNumber numberWithInt:g];
            NSNumber *number5 = [NSNumber numberWithInt:b];            
            [colorArray_ replaceObjectAtIndex:3 withObject:number3 ];
            [colorArray_ replaceObjectAtIndex:4 withObject:number4 ];
            [colorArray_ replaceObjectAtIndex:5 withObject:number5 ]; 
            
            ImageInfo *imageInfo = [cloneImgInfo_ clone];
            [UIImage duoTone:imageInfo withColor:colorArray_ withLevel:(128 - effectSlider_.slider.value)];  
            UIImage *afterImg = [ImageInfo ImageInfoToUIImage:imageInfo];
            UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
            imageView.image = afterImg;
            [imageInfo release];
        }   
                          
    }
    
}

#pragma mark - 
#pragma mark IMPopoverDelegate Delegate Method
- (void)dismissPopView
{
    
}

/**
 * @brief 
 * 获取当前图片：彩虹等特效是两个imageview合成的，所以必须用此方法
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIImage *)getCurrentImage
{
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    UIImage *finalImage = imageView.image;
    UIView *view = nil;
    //如果特效由两个view组成，且上面的view是加在imageview上的，就走if，
    if (effectType_ == EEffectRainbowId )
    {
        view = imageView;
    }
    //移轴是在一个view上面添加的imageview，然后再在view上添加移轴特效的view
    else if(effectType_ == EEffectTiltShiftId)
    {
        view = [imageScrollVC_.view viewWithTag:1002];
        [rectangleView_ hidenLayer:YES];
    }
    if (effectType_ == EEffectRainbowId || effectType_ == EEffectTiltShiftId )
    {
        UIImage *currentImage = nil;
        UIImage *image = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
        
        if (image.size.width<=150 && image.size.height<=150)
        {
            UIGraphicsBeginImageContext(view.bounds.size);
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, image.size.width/view.bounds.size.width) ;
        }
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        currentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        finalImage = currentImage;
    }
    return finalImage;
}
@end
