//
//  StickerMainViewController.m
//  Aico
//
//  Created by Yincheng on 12-5-15.
//  Copyright (c) 2012年 x. All rights reserved.
//


#import "StickerMainViewController.h"
#import "MainViewController.h"
#import "ReUnManager.h"
#import "StickerProcess.h"
#import <QuartzCore/QuartzCore.h>
#import "StickerMenuViewController.h"

#define kDefaultCenter  CGPointMake(imageView_.bounds.origin.x+imageView_.bounds.size.width/2,imageView_.bounds.origin.y+imageView_.bounds.size.height/2)
#define kDefaultBackgroundTag 9998
#define kDefaultButtonTag 9999

static StickerProcess *g_stickerProcess = nil;

//*****************StickerMainViewController private methods************//
@interface  StickerMainViewController()
- (void)initNavigation;
- (void)updateGlobalStickerProcess;
- (void)initSticker;
- (CGPoint)currentButtonPosition;
- (void)resetButtonPosition;
- (void)reloadGloblaSticker:(NSNotification *)notification;
- (void)btnViewHidden;
- (BOOL)beyondImageView:(CGPoint)point;
- (void)resetButtonIfBeyondImageView;
- (void)updateImageSnap:(NSNotification *)notification;
@end
//**********************************************************************//

@implementation StickerMainViewController

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
/**
 * @brief 导航栏初始化 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initNavigation
{
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.png"]]];
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"预览";
    
    //添加返回按钮
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, -5, 30, 30)];
    [returnBtn setImage:[UIImage imageNamed:@"backIcon.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self 
                  action:@selector(returnButtonPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBarBtn = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = returnBarBtn;
    [returnBtn release];
    [returnBarBtn release];
    
    //添加确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:kEffectConfirmButtonFrameRect];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
}

/**
 * @brief 更新g_stickerProcess(最先响应的装饰)
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)updateGlobalStickerProcess
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    g_stickerProcess = nil;
    if ([rm.stickerArray count]>0) 
    {
        NSInteger ptag = [[[rm.stickerArray lastObject] objectForKey:kStickerDefaultTag] intValue];
        NSLog(@"tag:%d",ptag);
        g_stickerProcess = (StickerProcess *)[self.view viewWithTag:ptag];
    }
}

/**
 * @brief 初始化装饰图(所有的装饰都在此进行构造)
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initSticker
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    NSLog(@"rm.stickerArray %d",[rm.stickerArray count]);
    if ([rm.stickerArray count]<1) 
    {
        // error 
    }
    else if ([rm.stickerArray count]==1) 
    {
        NSString *imageName = [[rm.stickerArray lastObject] objectForKey:kStickerDefaultImageName];
        NSInteger ptag = [[[rm.stickerArray lastObject] objectForKey:kStickerDefaultTag] intValue];
        StickerProcess *process = [[StickerProcess alloc] initWithImageName:imageName];
        process.center = kDefaultCenter;
        process.tag = ptag;
        process.delegateVC = self;
        process.posType = StickerPositionRightDown;
        [imageView_ addSubview:process];
        [rm replaceStickerWithCenter:process.center andIndex:0];
        [rm replaceStickerWithTransform:process.transform andIndex:0];
        [process release];
    }
    else
    {
        for (int i=0; i<[rm.stickerArray count]; i++) 
        {
            NSString *imageName = [[rm.stickerArray objectAtIndex:i] objectForKey:kStickerDefaultImageName];
            NSArray *cArray = [[rm.stickerArray objectAtIndex:i] objectForKey:kStickerDefaultCenter];
            NSArray *tArray = [[rm.stickerArray objectAtIndex:i] objectForKey:kStickerDefaultTransform];
            NSInteger ptag = [[[rm.stickerArray objectAtIndex:i] objectForKey:kStickerDefaultTag] intValue];
            
            CGPoint stickerCenter = CGPointMake([[cArray objectAtIndex:0] doubleValue], //point.x
                                                [[cArray objectAtIndex:1] doubleValue]);//point.y
            CGAffineTransform stickerTransform = CGAffineTransformMake([[tArray objectAtIndex:0] doubleValue], //a
                                                                       [[tArray objectAtIndex:1] doubleValue], //b
                                                                       [[tArray objectAtIndex:2] doubleValue], //c
                                                                       [[tArray objectAtIndex:3] doubleValue], //d
                                                                       [[tArray objectAtIndex:4] doubleValue], //tx
                                                                       [[tArray objectAtIndex:5] doubleValue]);//ty 
            
            StickerProcess *process = [[StickerProcess alloc] initWithImageName:imageName];
            process.delegateVC = self;
            process.posType = StickerPositionRightDown;
            process.tag = ptag;
            if (i==([rm.stickerArray count]-1)) //lastObject
            {
                process.center = kDefaultCenter;
                [rm replaceStickerWithCenter:process.center andIndex:i];
                [rm replaceStickerWithTransform:process.transform andIndex:i];
            }
            else 
            {
                process.center = stickerCenter;
                process.transform = stickerTransform;
            }
            [imageView_ addSubview:process];
            [process release];
        }
    }
    //更新当前的stickerProcess
    [self updateGlobalStickerProcess];
}

/**
 * @brief 根据g_stickerProcess，获取图钉位置
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (CGPoint)currentButtonPosition
{
    if (g_stickerProcess==nil)
    {
        return CGPointMake(0, 0);
    }
    
    CGPoint point;
    switch (g_stickerProcess.posType) 
    {
        case StickerPositionLeftUp:
        {
            point = CGPointMake(g_stickerProcess.bounds.origin.x,
                                g_stickerProcess.bounds.origin.y);
        }
            break;
        case StickerPositionLeftDown:
        {
            point = CGPointMake(g_stickerProcess.bounds.origin.x,
                                g_stickerProcess.bounds.origin.y+g_stickerProcess.bounds.size.height);
        }
            break;
        case StickerPositionRightUp:
        {
            point = CGPointMake(g_stickerProcess.bounds.origin.x+g_stickerProcess.bounds.size.width,
                                g_stickerProcess.bounds.origin.y);
        }
            break;
        case StickerPositionRightDown:
        {
            point = CGPointMake(g_stickerProcess.bounds.origin.x+g_stickerProcess.bounds.size.width,
                                g_stickerProcess.bounds.origin.y+g_stickerProcess.bounds.size.height);
        }
            break;
        default:
            break;
    }
    return [g_stickerProcess convertPoint:point toView:self.view];
}

/**
 * @brief 重置图钉位置
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)resetButtonPosition
{
    if (g_stickerProcess)
    {
        btnView_.center = [self currentButtonPosition];
    }
    else
    {
        if (btnView_) 
        {
            [btnView_ removeFromSuperview];
            RELEASE_OBJECT(btnView_); 
        }
    }
}

/**
 * @brief 替换装饰图完成后，通知界面刷新
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)reloadGloblaSticker:(NSNotification *)notification
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    NSString *new = [[rm.stickerArray lastObject] objectForKey:kStickerDefaultImageName];
    if (new!=nil && 
        ![new isEqualToString:@""] &&
        g_stickerProcess.imageName!=nil && 
        ![g_stickerProcess.imageName isEqualToString:@""] &&
        ![g_stickerProcess.imageName isEqualToString:new]) 
    {
        g_stickerProcess.delegate = self;
        g_stickerProcess.hidden = YES;
        [g_stickerProcess reloadImage:new];
    }
}
/**************解决装饰替换中，由大图到小图出现的部分区域截断问题，同时解决大部分装饰小图替换大图出现的图片闪动问题*******/
- (void)loadStickerProcessBounds:(StickerProcess *)process
{
    process.hidden = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    StickerProcess *process = (StickerProcess *)webView;
    [self performSelector:@selector(loadStickerProcessBounds:) withObject:process afterDelay:0.2f];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    StickerProcess *process = (StickerProcess *)webView;
    [self performSelector:@selector(loadStickerProcessBounds:) withObject:process afterDelay:0.2f];
}
/**************************************************************************************************/
/**
 * @brief 隐藏图钉
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)btnViewHidden
{
    btnView_.hidden = NO;
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
    point = [g_stickerProcess convertPoint:point toView:imageView_];
    
    if ((point.x>=imageView_.bounds.origin.x) &&
        (point.x<=imageView_.bounds.origin.x+imageView_.bounds.size.width) &&
        (point.y>=imageView_.bounds.origin.y) &&
        (point.y<=imageView_.bounds.origin.y+imageView_.bounds.size.height)) 
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
    if (btnView_.center.x<imageView_.frame.origin.x ||
        btnView_.center.x>imageView_.frame.origin.x+imageView_.frame.size.width ||
        btnView_.center.y<imageView_.frame.origin.y ||
        btnView_.center.y>imageView_.frame.origin.y+imageView_.frame.size.height) 
    {
        NSLog(@"超出边界了哦");
              
        CGPoint pleftUp = CGPointMake(g_stickerProcess.bounds.origin.x,
                                      g_stickerProcess.bounds.origin.y);
        CGPoint prightUP = CGPointMake(g_stickerProcess.bounds.origin.x+g_stickerProcess.bounds.size.width,
                                       g_stickerProcess.bounds.origin.y);
        CGPoint pleftDown = CGPointMake(g_stickerProcess.bounds.origin.x,
                                        g_stickerProcess.bounds.origin.y+g_stickerProcess.bounds.size.height);
        CGPoint prightDown = CGPointMake(g_stickerProcess.bounds.origin.x+g_stickerProcess.bounds.size.width,
                                         g_stickerProcess.bounds.origin.y+g_stickerProcess.bounds.size.height);
        
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
            g_stickerProcess.posType = StickerPositionRightDown;
        }
        else if (![self beyondImageView:pleftDown])
        {
            g_stickerProcess.posType = StickerPositionLeftDown;
        }
        else if (![self beyondImageView:prightUP])
        {
            g_stickerProcess.posType = StickerPositionRightUp;
        }
        else if (![self beyondImageView:pleftUp])
        {
            g_stickerProcess.posType = StickerPositionLeftUp;
        }
    }
    [self resetButtonPosition];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[ReUnManager sharedReUnManager] setIsMagicWand:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigation];
    
    //注册通知，用于在替换装饰图后，界面刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGloblaSticker:) name:kStickerNotificationCenter object:nil];
    //注册通知，用于切后台保存图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageSnap:) name:kMagicWandNotificationEnterBackground object:nil];
    
    UIImage *srcImage = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    imageView_ = [[UIImageView alloc] init];
    imageView_.image = srcImage;
    imageView_.userInteractionEnabled = YES;
    imageView_.tag = kDefaultBackgroundTag;
    [imageView_ setClipsToBounds:YES];
    
    [Common imageView:imageView_ autoFitView:self.view margin:CGPointMake(10, 10)];
    [self.view addSubview:imageView_];
        
#if 0
    //给底图添加伸缩手势    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self 
                                                                                       action:@selector(doPinchBackground:)];
    [imageView_ addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    magnification_ = 1.0;
    backgroundCenter_ = imageView_.center;
#endif
    
    btnView_ = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100, kInsertButtonLen, kInsertButtonLen)];
    btnView_.image = [UIImage imageNamed:@"insertBtn.png"];
    btnView_.userInteractionEnabled = YES;
    btnView_.tag = kDefaultButtonTag;
    [self.view addSubview:btnView_];
    
    [self initSticker];//init stickers
    [self resetButtonPosition];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[ReUnManager sharedReUnManager] setIsMagicWand:NO];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    RELEASE_OBJECT(imageView_);
    RELEASE_OBJECT(btnView_);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)dealloc
{
    RELEASE_OBJECT(imageView_);
    RELEASE_OBJECT(btnView_);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

/**
 * @brief 返回按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnButtonPressed:(id)sender
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    rm.snapImage = nil;
    if ([rm.stickerArray count]<1) 
    {
        g_stickerProcess = nil; 
    }
    else
    {
        for (int i=0; i<[rm.stickerArray count]; i++) 
        {
            NSInteger ptag = [[[rm.stickerArray objectAtIndex:i] objectForKey:kStickerDefaultTag] intValue];
            StickerProcess *process = (StickerProcess *)[self.view viewWithTag:ptag];
            [rm replaceStickerWithCenter:process.center andIndex:i];
            [rm replaceStickerWithTransform:process.transform andIndex:i];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief 确认按钮处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)confirmButtonPressed:(id)sender
{
    //获取当前图片，并保存下来。如果此时页面没有装饰图，image为nil  
    UIImage *image = [self mergeImage];
    
    NSLog(@"image size is :%f,%f",image.size.width,image.size.height);
    
    if (image) 
    {
        [[ReUnManager sharedReUnManager] storeImage:image];
    }

    //一旦进行保存，需要将之前装饰操作清除
    [[ReUnManager sharedReUnManager] clearAllStickers];
    
    //跳转到美化图片页面
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 4)] animated:YES];
}

/**
 * @brief 截取当前视图，获得图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)mergeImage
{
    NSLog(@"imageView:%f,%f----SrcImage:%f,%f ",imageView_.bounds.size.width,imageView_.bounds.size.height,imageView_.image.size.width,imageView_.image.size.height);
    if (g_stickerProcess==nil) {
        return nil;
    }
    UIImage *currentImage = nil;
    /*
       分为两种情况进行:如果底图像素小于150*150,那么为了防止装饰贴图模糊，将按照imageView_.bounds.size进行裁剪，裁剪完的图片像素为imageView_.bounds.size;否则将保持底图图像像素不变
    */
    if (imageView_.image.size.width<=150 && imageView_.image.size.height<=150)
    {
        UIGraphicsBeginImageContext(imageView_.bounds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(imageView_.bounds.size, NO, imageView_.image.size.width/imageView_.bounds.size.width) ;
    }
    [imageView_.layer renderInContext:UIGraphicsGetCurrentContext()];
	currentImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
    
        return currentImage;
}

/**
 * @brief 切换后台，通知页面保存当前图片 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)updateImageSnap:(NSNotification *)notification
{
    UIImage *image = [self mergeImage];
    if (image)
    {
        [[ReUnManager sharedReUnManager] storeSnap:image];
        [[ReUnManager sharedReUnManager] saveMagicWandView];
    }
}

#if 0
//底图缩放手势，原图不能进行缩小
- (void)doPinchBackground:(UIPinchGestureRecognizer *)recognizer
{
    //最大放大8倍，缩小4倍
    if ((magnification_*recognizer.scale > 8 && recognizer.scale > 1 )||
        (magnification_*recognizer.scale < 1 && recognizer.scale < 1))
    {
        return;
    }
    magnification_ = magnification_*recognizer.scale;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;    
    [self resetButtonPosition];
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当前不支持多点触摸，多点触摸只有放缩手势
    if ([[event allTouches]count]>1)
    {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    //触摸在旋转图钉上，对相应的装饰图片进行操作
    if (touch.view.tag == kDefaultButtonTag) 
    {
    }
    //触摸在背景图片上
    else if (touch.view.tag == kDefaultBackgroundTag)
    {
        btnView_.hidden = YES;
    }
    //触摸在装饰图片上
    else 
    {
        btnView_.hidden = YES;
        //如果此装饰图片未被激活，则需要进行激活操作
        if (g_stickerProcess.tag != touch.view.tag) 
        {
            ReUnManager *rm = [ReUnManager sharedReUnManager];
            for (int i=0; i<[rm.stickerArray count]; i++) 
            {
                int ptag = [[[rm.stickerArray objectAtIndex:i] objectForKey:kStickerDefaultTag] intValue];
                if (ptag == touch.view.tag) 
                {
                    NSMutableDictionary *dict = [rm.stickerArray objectAtIndex:i];
                    [rm.stickerArray addObject:dict];
                    [rm.stickerArray removeObjectAtIndex:i];
                                        
                    //更新全局sticker
                    [self updateGlobalStickerProcess];
                    
                    [self resetButtonPosition];
                    [imageView_ bringSubviewToFront:touch.view];
                    break;
                }
            }
        }
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
    
    //点击图钉进行旋转
    if (touch.view.tag == kDefaultButtonTag)
    {
        begPoint_ = [touch previousLocationInView:imageView_];
        curPoint_ = [touch locationInView:imageView_];
        CGPoint pointTmp = [touch locationInView:self.view];
        
        btnView_.center = pointTmp;
        
        CGFloat angle = [Common makeRotate:g_stickerProcess.center withBegin:begPoint_ andEnd:curPoint_];
        CGFloat scale = [Common makeScale:g_stickerProcess.center beginPoint:begPoint_ andEndPoint:curPoint_];
        g_stickerProcess.transform = CGAffineTransformScale(CGAffineTransformRotate(g_stickerProcess.transform, angle), scale, scale);
                
        //位置二次更新，减小误差
        CGPoint first = [self.view convertPoint:[self currentButtonPosition] toView:imageView_];
        CGPoint last = curPoint_;
        CGFloat angle1 = [Common makeRotate:g_stickerProcess.center withBegin:first andEnd:last];
        CGFloat scale1 = [Common makeScale:g_stickerProcess.center beginPoint:first andEndPoint:last];
        g_stickerProcess.transform = CGAffineTransformScale(CGAffineTransformRotate(g_stickerProcess.transform, angle1), scale1, scale1);
        
    }
    else if (touch.view.tag == kDefaultBackgroundTag)
    {
#if 0    
        begPoint_ = [touch previousLocationInView:self.view];
        curPoint_ = [touch locationInView:self.view];
        imageView_.center = CGPointMake(imageView_.center.x+curPoint_.x-begPoint_.x,
                                        imageView_.center.y+curPoint_.y-begPoint_.y);
#endif
    }
    else 
    {
        if (g_stickerProcess.tag == touch.view.tag)
        {
            begPoint_ = [touch previousLocationInView:imageView_];
            curPoint_ = [touch locationInView:imageView_];
            CGPoint newCenter = CGPointMake(g_stickerProcess.center.x+curPoint_.x-begPoint_.x,
                                            g_stickerProcess.center.y+curPoint_.y-begPoint_.y);
            NSLog(@"newCenter:%f,%f--",newCenter.x,newCenter.y);
            g_stickerProcess.center = newCenter;
            [self resetButtonPosition];
        }
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //当前不支持多点触摸，多点触摸只有放缩手势
    if ([[event allTouches]count]>1)
    {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if (touch.view.tag == kDefaultButtonTag)
    {
        [self resetButtonPosition];
        [[ReUnManager sharedReUnManager] replaceLastStickerWithTransform:g_stickerProcess.transform];
    }
    else if (touch.view.tag == kDefaultBackgroundTag)
    {
#if 0
        [UIView beginAnimations:@"BackgroundImageComeBack" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        imageView_.center = backgroundCenter_;
        [UIView commitAnimations];
#endif
        [self performSelector:@selector(btnViewHidden) withObject:nil afterDelay:0.25];
    }
    else 
    {
        if (g_stickerProcess.tag == touch.view.tag)
        {
            //装饰图越界，加入动画
            if (g_stickerProcess.center.x<=imageView_.bounds.origin.x ||
                g_stickerProcess.center.x>=imageView_.bounds.origin.x+imageView_.bounds.size.width ||
                g_stickerProcess.center.y<=imageView_.bounds.origin.y ||
                g_stickerProcess.center.y>=imageView_.bounds.origin.y+imageView_.bounds.size.height) 
            {
                CGPoint newCenter = g_stickerProcess.center;
                if (g_stickerProcess.center.x<=0 && g_stickerProcess.center.y<0) 
                {
                    //左上点
                    newCenter = imageView_.bounds.origin;
                }
                else if (g_stickerProcess.center.x<=0 && g_stickerProcess.center.y>=imageView_.bounds.size.height) 
                {
                    //左下点
                    newCenter = CGPointMake(0, imageView_.bounds.size.height);
                }
                else if (g_stickerProcess.center.x>=imageView_.bounds.size.width && g_stickerProcess.center.y>=imageView_.bounds.size.height) 
                {
                    //右下点
                    newCenter = CGPointMake(imageView_.bounds.size.width, imageView_.bounds.size.height);
                }
                else if (g_stickerProcess.center.x>=imageView_.bounds.size.width && g_stickerProcess.center.y<=0)
                {
                    //右上点
                    newCenter = CGPointMake(imageView_.bounds.size.width, 0);
                }
                else if (g_stickerProcess.center.x>0 && g_stickerProcess.center.x<imageView_.bounds.size.width &&g_stickerProcess.center.y<0) 
                {
                    //上边
                    newCenter = CGPointMake(g_stickerProcess.center.x, 0);
                }
                else if (g_stickerProcess.center.x>0 && g_stickerProcess.center.x<imageView_.bounds.size.width &&g_stickerProcess.center.y>imageView_.bounds.size.height) 
                {
                    //下边
                    newCenter = CGPointMake(g_stickerProcess.center.x, imageView_.bounds.size.height);
                }
                else if (g_stickerProcess.center.x<0 && g_stickerProcess.center.y>0 && g_stickerProcess.center.y<imageView_.bounds.size.height)
                {
                    //左边
                    newCenter = CGPointMake(0, g_stickerProcess.center.y);
                }
                else if (g_stickerProcess.center.x>imageView_.bounds.size.width && g_stickerProcess.center.y>0 && g_stickerProcess.center.y<imageView_.bounds.size.height)
                {
                    //右边
                    newCenter = CGPointMake(imageView_.bounds.size.width, g_stickerProcess.center.y);
                }
                [UIView beginAnimations:@"ImageCenterComeBack" context:nil];
                [UIView setAnimationDuration:0.2];
                [UIView setAnimationBeginsFromCurrentState:YES];
                g_stickerProcess.center = newCenter;
                [UIView commitAnimations];
            }
            [self resetButtonIfBeyondImageView];
            [self performSelector:@selector(btnViewHidden) withObject:nil afterDelay:0.25];
            [[ReUnManager sharedReUnManager] replaceLastStickerWithCenter:g_stickerProcess.center];
        }
    }
}

/**
 * @brief 长按装饰图，弹出菜单
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)showStickerSheet:(NSInteger)stag
{
    NSLog(@"do showSticker:%d",stag);
    
    UIActionSheet *listSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:@"替换"
                                    otherButtonTitles:@"删除",@"取消" ,nil];
    listSheet.destructiveButtonIndex = 1;
    [listSheet showInView:self.view];
    [listSheet release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 0://replace
        {
            StickerMenuViewController *menuVC = [[StickerMenuViewController alloc] init];
            menuVC.isStickerReplace = YES;
            [self.navigationController pushViewController:menuVC animated:YES];
            [menuVC release];
        }
            break;
        case 1://delete
        {
            int stag = g_stickerProcess.tag;
            [g_stickerProcess removeFromSuperview];
            g_stickerProcess = nil;
            [[ReUnManager sharedReUnManager] delOneStickerToArray:stag];
            [self updateGlobalStickerProcess];
            [self resetButtonPosition];
        }
            break;
        default:
            break;
    }
}

#pragma mark -GestureRecognizer 
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
