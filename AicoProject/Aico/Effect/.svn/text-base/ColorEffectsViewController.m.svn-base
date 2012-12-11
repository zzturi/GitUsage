//
//  ColorEffectsViewController.m
//  Aico
//
//  Created by zhou yong on 3/29/12.
//  Copyright 2012 cienet. All rights reserved.
//

//#define NSLog NSLog

//#define DEBUG_BORDER
#ifdef DEBUG_BORDER
#	include <QuartzCore/QuartzCore.h>
#endif

#import "ColorEffectsViewController.h"
#import "Common.h"
#import "ImageInfo.h"
#import "ColorEffectsCommon.h"
#import "EffectMethods.h"
#import "ReUnManager.h"
#import "ImageScrollViewController.h"

#ifdef DEBUG_BORDER
#	define SHOW_BORDER(view, color) view.layer.borderColor = color; view.layer.borderWidth = 1
#else
#	define SHOW_BORDER(view, color) 
#endif

#define NEW_BUTTON_ITEM(image,selector) \
	[[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:selector] autorelease]

#define INIT_LABEL(label, txt)						\
	label = [[UILabel alloc] initWithFrame:CGRectMake(kColorEffectsLabelPaddinggX, y, kColorEffectsLabelWidth, kColorEffectsLabelHeight)]; \
	label.backgroundColor = [UIColor clearColor];	\
	label.text = txt;								\
	label.adjustsFontSizeToFitWidth = YES;			\
	label.textColor = [UIColor lightGrayColor];		\
	label.textAlignment = UITextAlignmentCenter
  
#define BEGIN_DISPATCH_ASYNC(key, value) \
	dispatch_queue_t value = dispatch_queue_create(key, NULL); \
	dispatch_async \
	(value, ^(void) \
		{
#define END_DISPATCH_ASYNC(value) \
		} \
	); \
	dispatch_release(value)
 

#define kColorEffectsNavBarHeight		44.0f
#define kColorEffectsOffset				20.0f
#define kColorEffectsSliderHeight		40.0f
#define kColorEffectsLabelPaddinggX     5.0f
#define kColorEffectsLabelWidth         30.0f
#define kColorEffectsLabelHeight        15.0f

#define kSliderRedTag                   8000
#define kSliderGreenTag                 8001
#define kSliderBlueTag                  8002

#define kActivityIndicatorViewTag       9001
@interface ColorEffectsViewController(Private)

- (void)addActivityIndicatorView;
- (void)removeActivityIndicatorView;

@end

@implementation ColorEffectsViewController

@synthesize vcImage                 = vcImage_;
@synthesize imageViewSlider         = imageViewSlider_;
@synthesize slider                  = slider_;
@synthesize effectType              = effectType_;
@synthesize strEffectType           = strEffectType_;
@synthesize activityIndicatorView   = activityIndicatorView_;

#pragma mark -
#pragma mark CustomSliderDelegate Methods

- (void)sliderValueChanged:(float)value
{
	ImageInfo *info = [imageInfo_ clone];
	
//	BEGIN_DISPATCH_ASYNC("effect_queue", queue);
	switch (effectType_)
	{
		case EEffectBrightness:
			[ColorEffectsCommon brightness:info level:value];
			break;
		case EEffectContrast:
			[ColorEffectsCommon contrast:info level:value];
			break;
		case EEffectSaturation:
			[ColorEffectsCommon saturation:info level:value];
			break;		
		case EEffectExposure:
			[ColorEffectsCommon exposure:info blackThreshold:0 whiteThreshold:value gamma:1];
			break;
        case EEffectAdjustRGB:			
            [ColorEffectsCommon adjustImage:info 
                                    withRed:labelRedValue_.text.intValue 
                                      green:labelGreenValue_.text.intValue 
                                       blue:labelBlueValue_.text.intValue];
            break;
        case EEffectTemperature:
            [ColorEffectsCommon temperature:info level:value];
            break;
        case EEffectTints:
            [ColorEffectsCommon colorImage:info level:value];
            break;
        case EEffectTone:
            [ColorEffectsCommon toneImage:info level:value];
            break;
		case EEffectSharpen:
            [self removeActivityIndicatorView];
            [self performSelectorInBackground:@selector(addActivityIndicatorView) withObject:nil];
            [ColorEffectsCommon sharpenImage:info imageEdge:imageEdge level:value];
            [self performSelector:@selector(removeActivityIndicatorView) withObject:nil afterDelay:0.05];
			break;
		case EEffectSmooth:
            [self removeActivityIndicatorView];
            [self performSelectorInBackground:@selector(addActivityIndicatorView) withObject:nil];
			[ColorEffectsCommon smoothImage:info level:value];
            [self performSelector:@selector(removeActivityIndicatorView) withObject:nil afterDelay:0.05];
			break;
		case EEffectBlur:
			[ColorEffectsCommon fastBlurImage:info radius:value];
			break;
		default:
			break;
	}
	
	UIImage *image = [ImageInfo ImageInfoToUIImage:info];
	[self setImage:image];
	
	[info release];
//	END_DISPATCH_ASYNC(queue);
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
	if ((effectType_ != EEffectAdjustRGB && ![slider_.labelValue.text isEqualToString:@"0%"]) || (effectType_ == EEffectAdjustRGB && (![labelRedValue_.text isEqualToString:@"0"] || ![labelGreenValue_.text isEqualToString:@"0"] || ![labelBlueValue_.text isEqualToString:@"0"])))
	{
		UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kZoomViewTag];
		[[ReUnManager sharedReUnManager] storeSnap:imageView.image];
	}
}

#pragma mark -
#pragma mark View Life

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self initButtons];
	
	UIImage *srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
	imageInfo_ = [[ImageInfo UIImageToImageInfo:srcImage] retain];
	[self setImage:srcImage];
	
	CGFloat y = self.view.frame.size.height - kColorEffectsSliderHeight;
	// 记录滑块开始的位置
    CGRect rectSlider;
    if (effectType_ == EEffectAdjustRGB)
    {
        CGFloat paddingX = kColorEffectsLabelPaddinggX*2 + kColorEffectsLabelWidth;
        CGFloat width = self.view.frame.size.width - paddingX;
        rectSlider = CGRectMake(paddingX, y, width, kColorEffectsSliderHeight);
		self.imageViewSlider.image = [UIImage imageNamed:@"sliderViewBack.png"];
		slider_ = [[CustomSlider alloc] initWithTarget:self frame:rectSlider showBkgroundImage:NO];
		slider_.slider.tag = kSliderBlueTag;
        
		[self initLabels];
		
		y -= kColorEffectsSliderHeight;
		sliderGreen_ = [[CustomSlider alloc] initWithTarget:self frame:CGRectMake(rectSlider.origin.x, y, rectSlider.size.width, kColorEffectsSliderHeight) showBkgroundImage:NO];
        sliderGreen_.slider.tag = kSliderGreenTag;
		
		y -= kColorEffectsSliderHeight;
		sliderRed_ = [[CustomSlider alloc] initWithTarget:self frame:CGRectMake(rectSlider.origin.x, y, rectSlider.size.width, kColorEffectsSliderHeight)  showBkgroundImage:NO];
        sliderRed_.slider.tag = kSliderRedTag;
    }
    else
	{
		rectSlider = CGRectMake(0, y, self.view.frame.size.width, kColorEffectsSliderHeight);
		self.imageViewSlider.frame = rectSlider;
		slider_ = [[CustomSlider alloc] initWithTarget:self frame:rectSlider showBkgroundImage:YES];
	}
	
	// 重新调整vcimage的位置
	vcImage_ = [[ImageScrollViewController alloc] init];
    vcImage_.effectType = effectType_;
	vcImage_.view.frame = CGRectMake(0, 0, self.view.frame.size.width, y);
	[Common imageView:[self getImageView] autoFitView:vcImage_.view margin:CGPointMake(10, 10)];
	[self.view addSubview:vcImage_.view];
	[self.view sendSubviewToBack:vcImage_.view];
	
	SHOW_BORDER([self getImageView], [UIColor blueColor].CGColor);
	SHOW_BORDER(self.vcImage.view, [UIColor redColor].CGColor);
	
	// 设置slider的背景图片
	self.imageViewSlider.frame = CGRectMake(0, y, self.view.frame.size.width, kColorEffectsSliderHeight*3);
	
	CGFloat minValue = 0, maxValue = 0, step = 0.01f, value = 0.0f;
	switch (effectType_)
	{
		case EEffectBrightness:
		case EEffectContrast:
			minValue = -0.7f;
			maxValue = 0.7f;
			step = (maxValue - minValue) / 200;
			break;
		case EEffectSaturation:
			minValue = 0.0f;
			maxValue = 2.0f;
			value = 1.0f;
			break;
		case EEffectExposure:
			minValue = 155.0f;
			maxValue = 355.0f;
            step = 1.0f;
			value = 255.0f;
			break;
		case EEffectAdjustRGB:
            minValue = -100.0f;
            maxValue = 100.0f;
            step = 1.0f;
            slider_.isShowProgress = NO;
			
			sliderRed_.slider.minimumValue = minValue;
			sliderRed_.slider.maximumValue = maxValue;
			sliderRed_.slider.value = value;
			sliderRed_.step = step;
			sliderRed_.isShowProgress = NO;
			
			sliderGreen_.slider.minimumValue = minValue;
			sliderGreen_.slider.maximumValue = maxValue;
			sliderGreen_.slider.value = value;
			sliderGreen_.step = step;
			sliderGreen_.isShowProgress = NO;
			
			[self.view addSubview:sliderRed_];
			[self.view addSubview:sliderGreen_];
			
			break;
            
        case EEffectTints:
            minValue = 0.0f;
			maxValue = 250.0f;
			value = 0.0f;
			step = 2.5f;
            slider_.minimumShowPercentValue = 0.0f;
            slider_.maximumShowPercentValue = 100.0f;
            ImageInfo *imageClone = [imageInfo_ clone];
            [ColorEffectsCommon colorImage:imageClone level:0.0];
            
            UIImage *image = [ImageInfo ImageInfoToUIImage:imageClone];
            [self setImage:image];
            
            [imageClone release];
            break;
            
        case EEffectTemperature:
            minValue = -100.0f;
			maxValue = 100.0f;
			value = 0.0f;
			step = 1.0f;
            break;
            
        case EEffectTone:
            minValue = -50.0f;
            maxValue = 50.0f;
            value = 0.0f;
            step = 0.5f;
            slider_.minimumShowPercentValue = -100.0f;
            slider_.maximumShowPercentValue = 100.0f;
            break;
            
		case EEffectSharpen:
			minValue = 0.0f;
            maxValue = 0.9f;
            value = 0.9f;
            step = 0.009f;
            slider_.minimumShowPercentValue = 0.0f;
            slider_.maximumShowPercentValue = 100.0f;
            
            imageEdge = [imageInfo_ clone];
            [ColorEffectsCommon edgeDetect:imageEdge];
            
            ImageInfo *imageSharpenClone = [imageInfo_ clone];
            [ColorEffectsCommon sharpenImage:imageSharpenClone imageEdge:imageEdge level:1.2];
            UIImage *imageSharpen = [ImageInfo ImageInfoToUIImage:imageSharpenClone];
            [self setImage:imageSharpen];
            [imageSharpenClone release];
            
            break;
			
		case EEffectSmooth:
            minValue = 0.0f;
			maxValue = 5.0;
			value = 0.0f;
			step = 0.05f;
			slider_.minimumShowPercentValue = 0.0f;
            slider_.maximumShowPercentValue = 100.0f;
			break;
            
		case EEffectBlur:
			minValue = 0.0f;
			maxValue = 10.0f;
			value = 0.0f;
			step = 0.1f;
			slider_.minimumShowPercentValue = 0.0f;
            slider_.maximumShowPercentValue = 100.0f;
			break;
			
		default:
			break;
	}
	
	slider_.slider.minimumValue = minValue;
	slider_.slider.maximumValue = maxValue;
	slider_.slider.value = value;
	slider_.step = step;
	
	[self.view addSubview:slider_];
	
    self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = strEffectType_;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]];
	[Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
}		

/**
 * @brief 当特效是RGB调节时，需要初始化显示RGB信息的标签 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initLabels
{
	CGFloat y = self.view.frame.size.height;
	CGFloat padding = (kColorEffectsSliderHeight - kColorEffectsLabelHeight*2) / 2.0f;
	
	y -= kColorEffectsLabelHeight + padding;
	INIT_LABEL(labelBlueValue_, @"0");
	y -= kColorEffectsLabelHeight;
	INIT_LABEL(labelBlueTag_, @"蓝");
	
	y -= kColorEffectsLabelHeight + padding*2;
	INIT_LABEL(labelGreenValue_, @"0");
	y -= kColorEffectsLabelHeight;
	INIT_LABEL(labelGreenTag_, @"绿");
	
	y -= kColorEffectsLabelHeight + padding*2;
	INIT_LABEL(labelRedValue_, @"0");
	y -= kColorEffectsLabelHeight;
	INIT_LABEL(labelRedTag_, @"红");
	
	[self.view addSubview:labelRedTag_];
	[self.view addSubview:labelRedValue_];
	[self.view addSubview:labelGreenTag_];
	[self.view addSubview:labelGreenValue_];
	[self.view addSubview:labelBlueTag_];
	[self.view addSubview:labelBlueValue_];
}

/**
 * @brief 初始化导航栏上的功能按钮 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initButtons
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
	
	UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
}

/**
 * @brief 获取显示图片的imageview 
 *
 * @param [in]
 * @param [out]
 * @return 显示图片的imageview
 * @note 
 */
- (UIImageView *)getImageView
{
	return (UIImageView*)[vcImage_.view viewWithTag:kZoomViewTag];
}

/**
 * @brief 获取scrollview中显示图片的imageview 
 *
 * @param [in] 将要显示的新的图片对象
 * @param [out]
 * @return 
 * @note 
 */
- (void)setImage:(UIImage *)image
{
	UIImageView *imageView = [self getImageView];
	imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
	self.vcImage = nil;
	self.imageViewSlider = nil;
	
	self.slider = nil;
    RELEASE_OBJECT(sliderRed_);
    RELEASE_OBJECT(sliderGreen_);
	
    RELEASE_OBJECT(labelRedTag_);
    RELEASE_OBJECT(labelGreenTag_);
    RELEASE_OBJECT(labelBlueTag_);
	RELEASE_OBJECT(labelRedValue_);
    RELEASE_OBJECT(labelGreenValue_);
    RELEASE_OBJECT(labelBlueValue_);
	
	self.strEffectType = nil;
	RELEASE_OBJECT(imageInfo_);
    RELEASE_OBJECT(imageEdge);
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	RELEASE_OBJECT(vcImage_);
	RELEASE_OBJECT(imageViewSlider_);
	
	RELEASE_OBJECT(slider_);
    RELEASE_OBJECT(sliderRed_);
    RELEASE_OBJECT(sliderGreen_);
	
    RELEASE_OBJECT(labelRedTag_);
    RELEASE_OBJECT(labelGreenTag_);
    RELEASE_OBJECT(labelBlueTag_);
	RELEASE_OBJECT(labelRedValue_);
    RELEASE_OBJECT(labelGreenValue_);
    RELEASE_OBJECT(labelBlueValue_);
	
	RELEASE_OBJECT(strEffectType_);
	RELEASE_OBJECT(imageInfo_);
    RELEASE_OBJECT(imageEdge);
    [super dealloc];
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *imageScrollView = (UIScrollView *)[vcImage_.view viewWithTag:kMainScrollViewTag];
    imageScrollView.delegate = nil;
    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark 导航栏按钮响应函数

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
    [ReUnManager sharedReUnManager].snapImage = nil;
    
	if (effectType_ != EEffectAdjustRGB)
		[slider_ removePopover];
	
    [self.navigationController popViewControllerAnimated:YES];
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
	if (effectType_ != EEffectAdjustRGB)
		[slider_ removePopover];
	
	if (
         (effectType_ != EEffectAdjustRGB && ![slider_.labelValue.text isEqualToString:@"0%"]) || 
         (effectType_ == EEffectAdjustRGB && (
                                               ![labelRedValue_.text isEqualToString:@"0"]   || 
                                               ![labelGreenValue_.text isEqualToString:@"0"] || 
                                               ![labelBlueValue_.text isEqualToString:@"0"]
                                             )
         )
       )
	{
		[[ReUnManager sharedReUnManager] storeImage:[self getImageView].image];
	}
	
	NSArray *vcArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(UIViewController *)[vcArray objectAtIndex:([vcArray count] - 3)] animated:YES];
}

#pragma mark -
#pragma mark 自定义函数
/**
 * @brief 当特效是RGB调节时，实时显示滑块的值
 *
 * @param [in] number: 显示的值
 * @param [in] sender: 移动的滑块对象
 * @param [out] 
 * @return
 * @note 
 */
- (void)customSliderValueChanged:(NSNumber *)number sender:(id)sender
{
    CGFloat newValue = [number floatValue];
    newValue += newValue < 0 ? -0.5f : 0.5f;
    int newValueInt = (int)newValue;
    NSString *format = newValueInt > 0 ? @"+%d" : @"%d";
    
    UISlider *slider = (UISlider*)sender;
    if (slider.tag == kSliderRedTag)
        labelRedValue_.text = [NSString stringWithFormat:format, newValueInt];
    else if (slider.tag == kSliderGreenTag)
        labelGreenValue_.text = [NSString stringWithFormat:format, newValueInt];
    else if (slider.tag == kSliderBlueTag)
        labelBlueValue_.text = [NSString stringWithFormat:format, newValueInt];
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
    UIWindow *lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    for (UIView *view in [lastWindow subviews])
    {
        if (view.tag == kActivityIndicatorViewTag)
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
    activityView.tag = kActivityIndicatorViewTag;
    activityView.backgroundColor = [UIColor clearColor];
    CGRect rect = activityView.bounds;
    
    activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    rect.size = CGSizeMake(40, 40);
    rect.origin.x = (activityView.frame.size.width - rect.size.width)/2;
    rect.origin.y = (activityView.frame.size.height - 44 - rect.size.height)/2;
    self.activityIndicatorView.frame = rect;
    [self.activityIndicatorView startAnimating];
    [activityView addSubview:self.activityIndicatorView];
    
    UIWindow *lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    [lastWindow addSubview:activityView];
    [activityView release];
	
    [pool release];
}

@end
