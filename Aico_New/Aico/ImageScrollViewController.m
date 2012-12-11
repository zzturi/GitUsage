//
//  ImageScrollViewController.m
//  Aico
//
//  Created by Wu RongTao on 12-3-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

//#define NSLog NSLog

#import "ImageScrollViewController.h"
#import "ReUnManager.h"

#define kImageScrollViewFrame CGRectMake(0, 44, 320, 382)
#define kMaxMagnification     10.0f
#define kMinMagnification     0.5f
@implementation ImageScrollViewController
@synthesize backgroundView	= backgroundView_;
@synthesize delegateDoPan	= delegateDoPan_;	
@synthesize singleTapDelegate = singleTapDelegate_;
@synthesize imageDisplayRectSize = imageDisplayRectSize_;
@synthesize imageScrollViewRect = imageScrollViewRect_;
@synthesize isEnableZoom = isEnableZoom_;
@synthesize effectType = effectType_;

/**
 * @brief 系统函数 初始化操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageDisplayRectSize_ = CGSizeMake(kImageDisplayWidth, kImageDisplayHeight);
        imageScrollViewRect_ = kImageScrollViewFrame;
        isEnableZoom_ = YES;
    }
    return self;
}

/**
 * @brief 系统函数 析构操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)dealloc
{
	delegateDoPan_ = nil;
    singleTapDelegate_ = nil;
    self.backgroundView = nil;
    [super dealloc];
}

/**
 * @brief 系统函数 收到内存警告
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * @brief 双击操作
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void) doubleTapDone:(UITapGestureRecognizer*)gesture
{    
    UIScrollView *imageScrollView = (UIScrollView *)[self.view viewWithTag:kMainScrollViewTag];
    [imageScrollView setZoomScale:1.2 animated:YES];
}

/**
 * @brief UIScrollView 代理方法
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return isEnableZoom_ ? [scrollView viewWithTag:kZoomViewTag] : nil;
}

/**
 * @brief UIScrollView 代理方法
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:kZoomViewTag];
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    if (effectType_ == EEffectAdjustRGB)
    {
        imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY - 30);
    }
    else
    {
        imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    }
    
}

/**
 * @brief pinch手势
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)doPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (magnification_ > kMaxMagnification && recognizer.scale > 1 )
    {
        return;
    }
    if (magnification_ < kMinMagnification && recognizer.scale < 1)
    {
        return;
    }

    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1; 
    if (flag_)
    {
        magnification_ = recognizer.view.frame.size.width/kImageDisplayWidth;
    }
    else
    {
        magnification_ = recognizer.view.frame.size.height/kImageDisplayHeight;
    }
}

/**
 * @brief pan手势
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)doPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
	[delegateDoPan_ doPanAdditional:translation];
}

/**
 * @brief 单击
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)singleTapDone:(UITapGestureRecognizer*)gesture
{
    if (nil != singleTapDelegate_)
    {
        [singleTapDelegate_ singleTap];
    }
}

#pragma mark - View lifecycle

/**
 * @brief 系统方法
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBackGroundImage]];
    UIImageView *imageView = [[UIImageView alloc] init];
	imageView.tag = kZoomViewTag;
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    imageView.image = [rm getGlobalSrcImage];//self.srcImage;
    if (imageView.image.size.width/imageView.image.size.height > 300.0/360.0)
    {
        flag_ = YES;
    }
    else
    {
        flag_ = NO;
    }
    magnification_ = 1.0;

    CGFloat imageWidth = imageView.image.size.width;
    CGFloat imageHeight = imageView.image.size.height;
    CGFloat imageFrameWidth,imageFrameHeight;
    if (imageDisplayRectSize_.width > imageWidth/imageHeight * imageDisplayRectSize_.width) 
    {
        imageFrameWidth = imageDisplayRectSize_.height * imageWidth/imageHeight;
        imageFrameHeight = imageDisplayRectSize_.height;
    }
    else
    {
        imageFrameWidth = imageDisplayRectSize_.width;
        imageFrameHeight = imageDisplayRectSize_.width * imageHeight/imageWidth;
    }
    imageView.frame = CGRectMake(0, 
                                 0,
                                 imageFrameWidth, 
                                 imageFrameHeight);
 
#if 0
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kImageDisplayWidth, kImageDisplayHeight)];
    [backView setBackgroundColor:[UIColor clearColor]];    
    
    [backView addSubview:imageView];
    imageView.center = backView.center;
    [imageView release];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
                                              initWithTarget:self
                                              action:@selector(doPinch:)];
    [backView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self 
                                          action:@selector(doPan:)];
    [backView addGestureRecognizer:panGesture];   
    [panGesture release];
    
    [self.view insertSubview:backView atIndex:0];
    self.backgroundView = backView;
    [backView release];
#endif    
    
#if 1    
    
    UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:imageScrollViewRect_];
    imageScrollView.tag = kMainScrollViewTag;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.minimumZoomScale = imageView.bounds.size.width / imageScrollView.bounds.size.width;
    if (isEnableZoom_)
        imageScrollView.maximumZoomScale = 10.0;
    else
        imageScrollView.maximumZoomScale = imageScrollView.minimumZoomScale;
    
    imageScrollView.delegate = self;
    imageScrollView.contentOffset = CGPointMake(0, 44);
    

    
    
    if (effectType_ != EEffectTiltShiftId)
    {
        imageView.center = imageScrollView.center;
        [imageScrollView addSubview:imageView];
        UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDone:)];
        singleGesture.numberOfTapsRequired = 1;
        singleGesture.numberOfTouchesRequired = 1;
        [imageScrollView addGestureRecognizer:singleGesture];    
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapDone:)];
        doubleGesture.numberOfTapsRequired = 2;
        doubleGesture.numberOfTouchesRequired = 1;
        [imageScrollView addGestureRecognizer:doubleGesture];
        
        [singleGesture requireGestureRecognizerToFail:doubleGesture];
        
        [singleGesture release];
        [doubleGesture release];

    }
    else
    {
        //移轴操作中图片不需要放大，所以要移除imageScrollView上的手势
        for (UIGestureRecognizer *gesture in [imageScrollView gestureRecognizers])
        {
            [imageScrollView removeGestureRecognizer:gesture];
        }
        UIView *view = [[UIView alloc] initWithFrame:imageView.frame];
        view.center = imageScrollView.center;
        [view addSubview:imageView];
        view.tag = 1002;
        [imageScrollView addSubview:view];
        [view release];
    }
        
    [imageView release];
    [self.view insertSubview:imageScrollView atIndex:0];
    [imageScrollView release];
#endif
}

- (void)viewDidUnload
{
	delegateDoPan_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
