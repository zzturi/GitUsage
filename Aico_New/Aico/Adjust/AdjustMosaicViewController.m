//
//  AdjustMosaicViewController.m
//  Aico
//
//  Created by Yincheng on 12-3-30.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "AdjustMosaicViewController.h"
#import "MainViewController.h"
#import "ReUnManager.h"
#import "Common.h"
#import "UIColor+extend.h"
#import "ColorEffectsCommon.h"
#import "EraseImageViewController.h"

@implementation MosaicSizeViewController
@synthesize superViewController = superViewController_;
@synthesize sizeNum = sizeNum_;

#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.bounds = CGRectMake(0, 0, 188, 141);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"ImageClipPopBg.png"];
    [self.view addSubview:imageView];
    
    for (int i=0; i<4; i++) 
    {
        UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(26, 3+i*32, 42, 32)];
        UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(120, 3+i*32, 42, 32)];
        [buttonOne setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mosaicBrushRound%d.png",i+1]] forState:UIControlStateNormal];
        [buttonOne setBackgroundImage:[UIImage imageNamed:@"ImageClipSizeSelected.png"] forState:UIControlStateSelected];
        [buttonTwo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mosaicBrushSquare%d.png",i+1]] forState:UIControlStateNormal];
        [buttonTwo setBackgroundImage:[UIImage imageNamed:@"ImageClipSizeSelected.png"] forState:UIControlStateSelected];
        
        [buttonOne addTarget:self action:@selector(chooseSize:) forControlEvents:UIControlEventTouchUpInside];
        [buttonTwo addTarget:self action:@selector(chooseSize:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonOne.tag = 1100 + i*2;
        buttonTwo.tag = 1100 + i*2 + 1;
        
        [self.view addSubview:buttonOne];
        [self.view addSubview:buttonTwo];
        [buttonOne release];
        [buttonTwo release];
    }
    [imageView release];
    
    [self setSelectedButton];
}
- (void)dealloc
{
    [super dealloc];
}

#pragma mark - View methods
/**
 * @brief 选择笔刷按钮按下
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setSelectedButton
{
    UIButton *chooseBtn = (UIButton *)[self.view viewWithTag:self.sizeNum];
    chooseBtn.selected = YES;
}

/**
 * @brief 笔刷类型按钮按下
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseSize:(id)sender
{
    UIButton *currentBtn = (UIButton *)sender;
    int lastTag = self.sizeNum;
    if (currentBtn.tag != lastTag)
    {
        UIButton *lastBtn = (UIButton *)[self.view viewWithTag:lastTag];
        lastBtn.selected = NO;
        currentBtn.selected = YES;
        self.sizeNum = currentBtn.tag;
    } 
    if ([self.superViewController isKindOfClass:[AdjustMosaicViewController class]]) 
    {
        AdjustMosaicViewController *mosaicVC = (AdjustMosaicViewController *)self.superViewController;
        mosaicVC.brushSizeNum = self.sizeNum;
        [mosaicVC dismissPopView];
    }
    else if ([self.superViewController isKindOfClass:[EraseImageViewController class]]) 
    {
        EraseImageViewController *eraseVC = (EraseImageViewController *)self.superViewController;
        eraseVC.brushSizeNum = self.sizeNum;
        [eraseVC dismissPopView];
    }
}
@end

#define kButtonTag 1001

//马赛克中笔刷的区域大小数组
int sizeArray[4] = {5, 10, 15, 20};

@implementation AdjustMosaicViewController
@synthesize magnification,brushSizeNum;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.brushSizeNum = 1100;
    self.magnification = 1.0;
    
    //导航栏初始化
    [self initNavigation];
    
    UIImage *srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    CGRect rect = [Common adaptImageToScreen:srcImage];
    
    UIImage *pixelizeImage = [self pixelizeImage:srcImage];
    
    pixelizeView_ = [[UIImageView alloc] initWithFrame:rect];
    pixelizeView_.image = pixelizeImage;
    pixelizeView_.userInteractionEnabled = YES;
    [self.view addSubview:pixelizeView_];
    
    imageView_ = [[ImageMaskView alloc] initWithFrame:pixelizeView_.bounds image:srcImage];
    imageView_.imageMaskFilledDelegate = self;
    [self setBrushType];
    [pixelizeView_ addSubview:imageView_];
    
    //add pinch gestureRecognizer
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
    [pixelizeView_ addGestureRecognizer:pinch];
    [pinch release];
    
    //工具栏初始化
    [self initToolBar];
    
    //检查撤销恢复按钮的可用性
    [self checkButtonEnable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    RELEASE_OBJECT(pixelizeView_);
    RELEASE_OBJECT(imageView_);
    RELEASE_OBJECT(brushBtn_);
    RELEASE_OBJECT(undoBtn_);
    RELEASE_OBJECT(redoBtn_);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    RELEASE_OBJECT(imageView_);
    RELEASE_OBJECT(pixelizeView_);
    if (popover_) 
    {
        RELEASE_OBJECT(popover_);
    }
    RELEASE_OBJECT(brushBtn_);
    RELEASE_OBJECT(undoBtn_);
    RELEASE_OBJECT(redoBtn_);
    [super dealloc];
}

#pragma mark - class methods
/**
 * @brief 导航栏初始化
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initNavigation
{
    //导航栏初始化
    self.navigationController.navigationBarHidden = NO;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 45);
    self.navigationItem.title = @"马赛克";
    
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
    [rightBtn addTarget:self action:@selector(finishMosaicOperate:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = rightBtnItem;
    [rightBtn release];
    [rightBtnItem release];
}
/**
 * @brief 导航栏初始化
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initToolBar
{
    //底部工具栏初始化
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 421, 320, 59)];
    footView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBottomBar.png"]];
    [self.view addSubview:footView];
    
    //brash init
    brushBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(109, 13, 103, 37)];
    [brushBtn_ setBackgroundImage:[UIImage imageNamed:@"mosaicGrayButton.png"] forState:UIControlStateNormal];
    [brushBtn_ setBackgroundImage:[UIImage imageNamed:@"mosaicBlueButton.png"] forState:UIControlStateSelected];
    [brushBtn_ setTitle:@"选择笔刷" forState:UIControlStateNormal];
    [brushBtn_ setTitleColor:[UIColor getColor:@"e8e8e8"] forState:UIControlStateNormal];
    //    brushBtn_.font = [UIFont systemFontOfSize:12.0];
    [brushBtn_ addTarget:self action:@selector(chooseBrush:) forControlEvents:UIControlEventTouchUpInside];
    brushBtn_.showsTouchWhenHighlighted = YES;
    [footView addSubview:brushBtn_];
    
    //redo & undo init
    undoBtn_ = [[UIButton alloc]initWithFrame:CGRectMake(50, 15, 30, 30)];
    [undoBtn_ addTarget:self action:@selector(undoMosaic:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:undoBtn_];
    
    redoBtn_ = [[UIButton alloc]initWithFrame:CGRectMake(240, 15, 30, 30)];
    [redoBtn_ addTarget:self action:@selector(redoMosaic:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:redoBtn_];
    
    [footView release];
}

/**
 * @brief 设置画刷
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setBrushType
{
    imageView_.radius = sizeArray[(self.brushSizeNum-1100)/2] / self.magnification;
    imageView_.type = (BOOL)(self.brushSizeNum-1100)%2;
    NSLog(@"magnification is %lf,radius is %lf",self.magnification,imageView_.radius);
}
/**
 * @brief 全图像素化 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)pixelizeImage:(UIImage *)srcImage
{
    Pixelize *pixel = [[Pixelize alloc] initWithImage:srcImage];
    [pixel pixelize];
    UIImage *newImage = [pixel getPixelizeImage];
    [pixel release];
    return newImage;
}

/**
 * @brief 撤销操作 Undo 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undoMosaic:(id)sender
{
    [imageView_ undo];
    [self checkButtonEnable];
}

/**
 * @brief 重做操作 Redo
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redoMosaic:(id)sender
{
    [imageView_ redo];
    [self checkButtonEnable];
}	

/**
 * @brief 选择画刷操作 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */

- (void)chooseBrush:(id)sender
{
    [brushBtn_ setSelected:YES];
	MosaicSizeViewController *sizeVC = [[MosaicSizeViewController alloc] init];
    sizeVC.sizeNum = self.brushSizeNum;
    sizeVC.superViewController = self;
    sizeVC.view.center = CGPointMake(160, 365);
    if (popover_) 
    {
        RELEASE_OBJECT(popover_);
    }
    popover_ = [[IMPopoverController alloc] initWithContentViewController:sizeVC];
    popover_.deletage = self;
	popover_.popOverSize = sizeVC.view.bounds.size;
    
    CGRect newRect = sizeVC.view.frame;
    [sizeVC release];
	[popover_ presentPopoverFromRect:newRect inView:self.view animated:YES];
}

/**
 * @brief 合成图像处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)mergeImage
{
    UIImage *currentImage = nil;
    UIGraphicsBeginImageContextWithOptions(pixelizeView_.bounds.size, NO, pixelizeView_.image.size.width/pixelizeView_.bounds.size.width) ; 
    [pixelizeView_.layer renderInContext:UIGraphicsGetCurrentContext()];
	currentImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
    return currentImage;
}

/**
 * @brief 取消马赛克操作，返回编辑 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnAdjustMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * @brief 完成马赛克操作，返回主界面
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)finishMosaicOperate:(id)sender
{
    //撤销按钮有效时候，保存当前图片
    if ([imageView_ canUndo]) 
    {
        [[ReUnManager sharedReUnManager] storeImage:[self mergeImage]];
    }
    NSArray *arrayTmp = [self.navigationController viewControllers];
    [self.navigationController popToViewController:(MainViewController *)[arrayTmp objectAtIndex:([arrayTmp count] - 3)] animated:YES];
}

/**
 * @brief 检查撤销和恢复按钮的有效性 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)checkButtonEnable
{
    if ([imageView_ canUndo]) 
    {
        [undoBtn_ setEnabled:YES];
        [undoBtn_ setBackgroundImage:[UIImage imageNamed:kMainUndo] forState:UIControlStateNormal];
    }
    else
    {
        [undoBtn_ setEnabled:NO];
        [undoBtn_ setBackgroundImage:[UIImage imageNamed:kMainUndoGray] forState:UIControlStateNormal];
    }
    
    if ([imageView_ canRedo]) 
    {
        [redoBtn_ setEnabled:YES];
        [redoBtn_ setBackgroundImage:[UIImage imageNamed:kMainRedo] forState:UIControlStateNormal];
    }
    else 
    {
        [redoBtn_ setEnabled:NO];
        [redoBtn_ setBackgroundImage:[UIImage imageNamed:kMainRedoGray] forState:UIControlStateNormal];
    }
}

/**
 * @brief 缩放手势处理(底图) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)doPinch:(UIPinchGestureRecognizer *)recognizer
{
    BOOL pinchFlag = ((self.magnification > 4 && recognizer.scale > 1 ) || (self.magnification < 0.75 && recognizer.scale < 1));
    if (!pinchFlag)
    {
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        self.magnification = self.magnification * recognizer.scale;
    }
    recognizer.scale = 1;
    
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self setBrushType];
    }
}

#pragma mark - IMPopoverDelegate &&  ImageMaskFilledDelegate
/**
 * @brief 隐藏弹出视图
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)dismissPopView
{
    [brushBtn_ setSelected:NO];
    [self setBrushType];
    [popover_ dismissPopoverAnimated:YES];
}

/**
 * @brief 成功涂抹后的响应事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)imageMaskView:(ImageMaskView *)maskView cleatPercentWasChanged:(float)clearPercent
{
	NSLog(@"percent: %.2f", clearPercent);
    //检查按钮有效性
    [self checkButtonEnable];
    //切后台保存图片
    [[ReUnManager sharedReUnManager] storeSnap:[self mergeImage]];
}

@end
