    //
//  ImageSplitViewController.m
//  DSM_iPad
//
//  Created by Wu Rongtao on 11-12-28.
//  Copyright 2011 cienet. All rights reserved.
//

#import "ImageSplitViewController.h"
#import "SplitView.h"
#import "ClipSizeViewController.h"
#import "IMPopoverController.h"
#import "AdjustInsertPictureViewController.h"
#import "AdjustMenuViewController.h"
#import "FolderViewController.h"
#import "ReUnManager.h"
#import "UIColor+extend.h"
#import <QuartzCore/QuartzCore.h>

#define kContentRect CGRectMake(0, 0, 320, 460)
#define kClipViewTitle @"裁剪"
#define kClipOfInsertViewTitle @"裁剪图片"
#define kBottomBgViewTag        20000
#define kClipViewImageBgTag     20001
#define kMaxMagnification       10
#define kMinMagnification       0.5
#define kPinchViewTag           30000
@implementation ImageSplitViewController
@synthesize srcImage = srcImage_;
@synthesize dstImage = dstImage_;
@synthesize delegate = delegate_;
@synthesize isFromInsert;

/**
 * @brief 
 * 初始化视图控制器
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

/**
 * @brief 
 *
 * 完成按钮事件处理：设置上级视图控制器，返回上级页面
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)accomplish:(id)sender
{
    [splitView_ splitWithNoOperation];
	self.dstImage = splitView_.dstImage;
    
	if (isFromInsert)
    {
        AdjustInsertPictureViewController *insertVC = [[AdjustInsertPictureViewController alloc] init];
        ReUnManager *rm = [ReUnManager sharedReUnManager];
        insertVC.srcImage = [rm getGlobalSrcImage];
        insertVC.insImage = self.dstImage;
        [self.navigationController pushViewController:insertVC animated:YES];
        [insertVC release];
    }
    else 
    {
        [delegate_ setPicture:self.dstImage];
        [self.navigationController popViewControllerAnimated:YES]; 
    }
}

/**
 * @brief 
 *
 * 完成按钮事件处理：设置上级视图控制器，返回上级页面
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)cancel:(id)sender
{
    NSArray *viewController = self.navigationController.viewControllers;
    if (isFromInsert)
    {
        NSUInteger count = [viewController count];
        if ([[viewController objectAtIndex:(count-2)] isKindOfClass:[FolderViewController class]]) 
        {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:[viewController objectAtIndex:(count-3)] animated:YES]; 
        }
        else
        {
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToViewController:[viewController objectAtIndex:(count-2)] animated:YES];
        }
    }
    else
    {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * @brief 
 *
 * 处理手势
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)doPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (magnification > kMaxMagnification && recognizer.scale > 1 )
    {
        return;
    }
    if (magnification < kMinMagnification && recognizer.scale < 1)
    {
        return;
    }
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1; 
    if (flag)
    {
        magnification = recognizer.view.frame.size.width/kImageDisplayWidth;
    }
    else
    {
        magnification = recognizer.view.frame.size.height/kImageDisplayHeight;
    }
    splitView_.imageView.scale = magnification;
    [splitView_.imageView setNeedsDisplay];
}

/**
 * @brief 
 *
 * 设置功能按钮的选中状态
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)setButtonSelectBg
{
    [resetBtn_ setBackgroundImage:[UIImage imageNamed:@"smallRoundBlueButton.png"]
                         forState:UIControlStateHighlighted];
    [resetBtn_ setBackgroundImage:[UIImage imageNamed:@"smallRoundBlackButton.png"]
                         forState:UIControlStateNormal];
    [chooseBtn_ setBackgroundImage:[UIImage imageNamed:@"roundBlueButton.png"]
                          forState:UIControlStateSelected];
    [chooseBtn_ setBackgroundImage:[UIImage imageNamed:@"roundBlackButton.png"]
                         forState:UIControlStateNormal];
    [doneBtn_ setBackgroundImage:[UIImage imageNamed:@"smallRoundBlueButton.png"]
                          forState:UIControlStateHighlighted]; 
    [doneBtn_ setBackgroundImage:[UIImage imageNamed:@"smallRoundBlackButton.png"]
                          forState:UIControlStateNormal];
    
}

/**
 * @brief 
 *
 * 重置按钮选中状态
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)reSetButtonSelectState
{
    [resetBtn_ setSelected:NO];
    [chooseBtn_ setSelected:NO];
    [doneBtn_ setSelected:NO];
}

/**
 * @brief 
 *
 * 设置视图
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)customToolBar
{
	UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] 
                          forState:UIControlStateNormal];
    [leftButton addTarget:self 
                   action:@selector(cancel:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
	[leftButton release];
    [cancelBarBtn release];
    
	UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 7, 30, 30)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"confirm.png"] 
						   forState:UIControlStateNormal];
    [rightButton addTarget:self 
                    action:@selector(accomplish:)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
	[rightButton release];
    [confirmBarBtn release];
    self.title = isFromInsert?kClipOfInsertViewTitle:kClipViewTitle;;
    
    //设置视图背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]];
    
    //为底部视图添加背景
    UIImageView *bottomBgImageView = [[UIImageView alloc] initWithFrame:bottomBgView_.bounds];
    bottomBgImageView.image = [UIImage imageNamed:@"ImageClipBottonBg.png"];
    [bottomBgView_ insertSubview:bottomBgImageView atIndex:0];
    [bottomBgImageView release];

}

/**
 * @brief 
 *
 * 视图加载完成操作
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    CGFloat imageWidth = self.srcImage.size.width;
    CGFloat imageHeight = self.srcImage.size.height; 
    CGFloat imageFrameWidth = imageWidth;
    CGFloat imageFrameHeight = imageHeight;    
    
    CGFloat viewScaleRatio;
    UIImageView *imageView = nil;
    if (self.srcImage)
    {
        if (kImageDisplayWidth > imageWidth/imageHeight * kImageDisplayWidth) 
        {
            imageFrameWidth = kImageDisplayHeight * imageWidth/imageHeight;
            imageFrameHeight = kImageDisplayHeight;
            viewScaleRatio = imageHeight/imageWidth;
        }
        else
        {
            imageFrameWidth = kImageDisplayWidth;
            imageFrameHeight = kImageDisplayWidth * imageHeight/imageWidth;
            viewScaleRatio = imageWidth/imageHeight;
        }
        
        imageView = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(kImageDisplayWidth/2 - imageFrameWidth/2, 
                                             kImageDisplayHeight/2 - imageFrameHeight/2,
                                             imageFrameWidth, 
                                             imageFrameHeight)];
        imageView.alpha = 0.6;
        CGFloat newSizeWidth = imageFrameWidth * 2;
        CGFloat newSizeHeight = imageFrameHeight * 2;
        CGSize newSize = CGSizeMake(newSizeWidth, newSizeHeight);
        imageView.image = [Common scaleFromImage:self.srcImage toSize:newSize];
  
    } 
    
    imageView.tag = kClipViewImageBgTag; 
    
    if (imageWidth/imageHeight > 300.0/360.0)
    {
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    magnification = 1.0;
    
    //用于控制手势，高度为屏幕高度去掉上方导航栏和下方工具栏高度
    UIView *pinchView = [[UIView alloc] init];//WithFrame:CGRectMake(10, 64, 300, 358)];
    if (isFromInsert) 
    {
        pinchView.frame = CGRectMake(10, 54, 300, 420);
        [Common imageView:imageView autoFitView:pinchView offset:CGPointMake(0,0)margin:CGPointMake(0, 10)];
    }
    else
    {
        pinchView.frame = CGRectMake(10, 64, 300, 358);
    }
    
    tansform = pinchView.transform;
    
    CGRect newRect = CGRectMake(imageView.frame.origin.x-kAdjustMarginWidth, 
                                imageView.frame.origin.y-kAdjustMarginWidth,
                                imageView.frame.size.width+2*kAdjustMarginWidth,
                                imageView.frame.size.height+2*kAdjustMarginWidth);
    splitView_ = [[SplitView alloc] initWithFrame:newRect];
    splitView_.center = imageView.center;
    splitView_.isFromInsert = isFromInsert;
    
    pinchView.tag = kPinchViewTag;
    [pinchView addSubview:imageView];
    [pinchView addSubview:splitView_];
    [imageView release];
    
    //添加手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
                                              initWithTarget:self
                                              action:@selector(doPinch:)];
    [pinchView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    [self.view insertSubview:pinchView atIndex:0];
    [pinchView release];
    
    
    //设置需要操作的原图片及目标图片，第一次初始化时需要设置
    CGRect dstImageRect = CGRectMake(splitView_.imageView.frame.origin.x, 
                                     splitView_.imageView.frame.origin.y, 
                                     splitView_.imageView.frame.size.width - kAdjustMarginWidth * 2, 
                                     splitView_.imageView.frame.size.height - kAdjustMarginWidth * 2);
    splitView_.srcImage = srcImage_;
	splitView_.dstImage = [splitView_ imageFromImage:splitView_.srcImage inRect:dstImageRect];
    [splitView_ setSourceImage:srcImage_];
    //设置截取区域的默认图片
    splitView_.imageView.displayImageView.image = splitView_.dstImage;
    sizeIndex_ = -1;  
    splitView_.clipRatioIndex = -1;
    if (isFromInsert)
    {
        [bottomBgView_ setHidden:YES];
    }

    [resetBtn_ setEnabled:NO];
    [resetBtn_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self customToolBar]; 
    [self setButtonSelectBg];
}
/**
 * @brief 
 *
 * scrollview代理函数
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:kZoomViewTag];
}

/**
 * @brief 
 *
 * 内存警告
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

/**
 * @brief 
 *
 * 内存警告执行
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)viewDidUnload 
{
    [super viewDidUnload];
}

/**
 * @brief 
 *
 * 内存释放
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)dealloc 
{
    [splitView_ release];
	[srcImage_ release];
	[dstImage_ release];
    [bottomBgView_ release];
    [popoverViewCntroller_ release];
    [resetBtn_ release];
    [chooseBtn_ release];
    [doneBtn_ release];
    [super dealloc];
}
/**
 * @brief 
 *
 * 确定裁剪
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)clipImageDone:(id)sender
{
    [self reSetButtonSelectState];
    [doneBtn_ setSelected:YES];
    self.dstImage = splitView_.dstImage;
 
    [resetBtn_ setEnabled:YES];
    [chooseBtn_ setEnabled:NO];
    [doneBtn_ setEnabled:NO];
    [splitView_ setUserInteractionEnabled:NO];
    
    //设置按钮字体颜色
    [resetBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseBtn_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [doneBtn_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [splitView_ setHidden:YES];
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kClipViewImageBgTag];
    UIImage *dstImage = splitView_.imageView.displayImageView.image;
    imageView.image = dstImage;
    
    UIView *pinchView = [self.view viewWithTag:kPinchViewTag];
    pinchView.transform = CGAffineTransformIdentity;
    pinchView.transform = CGAffineTransformScale(pinchView.transform, 1.0, 1.0);
    [splitView_.imageView resetScaleValue];
    [splitView_.imageView setNeedsDisplay];
    
    //切换后台保存操作
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    [rm storeSnap:dstImage];
    imageView.frame = [Common adaptImageToScreen:dstImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = [splitView_ center];
    [imageView setAlpha:1.0];
     
}
/**
 * @brief 
 *
 * 重置操作
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)resetClipFrame:(id)sender
{
    [self reSetButtonSelectState];
    [resetBtn_ setSelected:YES];
    
    [chooseBtn_ setEnabled:YES];
    [doneBtn_ setEnabled:YES];
    [resetBtn_ setEnabled:NO];    
    [splitView_ setUserInteractionEnabled:YES];
    //设置按钮字体颜色
    [resetBtn_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [chooseBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [splitView_ setHidden:NO];    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:kClipViewImageBgTag];
    UIImage *dstImage = splitView_.srcImage;

    imageView.image = dstImage;
    
    imageView.frame = CGRectMake(0 - kAdjustMarginWidth, 
                                 0 - kAdjustMarginWidth,
                                 splitView_.frame.size.width - 2 * kAdjustMarginWidth, 
                                 splitView_.frame.size.height - 2 * kAdjustMarginWidth);
    imageView.center = [splitView_ center];
    [imageView setAlpha:0.6];
    
}
/**
 * @brief 
 *
 * 选择裁剪尺寸
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)selectClipSize:(id)sender
{
    [self reSetButtonSelectState];
    [chooseBtn_ setSelected:YES];
    
    if (popoverViewCntroller_)
    {
        [popoverViewCntroller_ release],popoverViewCntroller_ = nil;
    }
    popoverViewCntroller_.deletage = self;
    
    ClipSizeViewController *selectSizeViewController = [[ClipSizeViewController alloc] init];
    selectSizeViewController.delegate = self;
    selectSizeViewController.maxSize = splitView_.frame.size;
    selectSizeViewController.sizeIndex = sizeIndex_;
	popoverViewCntroller_ = [[IMPopoverController alloc] initWithContentViewController:selectSizeViewController];
    popoverViewCntroller_.deletage = self;
	popoverViewCntroller_.popOverSize = selectSizeViewController.view.frame.size;
    
    CGRect targetFrame = [sender frame]; 
    CGRect newRect = CGRectMake(targetFrame.origin.x - 32, 
                                targetFrame.origin.y + 290, 
                                selectSizeViewController.view.frame.size.width,
                                selectSizeViewController.view.frame.size.height);
	
	[popoverViewCntroller_ presentPopoverFromRect:newRect inView:self.view animated:YES];
	[selectSizeViewController release];
}

#pragma - Delegate Function
/**
 * @brief 
 *
 * 隐藏弹出视图
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)dismissPopView
{
    [popoverViewCntroller_ dismissPopoverAnimated:YES];
    [self reSetButtonSelectState];    
}
/**
 * @brief 
 *
 * 选择尺寸处理
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)getSelectSize:(CGSize)selectSize andSizeIndex:(NSInteger)index
{
    sizeIndex_ = index; 

    CGRect newRect = CGRectMake(0, 0, selectSize.width, selectSize.height);
    splitView_.imageView.frame = newRect; 
    splitView_.imageView.center = CGPointMake(splitView_.frame.size.width/2, splitView_.frame.size.height/2);
    splitView_.clipRatioIndex = index;
    
    CGRect imageRect = CGRectMake(splitView_.imageView.frame.origin.x, 
                                  splitView_.imageView.frame.origin.y,
                                  splitView_.imageView.frame.size.width - kAdjustMarginWidth * 2,
                                  splitView_.imageView.frame.size.height - kAdjustMarginWidth * 2);
    splitView_.imageView.displayImageView.image = [splitView_ imageFromImage:srcImage_ inRect:imageRect]; 
    [splitView_.imageView resetCornerViewFrame];
    [self dismissPopView];
}

@end
