//
//  EraseImageViewController.m
//  Aico
//
//  Created by Yin Cheng on 7/16/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import "EraseImageViewController.h"
#import "MainViewController.h"
#import "ReUnManager.h"
#import "AdjustMenuViewController.h"
#import "AdjustMosaicViewController.h"
#import "UIColor+extend.h"

@implementation EraseModeViewController
@synthesize superViewController;
@synthesize opacityValue;

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.bounds = CGRectMake(0, 0, 317, 127);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vegnetteColorBack.png"]];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView release];
    
    /************************** Slider *********************************/
    slider_ = [[UISlider alloc]initWithFrame:CGRectMake(20, 41, 278, 21)];
    [slider_ setThumbImage:[UIImage imageNamed:@"sliderRound.png"] forState:UIControlStateNormal];
    [slider_ setMinimumTrackImage:[UIImage imageNamed:@"sliderProcess.png"] forState:UIControlStateNormal];
    [slider_ setMaximumTrackImage:[UIImage imageNamed:@"sliderProcess.png"] forState:UIControlStateNormal];
    [slider_ addTarget:self action:@selector(opacityValueChanged:) forControlEvents:UIControlEventValueChanged];
    slider_.value = self.opacityValue / 100.0f;
    [self.view addSubview:slider_];
    
    sliderLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(178, 20, 120, 21)];
    [sliderLabel_ setBackgroundColor:[UIColor clearColor]];
    sliderLabel_.text = [NSString stringWithFormat:@"%d%%",self.opacityValue];
    sliderLabel_.textAlignment = UITextAlignmentRight;
    sliderLabel_.textColor = [UIColor whiteColor];
    [self.view addSubview:sliderLabel_];
    
    UILabel *opacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 21)];
    [opacityLabel setBackgroundColor:[UIColor clearColor]];
    opacityLabel.text =  @"透明度";//@"Opacity";
    opacityLabel.textAlignment = UITextAlignmentLeft;
    opacityLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:opacityLabel];
    [opacityLabel release];
    
    /************************** Slider *********************************/
    
    /************************** Button *********************************/
    restoreBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(15, 77, 139, 43)];
    [restoreBtn_ setBackgroundImage:[UIImage imageNamed:@"chooseColorButton.png"] forState:UIControlStateNormal];
    [restoreBtn_ addTarget:self action:@selector(modelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *restoreBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 43)];
    restoreBtnLabel.text = @"恢复";//@"Restore";
    restoreBtnLabel.textColor = [UIColor whiteColor];
    restoreBtnLabel.textAlignment = UITextAlignmentCenter;
    [restoreBtnLabel setBackgroundColor:[UIColor clearColor]];
    [restoreBtn_ addSubview:restoreBtnLabel];
    [restoreBtnLabel release];
    
    UIImageView *restoreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 30, 30)];
    restoreImageView.image = [UIImage imageNamed:@"brushMode_Restore.png"];
    [restoreBtn_ addSubview:restoreImageView];
    [restoreImageView release];
    [self.view addSubview:restoreBtn_];
    
    eraseBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(164, 77, 139, 43)];
    [eraseBtn_ setBackgroundImage:[UIImage imageNamed:@"chooseColorButton.png"] forState:UIControlStateNormal];
    [eraseBtn_ addTarget:self action:@selector(modelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *eraseBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 43)];
    eraseBtnLabel.text = @"擦除";//@"Erase";
    eraseBtnLabel.textColor = [UIColor whiteColor];
    eraseBtnLabel.textAlignment = UITextAlignmentCenter;
    [eraseBtnLabel setBackgroundColor:[UIColor clearColor]];
    [eraseBtn_ addSubview:eraseBtnLabel];
    [eraseBtnLabel release];
    
    UIImageView *eraseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 7, 30, 30)];
    eraseImageView.image = [UIImage imageNamed:@"brushMode_Erase.png"];
    [eraseBtn_ addSubview:eraseImageView];
    [eraseImageView release];
    
    [self.view addSubview:eraseBtn_];
    /************************** Button *********************************/
}

- (void)dealloc
{
    [slider_ release];
    [sliderLabel_ release];
    [restoreBtn_ release];
    [eraseBtn_ release];
    [super dealloc];
}

/**
 * @brief 透明度滑动条滑动触发 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)opacityValueChanged:(UISlider *)slider
{
    EraseImageViewController *mainView = (EraseImageViewController *)self.superViewController;
    self.opacityValue = (int)(slider.value*100);
    mainView.opacityValue = self.opacityValue;
    sliderLabel_.text = [NSString stringWithFormat:@"%d%%",self.opacityValue];
}

/**
 * @brief 恢复和擦除按钮按下触发 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)modelButtonPressed:(UIButton *)sender
{
    EraseImageViewController *mainView = (EraseImageViewController *)self.superViewController;
    
    BOOL ret = ([sender isEqual:eraseBtn_] && (sender == eraseBtn_)) ? YES : NO;
    [mainView resetModePicture:ret];
    [mainView dismissPopView];
}
@end


//橡皮擦中笔刷的区域大小数组
int eraseSizeArray[4] = {5, 10, 15, 20};

@implementation EraseImageViewController
@synthesize backgroundImage = backgroundImage_;
@synthesize eraseImage = eraseImage_;
@synthesize frame,center,transform,alpha,magnification,opacityValue,brushSizeNum;

#pragma mark -  system methods
- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
//    self.navigationItem.title = @"橡皮擦";
    
    //返回按钮
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    [leftBtn release];
    [leftBarBtn release];
    
    //确定按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [rightBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    [rightBtn release];
    [rightBarBtn release];
    
    //add erase mode btn
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    
    eraseModeBtn_ = [[UIButton alloc] initWithFrame:CGRectMake(180, 7, 30, 30)];
    [eraseModeBtn_ setBackgroundImage:[UIImage imageNamed:@"brushMode_Erase.png"] forState:UIControlStateNormal];
    [eraseModeBtn_ addTarget:self action:@selector(chooseModePressed:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:eraseModeBtn_];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 80, 44)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    titleLabel.text = @"橡皮擦";
    [titleView addSubview:titleLabel];
    [titleLabel release];
    self.navigationItem.titleView = titleView;
    [titleView release];
}

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
    [undoBtn_ addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:undoBtn_];
    
    redoBtn_ = [[UIButton alloc]initWithFrame:CGRectMake(240, 15, 30, 30)];
    [redoBtn_ addTarget:self action:@selector(redo:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:redoBtn_];
    
    [footView release];
}

/**
 * @brief 初始化 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */ 
- (void)loadView
{
    [super loadView];

    self.magnification = 1.0f;
    self.opacityValue = 100;
    self.brushSizeNum = 1100;
    
    //**************init navigationBar********************************//
    [self initNavigationBar];
    //**************init navigationBar********************************//
    
    //backgroundView init
    backgroundView_ = [[UIImageView alloc] initWithFrame:[Common adaptImageToScreen:self.backgroundImage]];
    backgroundView_.image = self.backgroundImage;
    backgroundView_.userInteractionEnabled = YES;
    backgroundView_.clipsToBounds = YES;
    [self.view addSubview:backgroundView_];
        
    eraseView_ = [[EraseView alloc] initWithFrame:self.frame image:self.eraseImage];
    eraseView_.delegate = self;
    eraseView_.transform = self.transform;
    eraseView_.center = self.center;
    eraseView_.alpha = 1.0f;
    [eraseView_ transformViewAlpha:self.alpha];
    [backgroundView_ addSubview:eraseView_];
    
    //add pinch gestureRecognizer
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
    [backgroundView_ addGestureRecognizer:pinch];
    [pinch release];
    
    //**************init toolBar********************************//
    [self initToolBar];
    //**************init toolBar********************************//
    
    //检查撤销恢复按钮的可用性
    [self checkButtonEnable];
}

/**
 * @brief 析构 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)dealloc
{
    self.backgroundImage = nil;
    self.eraseImage = nil;
    [backgroundView_ release];
    [eraseView_ release];
    
    [undoBtn_ release];
    [redoBtn_ release];
    [brushBtn_ release];
    
    [eraseModeBtn_ release];
    if (popover_) 
    {
        RELEASE_OBJECT(popover_);
    }
    [super dealloc];
}

#pragma mark -  self methos
/**
 * @brief 橡皮擦模式按钮按下触发（Erase/Restore）
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseModePressed:(UIButton *)sender
{
	EraseModeViewController *modeVC = [[EraseModeViewController alloc] init];
    modeVC.superViewController = self;
    modeVC.opacityValue = self.opacityValue;
    modeVC.view.center = CGPointMake(160, 110);
    if (popover_) 
    {
        RELEASE_OBJECT(popover_);
    }
    popover_ = [[IMPopoverController alloc] initWithContentViewController:modeVC];
    popover_.deletage = self;
	popover_.popOverSize = modeVC.view.bounds.size;
    
    CGRect newRect = modeVC.view.frame;
    [modeVC release];
	[popover_ presentPopoverFromRect:newRect inView:self.view animated:YES];
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
 * @brief undo按钮按下触发（撤销）
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undo:(id)sender
{
    [eraseView_ undo];
    [self checkButtonEnable];
}

/**
 * @brief redo按钮按下触发（重做/恢复）
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redo:(id)sender
{
    [eraseView_ redo];
    [self checkButtonEnable];
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
    if ([eraseView_ canUndo]) 
    {
        [undoBtn_ setEnabled:YES];
        [undoBtn_ setBackgroundImage:[UIImage imageNamed:kMainUndo] forState:UIControlStateNormal];
    }
    else
    {
        [undoBtn_ setEnabled:NO];
        [undoBtn_ setBackgroundImage:[UIImage imageNamed:kMainUndoGray] forState:UIControlStateNormal];
    }
    
    if ([eraseView_ canRedo]) 
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
 * @brief 合成图像处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)mergeImage
{
    UIImage *currentImage = nil;
    if (self.backgroundImage.size.width<=150 && self.backgroundImage.size.height<=150)
    {
        UIGraphicsBeginImageContext(backgroundView_.bounds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(backgroundView_.bounds.size, NO, self.backgroundImage.size.width/backgroundView_.bounds.size.width) ;
    }
    [backgroundView_.layer renderInContext:UIGraphicsGetCurrentContext()];
	currentImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
    return currentImage;
}

/**
 * @brief 返回按钮事件响应 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)leftButtonPress:(id)sender
{
//    //跳转到编辑菜单页面
//    NSArray *viewController = self.navigationController.viewControllers;
//    
//    int index = 0;
//    for (int i=0; i<[viewController count]; i++) 
//    {
//        if ([[viewController objectAtIndex:i] isKindOfClass:[AdjustMenuViewController class]]) 
//        {
//            index = i;
//        }
//    }
//    [self.navigationController popToViewController:[viewController objectAtIndex:index] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 确认按钮事件响应 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)rightButtonPress:(id)sender
{
    //保存图片
    [[ReUnManager sharedReUnManager] storeImage:[self mergeImage]];
    
    //跳转到美化图片页面
    NSArray *viewController = self.navigationController.viewControllers;
    
    int index = 0;
    for (int i=0; i<[viewController count]; i++) 
    {
        if ([[viewController objectAtIndex:i] isKindOfClass:[MainViewController class]]) 
        {
            index = i;
        }
    }
    
    [self.navigationController popToViewController:[viewController objectAtIndex:index] animated:YES];
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
        [self setEraseRadiusAndType];
    }
}

/**
 * @brief 重置导航栏中的橡皮擦模式图片 
 * @param [in] mode:Yes-erase No-restore
 * @param [out]
 * @return
 * @note 
 */
- (void)resetModePicture:(BOOL)mode
{
    eraseView_.brushMode = mode;
    if (mode) 
    {
        [eraseModeBtn_ setBackgroundImage:[UIImage imageNamed:@"brushMode_Erase.png"] forState:UIControlStateNormal];
    }
    else
    {
        [eraseModeBtn_ setBackgroundImage:[UIImage imageNamed:@"brushMode_Restore.png"] forState:UIControlStateNormal];
    }
}

/**
 * @brief 设置橡皮擦大小和类型
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setEraseRadiusAndType
{
    BOOL type = (BOOL)(self.brushSizeNum-1100)%2;
    eraseView_.brushRadius = eraseSizeArray[(self.brushSizeNum-1100)/2] / self.magnification;;
    eraseView_.brushType = !type;
    NSLog(@"magnification is %lf,radius is %lf",self.magnification,eraseView_.brushRadius);
}

#pragma mark - delegate
/**
 * @brief 检查redo和undo按钮有效性
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)eraseImageViewHasChanged
{
    [self checkButtonEnable];
}

/**
 * @brief 隐藏弹出视图
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)dismissPopView
{
    if (brushBtn_.selected == YES) 
    {
        [brushBtn_ setSelected:NO];
        [self setEraseRadiusAndType];
    }
    
    //last
    float value = (100.0 - self.opacityValue) * 255.0 / 100.0;
    eraseView_.brushOpacity =  (int)value;
    NSLog(@"value is :%f,%d",value,(int)value);
    [popover_ dismissPopoverAnimated:YES];
}
@end
