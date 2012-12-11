//
//  FixRedEyeViewController.m
//  Aico
//
//  Created by Mike on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FixRedEyeViewController.h"
#import "RedEyeProcess.h"
#import "UIImage+extend.h"
#import <QuartzCore/CALayer.h>
#import <CoreGraphics/CGColor.h>
#import "RedEyeProcess.h"
#import "Common.h"
#import "MainViewController.h"
#import "ReUnManager.h"

#define kImageViewWidth             300.0
#define kImageViewHeight            360.0
//kRadius高保真值是44.5
#define kRadius                     25
//这是图片所在的imageview距离屏幕顶部的距离，（导航栏隐藏）kHeight是54
#define kHeight                     54.0
//这是图片所在的imageview距离屏幕左部的距离
#define kWidth                      10.0
//放大按钮的frame
#define kZoomInButtonFrame          CGRectMake(273, 170, 47, 55)
//缩小按钮的frame
#define kZoomOutButtonFrame         CGRectMake(273, 225, 47, 53)
//左侧小窗口的frame
#define kLeftSideImageViewFrame     CGRectMake(-1, 82, 60, 60)
//底部栏的frame
#define kBottomBarFrame             CGRectMake(0, 425, 320, 55)
//撤销按钮的frame
#define kUndoButtonFrame            CGRectMake(102.5, 437.5, 30, 30)
//恢复按钮的frame
#define kRedoButtonFrame            CGRectMake(186.5, 437.5, 30, 30)
#define kNavigationBarButtonFrame   CGRectMake(0, 0, 30, 30)
#define kFixRedEyeTitle             @"去红眼"
#define kInstruction                @"放大至能看清红眼部分，将圆圈尽可能的覆盖红眼部分，然后点击圆圈部分去除红眼"
#define kFontSize12                 12.0f
#define kLabelSize                  CGSizeMake(280, 100)
#define kLabelFrame                 CGRectMake(23, 394, labelSize.width, labelSize.height)
#define kSquareFrame                CGRectMake(-1, -5, 65, 69)
//点击放大按钮，一次放大的倍数，反之缩小为原来的1/1.05
#define kScale                      1.05
//图片的右边界能拖动到的最左位置，下面类似
#define kLeftDistance               80
#define kRightDistance              240
#define kTopDistance                167
#define kBottomDistance             307
//刚进页面时的初始放大倍数
#define kInitialMagnification       2.0

@implementation FixRedEyeViewController
@synthesize currentImageView = currentImageView_;
@synthesize sourcePicture = sourcePicture_;
@synthesize redEyeProcess = redEyeProcess_;
@synthesize zoomInBtn = zoomInBtn_;
@synthesize zoomOutBtn = zoomOutBtn_;
@synthesize undoBtn = undoBtn_;
@synthesize redoBtn = redoBtn_;
@synthesize cancelBtn = cancelBtn_;
@synthesize confirmBtn = confirmBtn_;
@synthesize bgView = bgView_;
@synthesize smallWindowImageView = smallWindowImageView_;

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    self.currentImageView = nil;
    self.sourcePicture = nil;
    self.redEyeProcess = nil;
    self.zoomOutBtn = nil;
    self.zoomInBtn = nil;
    self.undoBtn = nil;
    self.redoBtn = nil;
    self.cancelBtn = nil;
    self.confirmBtn = nil;
    self.bgView = nil;
    self.smallWindowImageView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.currentImageView = nil;
    self.sourcePicture = nil;
    self.redEyeProcess = nil;
    self.zoomOutBtn = nil;
    self.zoomInBtn = nil;
    self.undoBtn = nil;
    self.redoBtn = nil;
    self.cancelBtn = nil;
    self.confirmBtn = nil;
    self.bgView = nil;
    self.smallWindowImageView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ReUnManager *rum = [ReUnManager sharedReUnManager];
    self.sourcePicture = [rum getGlobalSrcImage];
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgImage.png"]];
    [self.view insertSubview:bgImageView 
                     atIndex:0];
    [bgImageView release];
    
    RedEyeProcess *redEyeProcessTemp = [[RedEyeProcess alloc]init];
    self.redEyeProcess = redEyeProcessTemp;
    [redEyeProcessTemp release];
    
    //加这句代码，可以在进入本页面后拖动图片不卡
    self.sourcePicture = [self.redEyeProcess initializeOriginalPicture:self.sourcePicture];
    
    //变量初始化
    roundButtonClicks = 0;
    undoButtonClicks = 0;
    redoButtonClicks = 0;
    magnification = 1;
    x0 = 0.5;
    y0 = 0.5;
    ImageSize = CGSizeMake(kImageViewWidth*kInitialMagnification, kImageViewHeight*kInitialMagnification);
    ImageCenterPoint = CGPointMake(kImageViewWidth/2, kImageViewHeight/2);
    
    UIImageView *bottomBar = [[UIImageView alloc]initWithFrame:kBottomBarFrame];
    bottomBar.image = [UIImage imageNamed:@"blackBottomBar.png"];
    //撤销按钮
    UIButton *undoButton = [[UIButton alloc]initWithFrame:kUndoButtonFrame];
    [undoButton setBackgroundImage:[UIImage imageNamed:kMainUndoGray] 
                          forState:UIControlStateNormal];
    [undoButton addTarget:self 
                   action:@selector(undo)
         forControlEvents:UIControlEventTouchUpInside];
    self.undoBtn = undoButton;
    //恢复按钮
    UIButton *redoButton = [[UIButton alloc]initWithFrame:kRedoButtonFrame];
    [redoButton setBackgroundImage:[UIImage imageNamed:kMainRedoGray] 
                          forState:UIControlStateNormal];
    [redoButton addTarget:self 
                   action:@selector(redo) 
         forControlEvents:UIControlEventTouchUpInside];
    self.redoBtn = redoButton;
    [self.view addSubview:bottomBar];
    [bottomBar release];
    [self.view addSubview:undoButton];
    [undoButton release];
    [self.view addSubview:redoButton];
    [redoButton release];
    
    //添加导航栏上按钮
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = kFixRedEyeTitle;
    self.navigationController.navigationBarHidden = NO;
    
    //添加取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:kNavigationBarButtonFrame];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] 
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelOperation)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    //添加确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:kNavigationBarButtonFrame];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] 
                forState:UIControlStateNormal];
    [confirmBtn addTarget:self 
                   action:@selector(confirmOperation) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    
 
    //加视图
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(kWidth, kHeight, kImageViewWidth, kImageViewHeight)];//CGRectMake(0, 0, kImageViewWidth, kImageViewHeight)
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    
    float width;
    float height;
    UIImage *temp = self.sourcePicture;
    //300是图片显示的最大宽度，360是最大高度
    if (temp.size.width/temp.size.height > kImageViewWidth/kImageViewHeight)
    {
        flag = NO;
        width = kImageViewWidth;
        height = kImageViewWidth*temp.size.height/temp.size.width;
        //下面的4改为2会更好点，这样一来，图片放到最大，圆圈内仅包含4个像素,同样图片更卡
//        maxMagnification = self.sourcePicture.size.width*kRadius/(4*kImageViewWidth);
        maxMagnification = 13.0 > self.sourcePicture.size.width*kRadius/(4*kImageViewWidth) ? self.sourcePicture.size.width*kRadius/(4*kImageViewWidth) : 13.0;
//        minMagnification = 100/kImageViewWidth;
    }
    else
    {
        flag = YES;
        height = kImageViewHeight;
        width = kImageViewHeight*temp.size.width/temp.size.height;
//        maxMagnification = self.sourcePicture.size.height*kRadius/(4*kImageViewHeight);
        maxMagnification = 13.0 > self.sourcePicture.size.height*kRadius/(4*kImageViewHeight) ? self.sourcePicture.size.height*kRadius/(4*kImageViewHeight) : 13.0;
//        minMagnification = 100/kImageViewHeight;
    }
    minMagnification = 0.75;
    currentImageView_ = [[UIImageView alloc] initWithFrame:
                              CGRectMake(kImageViewWidth/2 - width/2, 
                                         kImageViewHeight/2 - height/2,
                                         width, 
                                         height)];
	self.currentImageView.alpha = 1.0;
	self.currentImageView.image = self.sourcePicture;
    
    //加手势
    //捏合
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
                                              initWithTarget:self
                                              action:@selector(doPinch:)];
    //拖动
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self 
                                          action:@selector(doPan:)];
    [backgroundView addGestureRecognizer:panGesture];
    [backgroundView addGestureRecognizer:pinchGesture];
    [panGesture release];
    [pinchGesture release];
    
    [backgroundView insertSubview:self.currentImageView 
                          atIndex:0];
    self.bgView = backgroundView;
    [backgroundView release];
    [self.view insertSubview:self.bgView atIndex:1];
    
    //加label
    NSString *str = kInstruction;//去红眼使用说明
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:kFontSize12]
                       constrainedToSize:kLabelSize 
                           lineBreakMode:UILineBreakModeCharacterWrap];   
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:kLabelFrame];
    
    instructionLabel.text = str;
    instructionLabel.backgroundColor = [UIColor clearColor];
    instructionLabel.font = [UIFont boldSystemFontOfSize:kFontSize12];
    instructionLabel.textColor = [UIColor redColor];
    instructionLabel.textAlignment = UITextAlignmentCenter;
    // 不可少
    instructionLabel.numberOfLines = 0;     
    // Wrap at character boundaries
    instructionLabel.lineBreakMode = UILineBreakModeCharacterWrap;    
    [self.view addSubview:instructionLabel];
    [instructionLabel release];
    
    //加放大缩小按钮
    zoomInBtn_ = [[UIButton alloc]initWithFrame:kZoomInButtonFrame];//放大按钮
    zoomOutBtn_ = [[UIButton alloc]initWithFrame:kZoomOutButtonFrame];//缩小按钮
    [self.zoomInBtn addTarget:self 
                       action:@selector(zoomIn) 
             forControlEvents:UIControlEventTouchUpInside];
    [self.zoomInBtn setBackgroundImage:[UIImage imageNamed:@"zoomInButton.png"] 
                              forState:UIControlStateNormal];
    //怎么设置按钮的类型
    [self.zoomOutBtn addTarget:self 
                        action:@selector(zoomOut) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.zoomOutBtn setBackgroundImage:[UIImage imageNamed:@"zoomOutButton.png"]
                               forState:UIControlStateNormal];
    [self.view addSubview:self.zoomInBtn];
    [self.view addSubview:self.zoomOutBtn];
    
    //添加中心圆按钮
    UIButton *circleButton = [[UIButton alloc]init];
    circleButton.frame = CGRectMake((kImageViewWidth - 2*kRadius)/2.0 +kWidth, 
                                    (kImageViewHeight - 2*kRadius)/2.0 + kHeight, 
                                    2*kRadius, 
                                    2*kRadius);
    circleButton.backgroundColor = [UIColor clearColor];
    [circleButton.layer setMasksToBounds:YES];
    [circleButton.layer setCornerRadius:kRadius]; 
    [circleButton.layer setBorderWidth:1];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 52/255.0, 181/255.0, 1, 1 }); 
//    [circleButton.layer setBorderColor:colorref];
    CFRelease(colorSpace);
    CFRelease(colorref);
    
    [circleButton setBackgroundImage:[UIImage imageNamed:@"circle.png"] 
                            forState:UIControlStateNormal];
    [circleButton setUserInteractionEnabled:YES];
    
    CGPoint center = CGPointMake(circleButton.center.x - currentImageView_.frame.origin.x, 
                                 circleButton.center.y);
    roundCenter_ = center;
    [circleButton addTarget:self 
                     action:@selector(fixRedEye) 
           forControlEvents:UIControlEventTouchUpInside];//是否可从self入手？
    [self.view addSubview:circleButton];
    [circleButton release];
    
    //添加左侧小窗口
    UIImageView *showWindowImageView = [[UIImageView alloc]init];
    showWindowImageView.frame = kLeftSideImageViewFrame;
    UIImageView *squareFrame = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"square.png"]];
    squareFrame.frame = kSquareFrame;
    [showWindowImageView addSubview:squareFrame];
    [squareFrame release];
//    [showWindowImageView.layer setMasksToBounds:YES];
//    [showWindowImageView.layer setCornerRadius:5.0]; 
//    [showWindowImageView.layer setBorderWidth:3];
//    CGColorSpaceRef colorSpace2 = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref2 = CGColorCreate(colorSpace2,(CGFloat[]){ 0.0, 0.0, 0.0, 0.5 }); 
//    [showWindowImageView.layer setBorderColor:colorref2];
//    CFRelease(colorSpace2);
//    CFRelease(colorref2);
    [showWindowImageView setUserInteractionEnabled:NO];
    self.smallWindowImageView = showWindowImageView;
    [showWindowImageView release];
    [self.view addSubview:self.smallWindowImageView];
    
    //圆半径为25
    float length;
    if (!flag) 
    {
        length = 2.0*kRadius*currentImageView_.image.size.width/kImageViewWidth;
    }
    else
    {
        length = 2.0*kRadius*currentImageView_.image.size.height/kImageViewHeight;
    }
    self.smallWindowImageView.image = [currentImageView_.image scaleImage:currentImageView_.image
                                                               withRect:CGRectMake(0.5*self.sourcePicture.size.width - 0.5*length, 
                                                                                   0.5*self.sourcePicture.size.height - 0.5*length, 
                                                                                   length, 
                                                                                   length)];
    cutFrame = CGRectMake(0.5*self.sourcePicture.size.width - 0.5*length, 
                          0.5*self.sourcePicture.size.height - 0.5*length, 
                          length, 
                          length);
    [self performSelector:@selector(initialZoomInPicture) withObject:nil afterDelay:0.3];
}

#pragma mark - Public Method
/**
 * @brief 刚进入本页面时放大图片
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)initialZoomInPicture
{
    magnification = kInitialMagnification;
    [UIView beginAnimations:@"ImageZoomIn" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.bgView.transform = CGAffineTransformScale(self.bgView.transform, kInitialMagnification, kInitialMagnification);
    [UIView commitAnimations];
    
}

/**
 * @brief  放大图片
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)zoomIn
{
    [self.zoomOutBtn setBackgroundImage:[UIImage imageNamed:@"zoomOutButton.png"]
                               forState:UIControlStateNormal];
    CGRect tmp = self.bgView.frame;
    self.bgView.layer.anchorPoint = CGPointMake(x0, y0);
    self.bgView.frame = tmp;
    
    if (magnification > maxMagnification)
    {
        [self.zoomInBtn setBackgroundImage:[UIImage imageNamed:@"zoomInButtonGray.png"] 
                                  forState:UIControlStateNormal];
        return;
    }
    self.bgView.transform = CGAffineTransformScale(self.bgView.transform, kScale, kScale);
    ImageSize = self.bgView.frame.size;
    magnification = magnification*kScale;
    
    if (magnification > maxMagnification)
    {
        [self.zoomInBtn setBackgroundImage:[UIImage imageNamed:@"zoomInButtonGray.png"] 
                                  forState:UIControlStateNormal];
    }
    
    CGRect tmp1 = self.bgView.frame;
    self.bgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.bgView.frame = tmp1;
    self.bgView.center = CGPointMake(self.bgView.center.x , self.bgView.center.y );
    ImageCenterPoint = CGPointMake(self.bgView.center.x - kWidth, self.bgView.center.y - kHeight);
}
/**
 * @brief  缩小图片
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)zoomOut
{
    [self.zoomInBtn setBackgroundImage:[UIImage imageNamed:@"zoomInButton.png"] 
                              forState:UIControlStateNormal];
    if (magnification < minMagnification)
    {
        [self.zoomOutBtn setBackgroundImage:[UIImage imageNamed:@"zoomOutButtonGray.png"]
                                   forState:UIControlStateNormal];
        return;
    }
    
    CGRect tmp = self.bgView.frame;
    self.bgView.layer.anchorPoint = CGPointMake(x0, y0);
    self.bgView.frame = tmp;
    
    self.bgView.transform = CGAffineTransformScale(self.bgView.transform, 1/kScale, 1/kScale);
    ImageSize = self.bgView.frame.size;
    magnification = magnification/kScale;
    if (magnification < minMagnification)
    {
        [self.zoomOutBtn setBackgroundImage:[UIImage imageNamed:@"zoomOutButtonGray.png"]
                                   forState:UIControlStateNormal];
    }
    
    CGRect tmp1 = self.bgView.frame;
    self.bgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.bgView.frame = tmp1;
    self.bgView.center = CGPointMake(self.bgView.center.x , self.bgView.center.y );
    ImageCenterPoint = CGPointMake(self.bgView.center.x - kWidth, self.bgView.center.y - kHeight);
}

/**
 * @brief  撤销操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)undo
{
    if (undoButtonClicks > 0)//排除从没点击去红眼按钮，和图片上已经没有黑色原点的情况
    {
        undoButtonClicks--;
        roundButtonClicks--;
        redoButtonClicks++;
        [self.redoBtn setBackgroundImage:[UIImage imageNamed:kMainRedo]
                                forState:UIControlStateNormal];
        self.currentImageView.image = [self.redEyeProcess backward:self.currentImageView.image];
        
        if (undoButtonClicks == 0) 
        {
            [self.undoBtn setBackgroundImage:[UIImage imageNamed:kMainUndoGray] 
                                    forState:UIControlStateNormal];
        }
        self.smallWindowImageView.image = [self.currentImageView.image scaleImage:self.currentImageView.image 
                                                                         withRect:cutFrame];
        
        [[ReUnManager sharedReUnManager] storeSnap:self.currentImageView.image];
    }
}

/**
 * @brief  恢复之前撤销的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)redo
{
    if (redoButtonClicks > 0)
    {
        redoButtonClicks--;
        undoButtonClicks++;
        roundButtonClicks++;
        [self.undoBtn setBackgroundImage:[UIImage imageNamed:kMainUndo]
                                forState:UIControlStateNormal];
        self.currentImageView.image = [self.redEyeProcess forward:self.currentImageView.image];
        
        if (0 == redoButtonClicks)
        {
            [self.redoBtn setBackgroundImage:[UIImage imageNamed:kMainRedoGray] 
                                    forState:UIControlStateNormal];
        }
        self.smallWindowImageView.image = [self.currentImageView.image scaleImage:self.currentImageView.image 
                                                                         withRect:cutFrame];
        
        [[ReUnManager sharedReUnManager] storeSnap:self.currentImageView.image];
    }
}

/**
 * @brief  取消当前去红眼的操作,返回上层页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)cancelOperation
{
    //退回上层菜单
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * @brief  保存当前去红眼的操作，返回上上层页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)confirmOperation
{
    //退回上上层菜单
    self.sourcePicture = self.currentImageView.image;
    [[ReUnManager sharedReUnManager] storeImage:self.sourcePicture];
    NSArray *viewController = self.navigationController.viewControllers;
  
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 3)] animated:YES];
    
}
/**
 * @brief  去红眼，调用RedEyeProcess中的方法
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)fixRedEye
{
    roundButtonClicks++;//点击次数加一
    redoButtonClicks = 0;
    undoButtonClicks = roundButtonClicks;
    //undo按钮可以按，redo不能
    [self.undoBtn setBackgroundImage:[UIImage imageNamed:kMainUndo] forState:UIControlStateNormal];
    [self.redoBtn setBackgroundImage:[UIImage imageNamed:kMainRedoGray] forState:UIControlStateNormal];
    
    UIImage *temp = self.sourcePicture;
    float f1,f2;
    float times;
    float r;
    
    if (!flag)
    {
        f1 = 1;
        f2 = kImageViewWidth*temp.size.height/(temp.size.width*kImageViewHeight);
        times = ImageSize.width/self.sourcePicture.size.width;//放大倍数
        r = kRadius*self.sourcePicture.size.width/ImageSize.width;//半径
    }
    else
    {
        f1 = kImageViewHeight*temp.size.width/(temp.size.height*kImageViewWidth);
        f2 = 1;
        times = ImageSize.height/self.sourcePicture.size.height;//放大倍数 why：图片一般长宽比不为：300：360
        r = kRadius*self.sourcePicture.size.height/ImageSize.height;//半径
    }
    
    float x = (kImageViewWidth/2-ImageCenterPoint.x+0.5*ImageSize.width*f1)/times;
    float y = (kImageViewHeight/2-ImageCenterPoint.y+0.5*ImageSize.height*f2)/times;
    CGPoint center = CGPointMake(x, y);
    
    self.currentImageView.image = [self.redEyeProcess fixRedEye:self.currentImageView.image
                                                    roundCenter:center 
                                                      andRadius:r];
    self.smallWindowImageView.image = [self.currentImageView.image scaleImage:self.currentImageView.image 
                                                                     withRect:cutFrame];
#if 0
    //如果用scrollview,而不是用手势，就用下面一段代码计算坐标
    UIScrollView *scrollView = (UIScrollView *)[imageScrollVC_.view viewWithTag:1001];
    CGPoint center = CGPointMake((scrollView.contentOffset.x+scrollView.center.x)*self.sourcePicture.size.width/scrollView.contentSize.width, (scrollView.contentOffset.y+scrollView.center.y)*self.sourcePicture.size.height/scrollView.contentSize.height);
    
    self.currentImageView.image = [self.redEyeProcess fixRedEye:self.currentImageView.image 
                                                    roundCenter:center
                                                      andRadius:25*self.sourcePicture.size.width/scrollView.contentSize.width];
#endif
    [[ReUnManager sharedReUnManager] storeSnap:self.currentImageView.image];
}

/**
 * @brief  捏合图片时所做的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)doPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.scale > 1)
    {
        [self.zoomOutBtn setBackgroundImage:[UIImage imageNamed:@"zoomOutButton.png"]
                                   forState:UIControlStateNormal];
    }
    else if(recognizer.scale < 1)
    {
        [self.zoomInBtn setBackgroundImage:[UIImage imageNamed:@"zoomInButton.png"] 
                                  forState:UIControlStateNormal];
    }
    CGRect tmp = recognizer.view.frame;
    
    if (magnification > maxMagnification && recognizer.scale > 1 )
    {
        [self.zoomInBtn setBackgroundImage:[UIImage imageNamed:@"zoomInButtonGray.png"] 
                                  forState:UIControlStateNormal];
        return;
    }
    if (magnification < minMagnification && recognizer.scale < 1)
    {
        [self.zoomOutBtn setBackgroundImage:[UIImage imageNamed:@"zoomOutButtonGray.png"]
                                   forState:UIControlStateNormal];
        return;
    }
    self.bgView.layer.anchorPoint = CGPointMake(x0, y0);
    //设置锚点后frame会改变，即图片在屏幕上的位置会变
    recognizer.view.frame = tmp;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    ImageSize = recognizer.view.frame.size;
    recognizer.scale = 1; 
    if (!flag)
    {
        magnification = ImageSize.width/kImageViewWidth;
    }
    else
    {
        magnification = ImageSize.height/kImageViewHeight;
    }
    
    
    
    CGRect tmp1 = recognizer.view.frame;
    self.bgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    recognizer.view.frame = tmp1;
    recognizer.view.center = CGPointMake(recognizer.view.center.x , recognizer.view.center.y );
    ImageCenterPoint = CGPointMake(recognizer.view.center.x - kWidth, recognizer.view.center.y - kHeight);
}

/**
 * @brief  拖动图片时所做的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)doPan:(UIPanGestureRecognizer *)recognizer
{
    CGRect tmp = recognizer.view.frame;
    self.bgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    recognizer.view.frame = tmp;
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    ImageCenterPoint = CGPointMake(recognizer.view.center.x - kWidth, recognizer.view.center.y - kHeight);
    
    x0 = (0.5*recognizer.view.frame.size.width - recognizer.view.center.x + 160)/recognizer.view.frame.size.width;
    y0 = (0.5*recognizer.view.frame.size.height - recognizer.view.center.y + 234)/recognizer.view.frame.size.height;
    
    
    UIImage *temp = self.sourcePicture;
    float f1,f2;
    float times;
    float length;
    if (!flag)
    {
        f1 = 1;
        f2 = kImageViewWidth*temp.size.height/(temp.size.width*kImageViewHeight);
        times = ImageSize.width/self.sourcePicture.size.width;//放大倍数
        length = 2.0*kRadius/kImageViewWidth*temp.size.width;
    }
    else
    {
        f1 = kImageViewHeight*temp.size.width/(temp.size.height*kImageViewWidth);
        f2 = 1;
        times = ImageSize.height/self.sourcePicture.size.height;//放大倍数
        length = 2.0*kRadius/kImageViewHeight*temp.size.height;
    }
    float x = (kImageViewWidth/2-ImageCenterPoint.x+0.5*ImageSize.width*f1)/times;
    float y = (kImageViewHeight/2-ImageCenterPoint.y+0.5*ImageSize.height*f2)/times;
    
    
    self.smallWindowImageView.contentMode = UIViewContentModeScaleAspectFit;
    cutFrame = CGRectMake(x-0.5*length, 
                          y-0.5*length, 
                          length, 
                          length);
    self.smallWindowImageView.image = [self.currentImageView.image scaleImage:self.currentImageView.image 
                                                         withRect:CGRectMake(x-0.5*length, 
                                                                             y-0.5*length, 
                                                                             length, 
                                                                             length)];//why
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
//        imageCenter =  self.bgView.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled ||
             recognizer.state == UIGestureRecognizerStateFailed ||
             recognizer.state == UIGestureRecognizerStateEnded)
    {
        imageCenter =  self.bgView.center;
        
        if (!flag)//即宽高比大于300/360
        {
            float ratio = (kImageViewHeight-(kImageViewWidth*self.sourcePicture.size.height/self.sourcePicture.size.width))/(2*kImageViewHeight);
            float x1 = self.bgView.frame.origin.x;//bgView左上角的横坐标
            float x2 = self.bgView.frame.origin.x + self.bgView.frame.size.width;//bgView右上角的横坐标
            float y1 = self.bgView.frame.origin.y + self.bgView.frame.size.height*ratio;//bgView左上角的纵坐标
            float y2 = self.bgView.frame.origin.y + self.bgView.frame.size.height - self.bgView.frame.size.height*ratio;//bgView左下角的纵坐标
            if (x1 > kRightDistance) 
            {
                imageCenter.x = kRightDistance + self.bgView.frame.size.width/2;
            }
            if(x2 < kLeftDistance)
            {
                imageCenter.x = kLeftDistance - 0.5*self.bgView.frame.size.width;
            }
            if (y1 > kBottomDistance)
            {
                imageCenter.y = kBottomDistance + self.bgView.frame.size.height/2 - self.bgView.frame.size.height*ratio;
            }
            if (y2 < kTopDistance)
            {
                imageCenter.y = kTopDistance - 0.5*self.bgView.frame.size.height + self.bgView.frame.size.height*ratio;
            }
        }
        else
        {
            float ratio = (kImageViewWidth - (kImageViewHeight*self.sourcePicture.size.width/self.sourcePicture.size.height))/(2*kImageViewWidth);
            float y1 = self.bgView.frame.origin.y;
            float y2 = self.bgView.frame.origin.y + self.bgView.frame.size.height;
            float x1 = self.bgView.frame.origin.x + self.bgView.frame.size.width*ratio;
            float x2 = self.bgView.frame.origin.x + self.bgView.frame.size.width - self.bgView.frame.size.width*ratio;
            if (y1 > kBottomDistance)
            {
                imageCenter.y = kBottomDistance + self.bgView.frame.size.height/2;
            }
            if (y2 < kTopDistance)
            {
                imageCenter.y = kTopDistance - 0.5*self.bgView.frame.size.height;
            }
            if (x1 > kRightDistance) 
            {
                imageCenter.x = kRightDistance + self.bgView.frame.size.width/2 - self.bgView.frame.size.width*ratio;
            }
            if(x2 < kLeftDistance)
            {
                imageCenter.x = kLeftDistance - 0.5*self.bgView.frame.size.width + self.bgView.frame.size.width*ratio;
            }
        }
            
        [UIView beginAnimations:@"ImagePounceBack" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.bgView.center = imageCenter;
        [UIView commitAnimations];
        return;
    }
}
@end
