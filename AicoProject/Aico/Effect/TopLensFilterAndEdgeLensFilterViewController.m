//
//  TopLensFilterAndEdgeLensFilterViewController.m
//  Aico
//
//  Created by cienet on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopLensFilterAndEdgeLensFilterViewController.h"
#import "ReUnManager.h"
#import "ColorSelectorView.h"
#import "MainViewController.h"
#import "TopLensFilterAndEdgeLensFilterProcess.h"
#import "ImageScrollViewController.h"

#define kImageViewWidth             300.0
#define kImageViewHeight            375.0
#define kHeight                     54.0
#define kWidth                      10.0

@implementation TopLensFilterAndEdgeLensFilterViewController
@synthesize sourcePicture = sourcePicture_;
@synthesize currentImageView = currentImageView_;
@synthesize isFromTopLensFilter = isFromTopLensFilter_;
@synthesize activityIndicatorView = activityIndicatorView_;

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
    
    filterProcess_ = [[TopLensFilterAndEdgeLensFilterProcess alloc]init];
    
    //添加导航栏
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationController.navigationBarHidden = NO;
    
    //添加导航栏上取消按钮
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
    
    //添加导航栏上确定按钮
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
    
    //获取源图片，并且让它适应显示在屏幕上
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
	[self.view insertSubview:imageScrollVC_.view atIndex:1];
    
    currentImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    
    //暂时留着，可能不需要
    self.sourcePicture = [filterProcess_ initializeOriginalPicture:self.sourcePicture];
    
    self.currentImageView.image = self.sourcePicture;
    [self.currentImageView setUserInteractionEnabled:YES];
    [imageView addSubview:currentImageView_];

    if (isFromTopLensFilter_)
    {
        hue_ = 0;
        brightness_ = 255.*.75;
        self.navigationItem.title = @"最高滤镜";
    }
    else {
        hue_ = 240.0;
        brightness_ = 255.*.75;
        self.navigationItem.title = @"锐化滤镜";
    }
    opacity_ = 1;
    
    //添加滑块
    effectSlider_ = [[CustomSlider alloc] initWithTarget:self
                                                   frame:kSliderRect 
                                       showBkgroundImage:YES];
    effectSlider_.slider.minimumValue = 0;
    effectSlider_.slider.maximumValue = 1;
    effectSlider_.minimumShowPercentValue = 0;
    effectSlider_.maximumShowPercentValue = 100;
    effectSlider_.slider.value = 1;
    effectSlider_.step = 0.01f;
    effectSlider_.slider.continuous = YES;
    effectSlider_.isShowProgress = YES;
    [self.view addSubview:effectSlider_];
        
    //title view
    UIButton *selectButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 12, 20, 20)];
    [selectButton.layer setMasksToBounds:YES];
    [selectButton.layer setCornerRadius:2];
    [selectButton addTarget:self 
                     action:@selector(selectButtonPressed:) 
           forControlEvents:UIControlEventTouchUpInside];
    [selectButton setBackgroundColor:[UIColor colorWithHue:hue_/360.0 
                                                saturation:1.0 
                                                brightness:brightness_/255.0 
                                                     alpha:opacity_]];
    selectButton.tag = 4741;
    
    //原来按钮太小,点击不便
    UIButton *tapButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [tapButton setBackgroundColor:[UIColor clearColor]];
    [tapButton addTarget:self 
                  action:@selector(selectButtonPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *buttonBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 12, 20, 20)];
//    buttonBackgroundImageView.image = [UIImage imageNamed:@"filmButtonClick.png"];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 44)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    if (isFromTopLensFilter_)
    {
        titleLabel.text = @"上滤镜";
        selectButton.frame = CGRectMake(20, 12, 20, 20);
        buttonBackgroundImageView.frame = selectButton.frame;
    }
    else {
        titleLabel.text = @"边框滤镜";
        selectButton.frame = CGRectMake(10, 12, 20, 20);
        buttonBackgroundImageView.frame = selectButton.frame;
    }
    [titleView addSubview:buttonBackgroundImageView];
    [titleView addSubview:titleLabel];
    [titleView addSubview:selectButton];
    [titleView addSubview:tapButton];
    self.navigationItem.titleView = titleView;
    
    [buttonBackgroundImageView release];
    [tapButton release];
    [selectButton release];
    [titleLabel release];
    [titleView release];
    
    [self addActivityIndicatorView];
    [self performSelectorInBackground:@selector(makeEffect) withObject:nil];
}

- (void)dealloc
{
    self.sourcePicture = nil;
    self.currentImageView = nil;
    RELEASE_OBJECT(filterProcess_);
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
    RELEASE_OBJECT(popoverViewCntroller_);
    self.activityIndicatorView = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    self.sourcePicture = nil;
    self.currentImageView = nil;
    RELEASE_OBJECT(filterProcess_);
    RELEASE_OBJECT(effectSlider_);
    RELEASE_OBJECT(imageScrollVC_);
    self.activityIndicatorView = nil;
    [super viewDidUnload];
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

#pragma mark
#pragma mark

/**
 * @brief 
 * 不保存返回
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (IBAction)cancelOperation
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
 * 保存图片，返回main页面
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (IBAction)confirmOperation
{
    effectSlider_.isCurrentValueViewOnLastWindow = YES;
    [effectSlider_ removePopover];
    
    [[ReUnManager sharedReUnManager] storeImage:currentImageView_.image];
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] 
                                          animated:YES];
}

/**
 * @brief 
 * 点击改变颜色
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)selectButtonPressed:(id)sender
{
    chooseColorButtonPressed_ = YES;
    //点击该按钮，会添加一个窗口，effectslider上的currentvalueview将不在最上层的uiwindow上，而是在次一层
    effectSlider_.isCurrentValueViewOnLastWindow = NO;
    if (popoverViewCntroller_)
    {
        [popoverViewCntroller_ release],popoverViewCntroller_ = nil;
    }
    
    ColorPickerViewController *cpvc = [[ColorPickerViewController alloc]init];
    if (isFromTopLensFilter_)
    {
        cpvc.fromViewControllerID = ETopLensFilterViewControllerID;
    }
    else {
        cpvc.fromViewControllerID = EEdgeLensFilterViewControllerID;
    }
    cpvc.delegate = self;
    cpvc.view.frame = CGRectMake(0, 0, 317, 233);
    [cpvc setHue:hue_ saturation:1.0 brightness:brightness_ opacity:opacity_];
	popoverViewCntroller_ = [[IMPopoverController alloc] initWithContentViewController:cpvc];
    popoverViewCntroller_.deletage = self;
	popoverViewCntroller_.popOverSize = cpvc.view.bounds.size;
    [cpvc release];
//    [UIView transitionWithView:popoverViewCntroller_.popOverWindow
//                      duration:0.3 
//                       options:UIViewAnimationOptionTransitionFlipFromTop 
//                    animations:^{
//                        [popoverViewCntroller_ presentPopoverFromRect:CGRectMake(1.5, 50, 317, 233) 
//                                                               inView:self.view
//                                                             animated:YES];}
//                    completion:NULL
//     ];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [popoverViewCntroller_.popOverWindow.layer addAnimation:transition forKey:@"Transition"];
	[popoverViewCntroller_ presentPopoverFromRect:CGRectMake(1.5, 50, 317, 233) inView:self.view animated:YES];
}

/**
 * @brief 
 * 产生特效
 * @param [in] 
 * @param [out] 
 * @return 
 * @note
 */
- (void)makeEffect
{
    currentImageView_.image = self.sourcePicture;
    heightRatio_ = 1.0;
    unsigned char r1,g1,b1;
    [Common hue:hue_ saturation:1 brightness:brightness_ toRed:&r1 green:&g1 blue:&b1];
    if (r1 == 0 && g1 == 0 && b1 == 0)
    {
        r1 = 1;
        b1 = 0;
        g1 = 0;
    }
    if (isFromTopLensFilter_)
    {
        currentImageView_.image = [filterProcess_ topLensFilter:currentImageView_.image red:r1 green:g1 blue:b1 opacity:opacity_ heightRatio:1.0];
    }
    else
    {
        currentImageView_.image = [filterProcess_ edgeLensFilter:currentImageView_.image red:r1 green:g1 blue:b1 opacity:opacity_ heightRatio:1.0/2.5];
    }
    UIImage *currentImage = nil;
    UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
    [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    currentImage = UIGraphicsGetImageFromCurrentImageContext();	
    UIGraphicsEndImageContext();
    [[ReUnManager sharedReUnManager] storeSnap:currentImage];
    
    [self removeActivityIndicatorView];
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

#pragma mark - 
#pragma mark CustomSlider Delegate Method
/**
 * @brief 
 * 拖动滑块，改变滤镜效果
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)sliderValueChanged:(float)value
{
    [self removeActivityIndicatorView];
    
    if (fabsf(value) < 0.000001)
    {
        currentImageView_.image = self.sourcePicture;
        heightRatio_ = value;
        return;
    }
    [self performSelectorInBackground:@selector(addActivityIndicatorView)
                           withObject:nil];
    currentImageView_.image = self.sourcePicture;
    heightRatio_ = value;
    unsigned char r1,g1,b1;
    [Common hue:hue_ saturation:1 brightness:brightness_ toRed:&r1 green:&g1 blue:&b1];
    
    if (r1 == 0 && g1 == 0 && b1 == 0)
    {
        r1 = 1;
        b1 = 0;
        g1 = 0;
    }
    if (isFromTopLensFilter_)
    {
        currentImageView_.image = [filterProcess_ topLensFilter:currentImageView_.image red:r1 green:g1 blue:b1 opacity:opacity_ heightRatio:value];
    }
    else {
        currentImageView_.image = [filterProcess_ edgeLensFilter:currentImageView_.image red:r1 green:g1 blue:b1 opacity:opacity_ heightRatio:value/2.5];
    }
    
    UIImage *currentImage = nil;
    UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
    [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    currentImage = UIGraphicsGetImageFromCurrentImageContext();	
    UIGraphicsEndImageContext();
    [[ReUnManager sharedReUnManager] storeSnap:currentImage];
    
    //0.01会导致：进特效界面调节滑块，转圈不会消失，所以不能用0.01
    [self performSelector:@selector(removeActivityIndicatorView) withObject:nil afterDelay:0.05];
}

#pragma mark - 
#pragma mark ColorSelectorDelegate Delegate Method
/**
 * @brief 
 * 关闭颜色选择页面，设置选择的颜色
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)closeViewAndSetColorHue:(float)hue 
                     saturation:(float)sat 
                     brightness:(float)bri
                        opacity:(float)opa
{
    [popoverViewCntroller_ dismissPopoverAnimated:YES];
    hue_ = hue;
    brightness_ = bri;
    opacity_ = opa;
    UIButton *selectButton = (UIButton *)[self.navigationItem.titleView viewWithTag:4741];
    
    [selectButton setBackgroundColor:[UIColor colorWithHue:hue_/360.0 saturation:1.0 brightness:brightness_/255.0 alpha:opacity_]];
    
    [self sliderValueChanged:heightRatio_];
}
@end
