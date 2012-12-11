//
//  MagicWandViewController.m
//  Aico
//
//  Created by  Jiangliyin on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MagicWandViewController.h"
#import "ReUnManager.h"
#import "PaintingView.h"
#import "CustomSlider.h"
#import "MainViewController.h"

#define kPaintingViewRect  CGRectMake(10, 54, 300, 310)
#define kBkgViewRect       CGRectMake(0, 0, 320, 480)
#define kCancelBtnRect     CGRectMake(10, -5, 30, 30)
#define kStyleCount        7
#define kSelectedOffset    (45 - 39)/2.0

#define kMagicWandUndoBtnTag  4201
#define kMagicWandRedoBtnTag  4202

@implementation MagicWandViewController
@synthesize paintView = paintView_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.paintView = nil;
    RELEASE_OBJECT(sizeSlider_);
    [super dealloc];
}

/**
 * @brief 
 * 更新ReUnManager  snapimage
 *
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
-(void)updateImageSnap
{
    [paintView_ updateImageSnap];
}
#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[ReUnManager sharedReUnManager] setIsMagicWand:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    //黑色斜条纹背景图片
    UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:kBkgViewRect];
    backGroundView.image = [UIImage imageNamed:@"bgImage.png"];
    [self.view addSubview:backGroundView];
    [self.view sendSubviewToBack:backGroundView];
    [backGroundView release];
    
    
    //添加返回按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kCancelBtnRect];
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
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    
    //图片
    UIImage *image = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    CGRect imageFrame;
    if (image) 
    {
        imageFrame = [Common adaptImageToScreen:image];
    }
        
    CGRect paintViewFrame;
    //如果图片自适应大小 的高度 小于 屏幕高度去掉导航栏44和滑块90的高度时，让图片在中间垂直居中显示
    if (imageFrame.size.height <= 480 - 90 - 44)
    {
        paintViewFrame = CGRectMake((320 - imageFrame.size.width)/2.0, 44 + (346 - imageFrame.size.height)/2.0 , imageFrame.size.width, imageFrame.size.height);
    }
    else
    {
        paintViewFrame = CGRectMake((320 - imageFrame.size.width)/2.0, 44 + 10, imageFrame.size.width, imageFrame.size.height);
    }
    paintView_ = [[PaintingView alloc] initWithFrame:paintViewFrame];
    paintView_.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:paintView_.bounds];
    imageView.image = image;
    [paintView_ addSubview:imageView];
    [self.view addSubview:paintView_];
    [paintView_ setstampPicName:@"pic_0"];
    paintView_.maxScaleRatio = 75;//滑块默认值是75
    
    //计算imagesize
    image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1.png",paintView_.stampPicName]];
    int max = image.size.width <= image.size.height ? image.size.height:image.size.width;
    paintView_.imageSize = max * paintView_.maxScaleRatio/100.0 * 60/100.0;
    [imageView release];
    
    
    //滑块背景图
    UIImageView *sliderBkgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 390, 320, 90)];
    sliderBkgView.image = [UIImage imageNamed:@"magicSliderBkg.png"];
    [self.view addSubview:sliderBkgView];
    [sliderBkgView release];
    
    //滑块
    sizeSlider_ = [[CustomSlider alloc] initWithTarget:self frame:CGRectMake(0, 394, 320, 34) showBkgroundImage:NO];
    sizeSlider_.slider.minimumValue = 50;
    sizeSlider_.slider.maximumValue = 100;
    sizeSlider_.slider.value = 75;
    sizeSlider_.step = 5.0f;
    sizeSlider_.isShowProgress = NO;
    sizeSlider_.minimumShowPercentValue = 50;
    sizeSlider_.maximumShowPercentValue = 100;
    [self.view addSubview:sizeSlider_];
    
    //样式scrollview
    UIScrollView *styleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, sizeSlider_.frame.origin.y + sizeSlider_.frame.size.height, 320, 56)];
    styleScrollView.backgroundColor = [UIColor clearColor];
    styleScrollView.contentSize = CGSizeMake(45 * kStyleCount, 56);
    styleScrollView.tag = 4501;
    int gap = 5;//每个按钮之间的距离
    UIImage *selectedFrameImg = [UIImage imageNamed:@"selected.png"]; //选中图片蓝色边框
    UIImage *btnBkg = [UIImage imageNamed:@"btnBkg.png"];
    int selectedFrameWidth = selectedFrameImg.size.width;
    int selectedFrameHeight = selectedFrameImg.size.height;
    int btnBkgWidth = btnBkg.size.width;
    int btnBkgHeight = btnBkg.size.height;
    
    int smallImgWidth = 35;
    int smallImgHeight = 35;
    // 将白色背景图片绘制到蓝色边框中，做为选中的按钮背景图片
    UIImage *selectedBkg = [Common addTwoImageToOne:selectedFrameImg twoImage:@"btnBkg.png" toRect:CGRectMake((selectedFrameWidth - btnBkgWidth)/2.0, (selectedFrameHeight - btnBkgHeight)/2.0, btnBkgWidth, btnBkgHeight)];
    for (int i = 0; i < kStyleCount; ++i)
    {
        CGRect btnFrame = CGRectMake((i + 1) * gap + i * btnBkgWidth, (styleScrollView.frame.size.height - btnBkgHeight)/2.0, btnBkgWidth, btnBkgHeight);
        UIButton *styleBtn = [[UIButton alloc] initWithFrame:btnFrame];
        NSString *btnName = [NSString stringWithFormat:@"pic_%d.png",i];
        //将小图片绘制到带蓝色边框的背景图片上
        UIImage *selectedImg = [Common addTwoImageToOne:selectedBkg twoImage:btnName toRect:CGRectMake((selectedFrameWidth - smallImgWidth)/2.0, (selectedFrameHeight - smallImgHeight)/2.0, smallImgWidth, smallImgHeight)];
        //将小图片绘制到带白色背景图片上
        UIImage *unSelectedImg = [Common addTwoImageToOne:btnBkg twoImage:btnName toRect:CGRectMake((btnBkgWidth - smallImgWidth)/2.0, (btnBkgHeight - smallImgHeight)/2.0, smallImgWidth, smallImgHeight)];
        [styleBtn setImage:selectedImg forState:UIControlStateSelected];
        [styleBtn setImage:unSelectedImg forState:UIControlStateNormal];
        
        [styleBtn addTarget:self action:@selector(addPaintPic:) forControlEvents:UIControlEventTouchUpInside];
        styleBtn.tag = 4300 + i;
        [styleBtn setTitle:[NSString stringWithFormat:@"pic_%d",i] forState:UIControlStateNormal];
        //第一个按钮为默认选中样式
        if (i == 0)
        {
            styleBtn.selected = YES;
            styleBtn.frame = CGRectMake(btnFrame.origin.x - kSelectedOffset, btnFrame.origin.y - kSelectedOffset, btnFrame.size.width + 2 * kSelectedOffset, btnFrame.size.height + 2 *kSelectedOffset);
        }
        [styleScrollView addSubview:styleBtn];
        [styleBtn release];
    }
    [self.view addSubview:styleScrollView];
    [styleScrollView release];
    
    UIButton *undoBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 54, 57, 44)];
    [undoBtn setImage:[UIImage imageNamed:@"undoGrayMagic.png"] forState:UIControlStateNormal];
    [undoBtn addTarget:self action:@selector(undoOperation:) forControlEvents:UIControlEventTouchUpInside];
    undoBtn.tag = kMagicWandUndoBtnTag;
    [self.view addSubview:undoBtn];
    [undoBtn release];
    
    UIButton *redoBtn = [[UIButton alloc] initWithFrame:CGRectMake(257, 54, 57, 44)];
    [redoBtn setImage:[UIImage imageNamed:@"redoGrayMagic.png"] forState:UIControlStateNormal];
    redoBtn.tag = kMagicWandRedoBtnTag;
    [redoBtn addTarget:self action:@selector(redoOperation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redoBtn];
    [redoBtn release];
    
    //注册通知，用于更新撤销和恢复按钮图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBtnImage:) name:kMagicWandNotificationUpdateBtnImage object:nil];
    
    //注册通知，用于切后台保存图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageSnap) name:kMagicWandNotificationEnterBackground object:nil];
    
    //注册通知，用于正在绘制时（手未离开屏幕）设置滑块和其他按钮（不包括导航栏按钮）的userinteractionenable
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInteractionEnable:) name:@"updateUserInteractionEnable" object:nil];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[ReUnManager sharedReUnManager] setIsMagicWand:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.paintView = nil;
    RELEASE_OBJECT(sizeSlider_);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Custom Method
/**
 * @brief 
 * 更新撤销和恢复按钮图片
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)updateBtnImage:(NSNotification *)notification
{
    NSArray *objArray = notification.object;
    if ([objArray count] < 2)
    {
        return;
    }
    NSNumber *canUndoObj = [objArray objectAtIndex:0];
    BOOL canUndo = [canUndoObj boolValue];
    NSNumber *canRedoObj = [objArray objectAtIndex:1];
    BOOL canRedo = [canRedoObj boolValue];
    UIButton *undoBtn = (UIButton *)[self.view viewWithTag:kMagicWandUndoBtnTag];
    UIButton *redoBtn = (UIButton *)[self.view viewWithTag:kMagicWandRedoBtnTag];
    if (canUndo)
    {
        [undoBtn setImage:[UIImage imageNamed:@"undoMagic.png"] forState:UIControlStateNormal];
    }
    else
    {
        [undoBtn setImage:[UIImage imageNamed:@"undoGrayMagic.png"] forState:UIControlStateNormal];
    }
    
    if (canRedo)
    {
        [redoBtn setImage:[UIImage imageNamed:@"redoMagic.png"] forState:UIControlStateNormal];
    }
    else
    {
        [redoBtn setImage:[UIImage imageNamed:@"redoGrayMagic.png"] forState:UIControlStateNormal];
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
    //如果paintView_中定时器还有效，先取消定时器，再返回
    if (paintView_.touchEndTimer && [paintView_.touchEndTimer isValid])
    {
        [paintView_.touchEndTimer invalidate];
        paintView_.touchEndTimer = nil;
    }
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
    //如果paintView_中定时器还有效，先取消定时器，再返回
    if (paintView_.touchEndTimer && [paintView_.touchEndTimer isValid])
    {
        [paintView_.touchEndTimer fire];
        paintView_.touchEndTimer = nil;
        
    }
    
    UIImage *curImage = [paintView_ getCurrentPic];
    if (curImage)
    {
        [[ReUnManager sharedReUnManager] storeImage:curImage];
    }
    
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
}
/**
 * @brief 
 * redo按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)redoOperation:(id)sender
{
    [paintView_ forwardDrawing];
}

/**
 * @brief 
 * undo按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)undoOperation:(id)sender
{
    [paintView_ backwardDrawing];
}
/**
 * @brief 
 * 点击图片样式按钮事件
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)addPaintPic:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn isSelected])
    {
        return;
    }
    //更改按钮选中状态，调整区域
    UIScrollView *styleScrollView = (UIScrollView *)[self.view viewWithTag:4501];
    for (UIView *obj in [styleScrollView subviews])
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *btnTemp = (UIButton *)obj;
            CGRect btnFrame = btnTemp.frame;
            //此次操作前为选中状态的要变为非选中状态
            //此次操作按下的按钮要变为选中状态
            if (btnTemp.selected)
            {
                btnTemp.selected = NO;
                btnTemp.frame = CGRectMake(btnFrame.origin.x + kSelectedOffset, btnFrame.origin.y + kSelectedOffset, btnFrame.size.width - 2 * kSelectedOffset, btnFrame.size.height - 2 * kSelectedOffset);
                
            }
            else if(btn == btnTemp)
            {
                btnTemp.selected = YES;
                btnTemp.frame = CGRectMake(btnFrame.origin.x - kSelectedOffset, btnFrame.origin.y - kSelectedOffset, btnFrame.size.width + 2 * kSelectedOffset, btnFrame.size.height + 2 * kSelectedOffset);
            }
        }
    }
    [paintView_ setstampPicName:btn.titleLabel.text];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1.png",btn.titleLabel.text]];
    int max = image.size.width <= image.size.height ? image.size.height:image.size.width;
    paintView_.imageSize = max * paintView_.maxScaleRatio/100.0 * 60/100.0;
}


/**
 * @brief 
 * 更新滑块userInteraction enable
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)updateUserInteractionEnable:(NSNotification *)notification
{
    NSNumber *userInteraction = notification.object;
    UIView *view = [self.view viewWithTag:4501];
    view.userInteractionEnabled = [userInteraction boolValue];
    sizeSlider_.userInteractionEnabled = [userInteraction boolValue];
    
}
#pragma mark- CustomSlider Delegate Method
- (void)sliderValueChanged:(float)value
{
    paintView_.maxScaleRatio = (int)value;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1.png",paintView_.stampPicName]];
    int max = image.size.width <= image.size.height ? image.size.height:image.size.width;
    paintView_.imageSize = max * paintView_.maxScaleRatio/100.0 * 60/100.0;
}
@end
