//
//  AdjustRotateViewController.m
//  Aico
//
//  Created by Yincheng on 12-3-29.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "AdjustRotateViewController.h"
#import "AdjustRotateProcess.h"
#import "MainViewController.h"
#import "UIColor+extend.h"
#import "ReUnManager.h"
#import "ImageScrollViewController.h"

@implementation AdjustRotateViewController
@synthesize srcImage = srcImage_;
@synthesize rotateProcess = rotateProcess_;
@synthesize toolBar = toolBar_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    
    imageScrollVC_ = [[ImageScrollViewController alloc] init];
    [self.view insertSubview:imageScrollVC_.view atIndex:0]; 
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"旋转";
    
    //添加取消按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];    
    [leftBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(returnAdjustMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    [leftBtn release];
    [leftBtnItem release];

    //添加确认按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(280, 7, 30, 30)];    
    [rightBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(finishRotate:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    [rightBtn release];
    [rightBtnItem release];
    
    self.srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];;
    
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    imageView.frame = [Common adaptImageToScreen:self.srcImage];
    imageView.image = self.srcImage;
        
    rotateProcess_ = [[AdjustRotateProcess alloc] init];
    self.rotateProcess.srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];;
    
    //添加工具栏
    toolBar_ = [[UIView alloc] initWithFrame:CGRectMake(0, 421, 320, 59)];    
    
    //高包真中向左向右图标是反的
    //添加Rightbutton
    UIButton *rBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 59)];
    [rBtn setBackgroundImage:[UIImage imageNamed:@"leftRotate.png"] forState:UIControlStateNormal];
    [rBtn setBackgroundImage:[UIImage imageNamed:@"rightRotate1.png"] forState:UIControlStateHighlighted];
    [rBtn addTarget:self action:@selector(rightRotate:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar_ addSubview:(UIView *)rBtn];
    [rBtn release];
    //添加leftbutton
    UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 80, 59)];
    [lBtn setImage:[UIImage imageNamed:@"rightRotate.png"] forState:UIControlStateNormal];
    [lBtn setImage:[UIImage imageNamed:@"leftRotate1.png"] forState:UIControlStateHighlighted];
    [lBtn addTarget:self action:@selector(leftRotate:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar_ addSubview:(UIView *)lBtn];
    [lBtn release];
    //添加Horizontalbutton
    UIButton *hBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 0, 80, 59)];
    [hBtn setImage:[UIImage imageNamed:@"HorizonRotate.png"] forState:UIControlStateNormal];
    [hBtn setImage:[UIImage imageNamed:@"HorizonRotate1.png"] forState:UIControlStateHighlighted];
    [hBtn addTarget:self action:@selector(HorizontalRotate:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar_ addSubview:(UIView *)hBtn];
    [hBtn release];
    //添加Verticalbutton
    UIButton *vBtn = [[UIButton alloc]initWithFrame:CGRectMake(240, 0, 80, 59)];
    [vBtn setImage:[UIImage imageNamed:@"VerticalRotate.png"] forState:UIControlStateNormal];
    [vBtn setImage:[UIImage imageNamed:@"VerticalRotate1.png"] forState:UIControlStateHighlighted];
    [vBtn addTarget:self action:@selector(VerticalRotate:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar_ addSubview:(UIView *)vBtn];
    [vBtn release];
    
    //添加工具栏上标签
    NSArray *arrayLabel = [[NSArray alloc]initWithObjects:@"向右旋转",@"向左旋转",@"左右翻转",@"上下翻转", nil];
    for (int i=0; i<[arrayLabel count]; i++) 
    {
        UILabel *labelTmp = [[UILabel alloc]initWithFrame:CGRectMake(80*i, 34, 80, 25)];
        
        labelTmp.text = [arrayLabel objectAtIndex:i];
        labelTmp.textAlignment = UITextAlignmentCenter;
        labelTmp.textColor = [UIColor getColor:@"939393"];
        labelTmp.font = [UIFont systemFontOfSize:12.0];
        labelTmp.backgroundColor = [UIColor clearColor];
        [toolBar_ addSubview:(UIView *)labelTmp];
        [labelTmp release];
    }
    [arrayLabel release];
    [self.view addSubview:toolBar_];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    RELEASE_OBJECT(imageScrollVC_);
    self.rotateProcess = nil;
    self.toolBar = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    scrollView.delegate = nil;
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.srcImage = nil;
    self.rotateProcess = nil;
    self.toolBar = nil;
    RELEASE_OBJECT(imageScrollVC_);
    [super dealloc];
}

#pragma mark - Press Method
/**
 * @brief 清除scrollview 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)clearScrollView
{
    if (imageScrollVC_)
    {
        UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
        scrollView.delegate = nil;
        [imageScrollVC_.view removeFromSuperview];
        [imageScrollVC_ release],imageScrollVC_ = nil;
        imageScrollVC_ = [[ImageScrollViewController alloc] init];
        [self.view insertSubview:imageScrollVC_.view atIndex:0]; 
    }
}

/**
 * @brief 重置scrollview 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)resetScrollView
{    
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    UIScrollView *imageScrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:kMainScrollViewTag];
    imageScrollView.contentSize = imageScrollView.frame.size;
    imageView.center = CGPointMake(imageScrollView.frame.size.width/2, imageScrollView.frame.size.height/2);
}

/**
 * @brief 逆时针旋转90度(向左旋转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)leftRotate:(id)sender
{
    [self clearScrollView];
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    [self.rotateProcess RotateChangeByDegrees:-90.0];
    imageView.frame = [Common size:CGSizeMake(self.srcImage.size.height, self.srcImage.size.width) autoFitSize:CGSizeMake(320, 425) offset:CGPointMake(0, kNavigationHeight) margin:CGPointMake(10, 10)];
    self.srcImage = self.rotateProcess.srcImage;
    imageView.image = self.srcImage;
    
    [self resetScrollView];
    
    [[ReUnManager sharedReUnManager] storeSnap:self.srcImage];
}

/**
 * @brief 顺时针旋转90度(向右旋转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)rightRotate:(id)sender
{
    [self clearScrollView];
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    [self.rotateProcess RotateChangeByDegrees:90.0];
    imageView.frame = [Common size:CGSizeMake(self.srcImage.size.height, self.srcImage.size.width) autoFitSize:CGSizeMake(320, 425) offset:CGPointMake(0, kNavigationHeight) margin:CGPointMake(10, 10)];
    self.srcImage = self.rotateProcess.srcImage;
    imageView.image = self.srcImage;
    
    [self resetScrollView];
    
    //保存单例
    [[ReUnManager sharedReUnManager] storeSnap:self.srcImage];
}

/**
 * @brief 水平翻转(左右翻转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)HorizontalRotate:(id)sender
{
    [self clearScrollView];
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    [self.rotateProcess RotateChangeByHorizontal];
    self.srcImage = self.rotateProcess.srcImage;
    imageView.frame = [Common adaptImageToScreen:self.srcImage];
    imageView.image = self.srcImage;
    
    [self resetScrollView];
    
    //保存单例
    [[ReUnManager sharedReUnManager] storeSnap:self.srcImage];
}

/**
 * @brief 垂直翻转(上下翻转) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)VerticalRotate:(id)sender
{
    [self clearScrollView];
    UIImageView *imageView = (UIImageView *)[imageScrollVC_.view viewWithTag:kZoomViewTag];
    [self.rotateProcess RotateChangeByVertical];
    self.srcImage = self.rotateProcess.srcImage;
    imageView.frame = [Common adaptImageToScreen:self.srcImage];    
    imageView.image = self.srcImage;
    
    [self resetScrollView];
    
    //保存单例
    [[ReUnManager sharedReUnManager] storeSnap:self.srcImage];
}

#pragma mark - class Methods
/**
 * @brief 确认按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)finishRotate:(id)sender
{
    [[ReUnManager sharedReUnManager] storeImage:self.srcImage];
    NSArray *viewController = self.navigationController.viewControllers;
    //[self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:1] animated:YES];
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}

/**
 * @brief 取消按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnAdjustMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
