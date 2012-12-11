//
//  AdjustInsertPictureViewController.m
//  Aico
//
//  Created by Yincheng on 12-3-31.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "AdjustInsertPictureViewController.h"
#import "MainViewController.h"
#import "ImageSplitViewController.h"
#import "ImageInfo.h"
#import <QuartzCore/CALayer.h>
#import "AdjustMenuViewController.h"
#import "ReUnManager.h"
#import "EraseImageViewController.h"

#define kTagBaseImage      92220
#define kTagInsertImage    92221
#define kTagRotateButton   92222

//*****************AdjustInsertPictureViewController private methods************//
@interface  AdjustInsertPictureViewController(private)
- (void)returnAdjustMenu:(id)sender;
- (void)finishInsertPicture:(id)sender;
- (UIImage *)mergeImage;
- (void)doPinch:(UIPinchGestureRecognizer *)recognizer;
- (void)doPan:(UIPanGestureRecognizer *)recognizer;
- (void)doPanInsert:(UIPanGestureRecognizer *)recognizer;
- (BOOL)beyondImageView:(CGPoint)point;
- (void)resetButtonIfBeyondImageView;
@end
//*******************************************************************************//

@implementation AdjustInsertPictureViewController
@synthesize srcImage = srcImage_;
@synthesize insImage = insImage_;
@synthesize imageView = imageView_;
@synthesize insertView = insertView_;
@synthesize btnView = btnView_;

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
    self.navigationController.navigationBarHidden = NO;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"插图";
    
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
    [rightBtn addTarget:self action:@selector(finishInsertPicture:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = rightBtnItem;
    [rightBtn release];
    [rightBtnItem release];
        
    //给底图imageView初始化
    CGRect rect = [Common adaptImageToScreen:self.srcImage];
    NSLog(@"rect frame is:%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    flag_ = NO;
    //如果底图宽和高都小与150，则进行缩放比较困难
    if (rect.size.width<150&&rect.size.height<150) 
    {
        flag_ = YES;
        if (rect.size.width>=rect.size.height) 
        {
            CGFloat nw = 300;
            CGFloat nh = nw*rect.size.height/rect.size.width;
            if (nh>=360)
                nh = 360;
            rect = CGRectMake(rect.origin.x+rect.size.width/2-nw/2, rect.origin.y+rect.size.height/2-nh/2, nw, nh);
        }
        else
        {
            CGFloat nh = 360;
            CGFloat nw = nh*rect.size.width/rect.size.height;
            if (nh>=300)
                nh = 300;
            rect = CGRectMake(rect.origin.x+rect.size.width/2-nw/2, rect.origin.y+rect.size.height/2-nh/2, nw, nh);
        }
    }
    imageView_ = [[UIImageView alloc] initWithFrame:rect];
    self.imageView.image = self.srcImage;
    self.imageView.userInteractionEnabled = YES;
    //底图ImageView上的子view超出不显示
    [imageView_ setClipsToBounds:YES];
    [self.view addSubview:self.imageView];

    
    //切图初始化,要求切图按比例进行
    NSLog(@"self.insImage.size:%f,%f",self.insImage.size.width,self.insImage.size.height);
    CGFloat ratio = self.insImage.size.width/self.insImage.size.height;
    
    CGFloat px,py,pw,ph;
    if (ratio>1) 
    {
        CGFloat wf = self.imageView.frame.size.width/2;
        pw = wf;
        ph = wf/ratio;
        px = (self.imageView.frame.size.width - pw)/2;
        py = (self.imageView.frame.size.height - ph)/2;
    }
    else
    {
        CGFloat wf = self.imageView.frame.size.height/2;
        pw = wf*ratio;
        ph = wf;
        px = (self.imageView.frame.size.width - pw)/2;
        py = (self.imageView.frame.size.height - ph)/2;
    }
    
    insertView_ = [[UIImageView alloc] initWithFrame:CGRectMake(px,py,pw,ph)];
    self.insertView.userInteractionEnabled = YES;
    self.insertView.image = self.insImage;
    self.insertView.alpha = 1.0f;
    self.insertView.tag = kTagInsertImage;
    self.imageView.tag = kTagBaseImage;
    [self.imageView addSubview:self.insertView];
    
    //切图上旋转图钉初始化
    CGRect btnRotate =  CGRectMake(px+pw-kInsertButtonLen/2, py+ph-kInsertButtonLen/2, kInsertButtonLen, kInsertButtonLen);
    btnRotate = [self.imageView convertRect:btnRotate toView:self.view];
    btnView_ = [[UIImageView alloc] initWithFrame:btnRotate];
    self.btnView.image = [UIImage imageNamed:@"insertBtn.png"];
    self.btnView.tag = kTagRotateButton;
    self.btnView.userInteractionEnabled = YES;
    [self.view addSubview:self.btnView];
    
    //添加透明度滑块
    alphaSlider_ = [[CustomSlider alloc] initWithTarget:self frame:kSliderRect showBkgroundImage:YES];
    alphaSlider_.slider.minimumValue = kSliderValue1;
    alphaSlider_.slider.maximumValue = kSliderValue2;
    alphaSlider_.slider.value = kSliderValue2;
    alphaSlider_.step = 0.01;
	alphaSlider_.minimumShowPercentValue = 0;
	alphaSlider_.maximumShowPercentValue = 100;
    [self.view addSubview:alphaSlider_];
    
    //给底图添加伸缩手势    
    pinchGesture_ = [[UIPinchGestureRecognizer alloc] 
                                              initWithTarget:self
                                              action:@selector(doPinch:)];
    [self.imageView addGestureRecognizer:pinchGesture_];
    
    //给底图添加移动手势
    panGesture_ = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self 
                                          action:@selector(doPan:)];
    [self.imageView addGestureRecognizer:panGesture_];
      
    //给切图添加移动手势
    UIPanGestureRecognizer *insPanGesture = [[UIPanGestureRecognizer alloc]
                     initWithTarget:self 
                     action:@selector(doPanInsert:)];
    [self.insertView addGestureRecognizer:insPanGesture];
    [insPanGesture release];
    
    magnification_ = 1.0;
    ImageSize_ = CGSizeMake(self.srcImage.size.width, self.srcImage.size.height);
    beginImageSize_ = rect.size;
    
    //保存单例
    [[ReUnManager sharedReUnManager] storeSnap:[self mergeImage]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
    self.insertView = nil;
    self.btnView = nil;
    RELEASE_OBJECT(alphaSlider_);
    RELEASE_OBJECT(pinchGesture_);
    RELEASE_OBJECT(panGesture_);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.srcImage = nil;
    self.insImage = nil;
    self.imageView = nil;
    self.insertView = nil;
    self.btnView = nil;
    RELEASE_OBJECT(alphaSlider_);
    RELEASE_OBJECT(pinchGesture_);
    RELEASE_OBJECT(panGesture_);
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当前不支持多点触摸，多点触摸只有放缩手势
    if ([[event allTouches]count]>1)
    {
        return;
    }
    
    UITouch *touch = [touches anyObject];
            
    [btnView_ setHidden:NO];
    
    tRange_ = RangeOne;
    
    if ((touch.view.tag == kTagRotateButton)||
        (touch.view.tag == kTagInsertImage))
    {
        [self.imageView removeGestureRecognizer:pinchGesture_];
        [self.imageView removeGestureRecognizer:panGesture_];
        
        if (touch.view.tag == kTagInsertImage) 
        {
        }
        else if (touch.view.tag == kTagRotateButton) 
        {
            begPoint_ = [touch locationInView:self.imageView];
            
            //计算self.btnView.center对应到insertView中
            btnPointFirst_ = [self.view convertPoint:self.btnView.center toView:self.insertView];
            NSLog(@"btnPoinFirst began:%f,%f",btnPointFirst_.x,btnPointFirst_.y);
        }
        tRange_ = RangeTwo;
    }
    else if (touch.view.tag == kTagBaseImage) 
    {        
        //在insertview边界，点击，会自动出现一个Button
        CGPoint point = [touch locationInView:self.insertView];
        begPoint_ = [touch locationInView:self.imageView];
        
        //左上角
        if (point.x>self.insertView.bounds.origin.x-kInsertButtonLen/2 &&
            point.x<self.insertView.bounds.origin.x &&
            point.y>self.insertView.bounds.origin.y-kInsertButtonLen/2 &&
            point.y<self.insertView.bounds.origin.y) 
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(self.insertView.bounds.origin.x, self.insertView.bounds.origin.y) toView:self.imageView]; 
        }
        //右上角
        else if (point.x>self.insertView.bounds.size.width &&
                 point.x<self.insertView.bounds.size.width+kInsertButtonLen/2 &&
                 point.y>self.insertView.bounds.origin.y-kInsertButtonLen/2 &&
                 point.y<self.insertView.bounds.origin.y) 
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(self.insertView.bounds.size.width, self.insertView.bounds.origin.y) toView:self.imageView]; 
        }
        //左下角
        else if (point.x>self.insertView.bounds.origin.x-kInsertButtonLen/2 &&
                 point.x<self.insertView.bounds.origin.x &&
                 point.y>self.insertView.bounds.size.height &&
                 point.y<self.insertView.bounds.size.height+kInsertButtonLen/2) 
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(self.insertView.bounds.origin.x, self.insertView.bounds.size.height) toView:self.imageView]; 
        }
        //右下角
        else if (point.x>self.insertView.bounds.size.width &&
                 point.x<self.insertView.bounds.size.width+kInsertButtonLen/2 &&
                 point.y>self.insertView.bounds.size.height &&
                 point.y<self.insertView.bounds.size.height+kInsertButtonLen/2) 
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(self.insertView.bounds.size.width, self.insertView.bounds.size.height) toView:self.imageView]; 
        }
        //切图上边
        else if (point.x>self.insertView.bounds.origin.x &&
                 point.x<self.insertView.bounds.size.width &&
                 point.y<self.insertView.bounds.origin.y &&
                 point.y>self.insertView.bounds.origin.y-kInsertButtonLen/2)
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(point.x, self.insertView.bounds.origin.y-kInsertButtonLen/2) toView:self.imageView];
            
        }
        //切图下边
        else if (point.x>self.insertView.bounds.origin.x &&
                 point.x<self.insertView.bounds.size.width &&
                 point.y<self.insertView.bounds.size.height+kInsertButtonLen/2 &&
                 point.y>self.insertView.bounds.size.height)
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(point.x, self.insertView.bounds.size.height+kInsertButtonLen/2) toView:self.imageView];
        }
        //切图左边
        else if (point.x>self.insertView.bounds.origin.x-kInsertButtonLen/2 &&
                 point.x<self.insertView.bounds.origin.x &&
                 point.y>self.insertView.bounds.origin.y &&
                 point.y<self.insertView.bounds.size.height) 
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(self.insertView.bounds.origin.x-kInsertButtonLen/2, point.y) toView:self.imageView];
        }
        //切图右边
        else if (point.x>self.insertView.bounds.size.width &&
                 point.x<self.insertView.bounds.size.width+kInsertButtonLen/2 &&
                 point.y>self.insertView.bounds.origin.y &&
                 point.y<self.insertView.bounds.size.height)
        {
            begPoint_ = [self.insertView convertPoint:CGPointMake(self.insertView.bounds.size.width+kInsertButtonLen/2, point.y) toView:self.imageView]; 
        }
        else
        {
            //do nothing
            return;
        }
        tRange_ = RangeThree;
        [self.imageView removeGestureRecognizer:pinchGesture_];
        [self.imageView removeGestureRecognizer:panGesture_];
        self.btnView.center = [self.imageView convertPoint:begPoint_ toView:self.view];
        btnPointFirst_ = [self.view convertPoint:self.btnView.center toView:self.insertView];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当前不支持多点触摸，多点触摸只有放缩手势
    if ([[event allTouches]count]>1)
    {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    //移动 
    if (touch.view.tag == kTagInsertImage) 
    {
    }
    //点击图钉进行旋转或者点击切图边界触发图钉后进行的旋转
    if ((touch.view.tag == kTagRotateButton && tRange_ == RangeTwo)||
        (touch.view.tag == kTagBaseImage && tRange_ == RangeThree))
    {
        curPoint_ = [touch locationInView:self.imageView];
        
        CGPoint pointTmp = [touch locationInView:self.view];
        self.btnView.center = CGPointMake(pointTmp.x, pointTmp.y);
                
        CGFloat angle = [Common makeRotate:self.insertView.center withBegin:begPoint_ andEnd:curPoint_];
        CGFloat scale = [Common makeScale:self.insertView.center beginPoint:begPoint_ andEndPoint:curPoint_];

        self.insertView.transform = CGAffineTransformScale(CGAffineTransformRotate(self.insertView.transform, angle), scale, scale);
        
        begPoint_ = curPoint_;
        
        //切图和图钉位置进行更正
        btnPointFirst_ = [self.insertView convertPoint:btnPointFirst_ toView:self.imageView];
        CGFloat angle1 = [Common makeRotate:self.insertView.center withBegin:btnPointFirst_ andEnd:curPoint_];
        CGFloat scale1 = [Common makeScale:self.insertView.center beginPoint:btnPointFirst_ andEndPoint:curPoint_];
        self.insertView.transform = CGAffineTransformScale(CGAffineTransformRotate(self.insertView.transform, angle1), scale1, scale1);
        btnPointFirst_ = [self.imageView convertPoint:curPoint_ toView:self.insertView];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当前不支持多点触摸，多点触摸只有放缩手势
    if ([[event allTouches]count]>1)
    {
        return;
    }
    [self.imageView addGestureRecognizer:pinchGesture_];
    [self.imageView addGestureRecognizer:panGesture_];
    
    //保存单例
    [[ReUnManager sharedReUnManager] storeSnap:[self mergeImage]];
}

#pragma mark - class private method
/**
 * @brief 取消按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnAdjustMenu:(id)sender
{
    //清除滑动条
    if (nil != alphaSlider_) 
    {
        [alphaSlider_ removePopover];
    }
    
    //跳转到编辑菜单页面
    NSArray *viewController = self.navigationController.viewControllers;
    
    int index = 0;
    for (int i=0; i<[viewController count]; i++) 
    {
        if ([[viewController objectAtIndex:i] isKindOfClass:[AdjustMenuViewController class]]) 
        {
            index = i;
        }
    }
    
    [self.navigationController popToViewController:[viewController objectAtIndex:index] animated:YES];
}

/**
 * @brief 确认按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)finishInsertPicture:(id)sender
{
    [alphaSlider_ removePopover];//清除滑动条
    
#if 0
    //获取当前图片，并保存下来  
    UIImage *image = [self mergeImage];
    [[ReUnManager sharedReUnManager] storeImage:image];
    
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
#else
    //添加橡皮擦功能
    EraseImageViewController *eraseImageViewController = [[EraseImageViewController alloc] init];
    eraseImageViewController.backgroundImage = self.srcImage;
    eraseImageViewController.eraseImage = self.insImage;
    eraseImageViewController.frame = self.insertView.bounds;
    eraseImageViewController.transform = self.insertView.transform;
    eraseImageViewController.center = self.insertView.center;
    eraseImageViewController.alpha = self.insertView.alpha;
    
    [self.navigationController pushViewController:eraseImageViewController animated:YES];
    [eraseImageViewController release];
#endif
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
    
    if (flag_) 
    {
        UIGraphicsBeginImageContext(self.imageView.bounds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, self.imageView.image.size.width/self.imageView.bounds.size.width) ; 
    }
    
    [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	currentImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
    return currentImage;
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
    //最大放大8倍，缩小4倍
    if ((magnification_ > 4 && recognizer.scale > 1 )||
        (magnification_ < 0.75 && recognizer.scale < 1)||
        (beginImageSize_.width<150&&magnification_<=1.0&&recognizer.scale<1)||
        (beginImageSize_.height<150&&magnification_<=1.0&&recognizer.scale<1))
    {
        return;
    }
    
    CGPoint pointTmp = self.btnView.center;
    pointTmp = [self.view convertPoint:pointTmp toView:self.imageView];
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    pointTmp = [self.imageView convertPoint:pointTmp toView:self.view];
    self.btnView.frame = CGRectMake(pointTmp.x-kInsertButtonLen/2, pointTmp.y-kInsertButtonLen/2, kInsertButtonLen, kInsertButtonLen);
    
    magnification_ = magnification_*recognizer.scale;
    ImageSize_ = recognizer.view.frame.size;
    
    recognizer.scale = 1;
    
    if (self.imageView.frame.size.width/self.imageView.frame.size.height)
    {
        magnification_ = ImageSize_.width/beginImageSize_.width;
    }
    else
    {
        magnification_ = ImageSize_.height/beginImageSize_.height;
    }
}

/**
 * @brief 移动手势处理(底图) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)doPan:(UIPanGestureRecognizer *)recognizer
{   
    CGPoint translation = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        imageCenter_ = self.imageView.center;
        buttonCenter_ = self.btnView.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled ||
             recognizer.state == UIGestureRecognizerStateFailed ||
             recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:@"ImageComeBack" context:nil];
        
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.imageView.center = imageCenter_;
        self.btnView.center = buttonCenter_;
        [UIView commitAnimations];
        return;
    }

    if (isnan(translation.x)||isnan(translation.y))
    {
        return;
    }

    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    self.btnView.center = CGPointMake(self.btnView.center.x+translation.x, self.btnView.center.y+translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

/**
 * @brief 当前位置是否超出底图(imageView_)边界
 * @param [in] point
 * @param [out]
 * @return
 * @note 
 */
- (BOOL)beyondImageView:(CGPoint)point
{
    point = [self.insertView convertPoint:point toView:self.imageView];
    if ((point.x>=self.imageView.bounds.origin.x) &&
        (point.x<=self.imageView.bounds.origin.x+self.imageView.bounds.size.width) &&
        (point.y>=self.imageView.bounds.origin.y) &&
        (point.y<=self.imageView.bounds.origin.y+self.imageView.bounds.size.height)) 
    {
        return NO;
    }
    return YES;
}

/**
 * @brief 旋转图钉超出边界，对其位置进行重置
 * @param [in] point
 * @param [out]
 * @return
 * @note 
 */
- (void)resetButtonIfBeyondImageView
{
    if (self.btnView.center.x<self.imageView.frame.origin.x ||
        self.btnView.center.x>self.imageView.frame.origin.x+self.imageView.frame.size.width ||
        self.btnView.center.y<self.imageView.frame.origin.y ||
        self.btnView.center.y>self.imageView.frame.origin.y+self.imageView.frame.size.height) 
    {
        NSLog(@"超出边界了哦");
        
        CGPoint pleftUp = self.insertView.bounds.origin;
        
        CGPoint prightUP = CGPointMake(self.insertView.bounds.origin.x+self.insertView.bounds.size.width, 
                                       self.insertView.bounds.origin.y);
        CGPoint pleftDown = CGPointMake(self.insertView.bounds.origin.x, 
                                        self.insertView.bounds.origin.y+self.insertView.bounds.size.height);
        CGPoint prightDown = CGPointMake(self.insertView.bounds.origin.x+self.insertView.bounds.size.width,
                                         self.insertView.bounds.origin.y+self.insertView.bounds.size.height);
        NSLog(@"%d,%d,%d,%d",
              [self beyondImageView:pleftUp],
              [self beyondImageView:prightUP],
              [self beyondImageView:pleftDown],
              [self beyondImageView:prightDown]);
        
        //insertView_四个角都跑出，则btnView不动
        if (([self beyondImageView:pleftUp])&&
            ([self beyondImageView:prightUP])&&
            ([self beyondImageView:pleftDown])&&
            ([self beyondImageView:prightDown])) 
        {
            //do nothing
        }
        else if (![self beyondImageView:prightDown])
        {
            self.btnView.center = [self.insertView convertPoint:prightDown toView:self.view];
        }
        else if (![self beyondImageView:pleftDown])
        {
            self.btnView.center = [self.insertView convertPoint:pleftDown toView:self.view];
        }
        else if (![self beyondImageView:prightUP])
        {
            self.btnView.center = [self.insertView convertPoint:prightUP toView:self.view];
        }
        else if (![self beyondImageView:pleftUp])
        {
            self.btnView.center = [self.insertView convertPoint:pleftUp toView:self.view];
        }
    }
}

/**
 * @brief 移动手势处理(切图) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)doPanInsert:(UIPanGestureRecognizer *)recognizer
{   
    CGPoint translation = [recognizer translationInView:self.imageView];
    CGPoint translation1 = [recognizer translationInView:self.view];
    
    if (isnan(translation.x)||isnan(translation.y)||isnan(translation1.x)||isnan(translation1.y))
    {
        return;
    }
    
    //点击切图和移动切图 旋转图钉消失；移动结束 旋转图钉重现
    switch (recognizer.state) 
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.btnView.hidden = YES;
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            self.btnView.hidden = NO;
            //保存单例
            [[ReUnManager sharedReUnManager] storeSnap:[self mergeImage]];
        }
            break;
        default:
            break;
    }
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    self.btnView.center = CGPointMake(self.btnView.center.x+translation1.x, self.btnView.center.y+translation1.y);
    //图钉超出底图位置，需要重置图钉
    [self resetButtonIfBeyondImageView];
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.imageView];
}

#pragma mark - Slider delegate
- (void)sliderValueChanged:(float)value
{
    //透明度改变实际是改变imageview的alpha值
    self.insertView.alpha = value;
    //目前改变滑动条，旋转按钮消失，此功能如要实现比较繁琐。且需求中未要求，故先不添加此功能
//    self.btnView.hidden = YES;
}

- (void)sliderTouchUp
{
    [[ReUnManager sharedReUnManager] storeSnap:[self mergeImage]];
}

#pragma mark - UIGestureRecognizer
//询问一个手势接受者是否开始解释执行一个触摸接受事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

//询问delegate是否同时接受两个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//询问delegate是否允许手势接受者接受一个Touch对象
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
