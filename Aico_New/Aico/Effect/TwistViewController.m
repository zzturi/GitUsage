//
//  TwistViewController.m
//  Aico
//
//  Created by rongtaowu on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TwistViewController.h"
#import "ReUnManager.h"
#import "CustomSlider.h"
#import "DrawingImageView.h"

#define kTitleArray [NSArray arrayWithObjects:@"球面化",@"旋转",@"凸出",@"发散",nil]

@interface TwistViewController ()

- (void)addImageView:(UIImage *)srcImage;
- (void)customNavbar;
- (void)addBottomView;

@end

@implementation TwistViewController
@synthesize effectIndex = effectIndex_;

/**
 * @brief 初始化操作
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        titleArray_ = [[NSArray alloc] initWithArray:kTitleArray];
    }
    return self;
}

/**
 * @brief 初始化
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置页面标题
    self.title = [titleArray_ objectAtIndex:effectIndex_];
    
    //添加背景图片
    UIImage *bgImage = [UIImage imageNamed:kBackGroundImage];
    UIColor *bgColor = [UIColor colorWithPatternImage:bgImage];
    self.view.backgroundColor = bgColor;
    
    UIImage *srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    [self addImageView:srcImage];      //显示图片
    [self customNavbar];               //定制导航栏
    [self addBottomView];              //添加底部调节视图
}

/**
 * @brief 内存告警时执行 
 * 
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
 * @brief 屏幕旋转操作 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 * @brief 析构函数 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)dealloc
{
    [titleArray_ release];
    [effectView_ release];
    [super dealloc];
}

/**
 * @brief 添加操作视图 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)addImageView:(UIImage *)srcImage
{
#if 0
    CGFloat imageWidth = srcImage.size.width;
    CGFloat imageHeight = srcImage.size.height;
    CGFloat imageFrameWidth,imageFrameHeight;

    if (kImageDisplayWidth > imageWidth/imageHeight * kImageDisplayWidth) 
    {
        imageFrameWidth = kImageDisplayHeight * imageWidth/imageHeight;
        imageFrameHeight = kImageDisplayHeight;
    }
    else
    {
        imageFrameWidth = kImageDisplayWidth;
        imageFrameHeight = kImageDisplayWidth * imageHeight/imageWidth;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:srcImage];
    imageView.frame = CGRectMake(0, 
                                 0,
                                 imageFrameWidth, 
                                 imageFrameHeight);
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
    [self.view addSubview:imageView];
    [imageView release];
#endif
    if(effectView_ ==nil)
    {
        effectView_ = [[DrawingImageView alloc] initWithFrame:self.view.bounds 
                                                     andImage:srcImage];
        effectView_.center = self.view.center;
        effectView_.effecttype = effectIndex_;
        [self.view addSubview:effectView_];
    }
}

/**
 * @brief 定制导航栏 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)customNavbar
{
    //添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kEffectCancelButtonFrameRect];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self 
                  action:@selector(cancelButtonPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    //添加确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self 
                   action:@selector(confirmButtonPressed:) 
         forControlEvents:UIControlEventTouchUpInside];    
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
}

/**
 * @brief 返回上级视图 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)cancelButtonPressed:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 确认保存图片
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)confirmButtonPressed:(id)sender
{
    //获取特效操作后的图片
    UIImage *effectImage = [effectView_ getEffectImage];
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    [rm storeImage:effectImage];
    //回到主界面
    NSArray *viewController = self.navigationController.viewControllers;
    NSUInteger count = [viewController count];
    UIViewController *dstController = [viewController objectAtIndex:count-3];
    [self.navigationController popToViewController:dstController animated:YES]; 
}

/**
 * @brief 田间底部滑块视图 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)addBottomView
{
    CustomSlider *effectSlider = [[CustomSlider alloc] 
                                         initWithTarget:self 
                                                  frame:kSliderRect 
                                      showBkgroundImage:YES];
    effectSlider.slider.minimumValue = 0.5;
    effectSlider.slider.maximumValue = 2;
    effectSlider.slider.value = 2.0;
    effectSlider.step = 0.005f;
    effectSlider.slider.continuous = YES;
    [self.view addSubview:effectSlider];
    [effectSlider release];
}

/**
 * @brief 滑块操作 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)sliderValueChanged:(float)value
{
    [effectView_ changeEffectRatio:value];
}

@end
