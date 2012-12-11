//
//  WordBalloonViewController.m
//  Aico
//
//  Created by Mike on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WordBalloonViewController.h"
#import "Common.h"
#import "ReUnManager.h"
#import "MainViewController.h"
#import <QuartzCore/CALayer.h>
#import "CustomBalloonView.h"
#import "BalloonViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kImageViewWidth             300.0
#define kImageViewHeight            416.0//原来是360.0
#define kHeight                     54.0
#define kWidth                      10.0
#define kBalloonWidth               140.0
#define kBalloonHeight              140.0
#define kWordBalloonTag             49990
#define kRotateButtonViewTag        59990
#define kPanGestureTag              69990
#define kRotateAndZoomImageViewTag  787878

@implementation WordBalloonViewController
@synthesize currentImageView = currentImageView_;
@synthesize sourcePicture = sourcePicture_;
@synthesize cancelBtn = cancelBtn_;
@synthesize confirmBtn = confirmBtn_;
@synthesize balloonView = balloonView_;
@synthesize panGestureRecognizer = panGestureRecognizer_;
@synthesize balloonArray = balloonArray_;
@synthesize actionSheet = actionSheet_;
@synthesize selectedBalloonTag = selectedBalloonTag_;
@synthesize rotateAndZoomImageView = rotateAndZoomImageView_;

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
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgImage.png"]];
    [self.view insertSubview:bgImageView 
                     atIndex:0];
    [bgImageView release];
    
    //添加导航栏
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"预览";
    self.navigationController.navigationBarHidden = NO;
    
    //添加导航栏上取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"backIcon.png"] 
               forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(cancelOperation)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
    
    //添加导航栏上确定按钮
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] 
                forState:UIControlStateNormal];
    [confirmBtn addTarget:self 
                   action:@selector(confirmOperation) 
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
    
    //获取源图片，并且让它适应显示在屏幕上
    self.sourcePicture = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
    float originX;
    float originY;
    float imageViewWidth;
    float imageViewHeight;
    if (self.sourcePicture.size.width/self.sourcePicture.size.height >= kImageViewWidth/kImageViewHeight)
    {
        originX = kWidth;
        imageViewWidth = kImageViewWidth;
        imageViewHeight = kImageViewWidth*self.sourcePicture.size.height/self.sourcePicture.size.width;
        originY = kHeight + (kImageViewHeight - imageViewHeight)/2;
    }
    else
    {
        originY = kHeight;
        imageViewWidth = kImageViewHeight*self.sourcePicture.size.width/self.sourcePicture.size.height;
        imageViewHeight = kImageViewHeight;
        originX = kWidth + (kImageViewWidth - imageViewWidth)/2;
    }
    currentImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originY, imageViewWidth, imageViewHeight)];
    
    self.currentImageView.image = self.sourcePicture;
    [self.currentImageView setClipsToBounds:YES];
    [self.currentImageView setUserInteractionEnabled:YES];
    [self.view addSubview:self.currentImageView];
    
    
    //初始化balloon array
    balloonArray_ = [[NSMutableArray alloc]initWithCapacity:0];
    
    theNumberOfBalloonsCreated_ = 0;

   
    //拖动balloon的手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self 
                                                                                action:@selector(doPan:)];
    self.panGestureRecognizer = panGesture;
    [panGesture release];

    //长按后弹出的actionsheet
    actionSheet_ = [[UIActionSheet alloc] initWithTitle:@"" 
                                               delegate:self 
                                      cancelButtonTitle:nil
                                 destructiveButtonTitle:@"编辑"
                                      otherButtonTitles:@"删除",@"取消" ,nil];
    self.actionSheet.destructiveButtonIndex = 1;
    
    //拖动可以让泡泡旋转
    rotateAndZoomImageView_ = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.rotateAndZoomImageView.image = [UIImage imageNamed:@"insertBtn.png"];
    [self.rotateAndZoomImageView setUserInteractionEnabled:YES];
    [self.currentImageView addSubview:self.rotateAndZoomImageView];
    [self.rotateAndZoomImageView setHidden:YES];
    self.rotateAndZoomImageView.tag = kRotateAndZoomImageViewTag;
    
    balloonsOnView_ = 0;
}

- (void)viewDidUnload
{
    self.currentImageView = nil;
    self.sourcePicture = nil;
    self.cancelBtn = nil;
    self.confirmBtn = nil;
    self.panGestureRecognizer = nil;
    self.balloonArray = nil;
    self.actionSheet = nil;
    self.rotateAndZoomImageView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    self.currentImageView = nil;
    self.sourcePicture = nil;
    self.cancelBtn = nil;
    self.confirmBtn = nil;
    self.panGestureRecognizer =  nil;
    self.balloonArray = nil;
    self.actionSheet = nil;
    self.rotateAndZoomImageView = nil;
    
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 手势
/**
 * @brief  拖动泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)doPan:(UIPanGestureRecognizer *)recognizer
{
    //下面这段代码考虑到了浮点数越界问题（泡泡会莫名消失的问题）
    CGPoint translation0 = [recognizer translationInView:self.currentImageView];
    CGPoint translation1 = [recognizer translationInView:self.view];
    if (isnan(translation0.x)||isnan(translation0.y)||isnan(translation1.x)||isnan(translation1.y))
    {
        return;
    }
    
    CGPoint translation = [recognizer translationInView:self.currentImageView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.currentImageView];
    selectedBalloonTag_ = recognizer.view.tag;
    
    CustomBalloonView *balloonView = (CustomBalloonView *)recognizer.view;
    self.rotateAndZoomImageView.center = [balloonView convertPoint:balloonView.rotateButtonView.center toView:self.currentImageView];
    
    //不让泡泡的中心超出边界
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled ||
             recognizer.state == UIGestureRecognizerStateFailed ||
             recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint balloonCenter = recognizer.view.center;
        CGPoint buttonCenter = self.rotateAndZoomImageView.center;
        if (balloonCenter.x < 0)
        {
            buttonCenter.x = buttonCenter.x - balloonCenter.x;
            balloonCenter.x = 0;
        }
        if (balloonCenter.x > self.currentImageView.frame.size.width)
        {
            buttonCenter.x = buttonCenter.x - (balloonCenter.x - self.currentImageView.frame.size.width);
            balloonCenter.x = self.currentImageView.frame.size.width;
        }
        if (balloonCenter.y < 0)
        {
            buttonCenter.y = buttonCenter.y - balloonCenter.y;
            balloonCenter.y = 0;
        }
        if (balloonCenter.y > self.currentImageView.frame.size.height)
        {
            buttonCenter.y = buttonCenter.y - (balloonCenter.y - self.currentImageView.frame.size.height);
            balloonCenter.y = self.currentImageView.frame.size.height;
        }
        [UIView beginAnimations:@"ImagePounceBack" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        recognizer.view.center = balloonCenter;
        self.rotateAndZoomImageView.center = buttonCenter;
        [UIView commitAnimations];
    }
}

/**
 * @brief  长按泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)doLongPress:(UILongPressGestureRecognizer *)recognizer
{
    selectedBalloonTag_ = recognizer.view.tag;
    [self.actionSheet showInView:self.view];
}

#pragma mark - Public Method

/**
 * @brief  返回上个页面，继而可以选择添加泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)cancelOperation
{
    //将BalloonViewController恢复原样
    NSArray *viewController = self.navigationController.viewControllers;
    BalloonViewController *balloonViewController = [viewController objectAtIndex:([viewController count] - 2)];
    balloonViewController.balloonImageView.image = [UIImage imageNamed:@"balloon1.png"];
    balloonViewController.wordBalloonName = @"balloon1.png";
    balloonViewController.label.text = @"ABC";
    balloonViewController.label.frame = CGRectMake(23, 50, 92, 53);
    balloonViewController.textField.text = @"";
    [balloonViewController.textField resignFirstResponder];
    balloonViewController.isNewBalloon = YES;
    balloonViewController.isFromStickerList = NO;
    balloonViewController.label.font = [UIFont systemFontOfSize:40.0f];
    balloonViewController.fontSize = 40.0;
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * @brief  保存图片，回到首页
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)confirmOperation
{
    if (balloonsOnView_ == 0)
    {
        NSArray *viewController = self.navigationController.viewControllers;
        [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 4)] animated:YES];
        return;
    }
//    if (self.balloonArray != nil)
//    {
//        for (int i = 0; i < [self.balloonArray count]; i++) 
//        {
//            CustomBalloonView *balloonView = [self.balloonArray objectAtIndex:i];
//            [balloonView.sublayer setHidden:YES];
//        }
    CustomBalloonView *balloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
    if (balloonView != nil)
    {
        [balloonView.sublayer setHidden:YES];
    }
//    }
    [self.rotateAndZoomImageView setHidden:YES];
    UIImage *currentImage = nil;
    
    if (self.currentImageView.image.size.width<=150 && 
        self.currentImageView.image.size.height<=150) 
    {
            UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
    }
    else
    {
    UIGraphicsBeginImageContextWithOptions(self.currentImageView.bounds.size, NO, self.currentImageView.image.size.width/self.currentImageView.bounds.size.width) ; 
    }
    
    [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
	currentImage = UIGraphicsGetImageFromCurrentImageContext();	
	UIGraphicsEndImageContext();
    [[ReUnManager sharedReUnManager] storeImage:currentImage];
    NSArray *viewController = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(MainViewController *)[viewController objectAtIndex:([viewController count] - 4)] animated:YES];//?
    
}



/**
 * @brief  计算放大倍数
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (CGFloat)makeScale:(CGPoint)origin beginPoint:(CGPoint)begin andEndPoint:(CGPoint)end
{
    CGFloat original = 1.0;
    if (begin.x==origin.x&&begin.y==origin.y)
    {
        original = 1.0;
    }
    else
    {
        original = sqrtf((begin.x-origin.x)*(begin.x-origin.x) + (begin.y-origin.y)*(begin.y-origin.y));
    }
    CGFloat now = sqrtf((end.x-origin.x)*(end.x-origin.x) + (end.y-origin.y)*(end.y-origin.y));
    return now/original;
}

/**
 * @brief  计算旋转角度
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (CGFloat)makeRotate:(CGPoint)origin withBegin:(CGPoint) begin andEnd:(CGPoint) end
{
    //考虑斜率无限大问题
    if (origin.x == begin.x) 
    {
        if (origin.x==end.x || 
            end.y==origin.y || 
            origin.y==begin.y) 
        {
            return 0.0;
        }
        //成90度问题，此时tan值无限大/小
        else if (end.y==origin.y)
        {
            if ((end.x>origin.x&&begin.y>origin.y)||
                (end.x<origin.x&&begin.y<origin.y))
            {
                return M_PI/2;
            }
            else if ((end.x>origin.x&&begin.y<origin.y)||
                     (end.x<origin.x&&begin.y>origin.y))
            {
                return -M_PI/2;
            }
            return M_PI/2;
        }
        else
        {
            CGFloat tanA = (end.x-origin.x)/(end.y-origin.y);
            return atanf(tanA);
        }
    }
    if (origin.x == end.x) 
    {
        if (origin.x==begin.x ||
            end.y==origin.y ||
            begin.y==origin.y) 
        {
            return 0.0;
        }
        //成90度问题，此时tan值无限大/小
        else if (begin.y==origin.y)
        {
            if ((end.y>origin.y&&begin.x<origin.x)||
                (end.y<origin.y&&begin.x>origin.x))
            {
                return M_PI/2;
            }
            else if ((end.y>origin.y&&begin.x>origin.x)||
                     (end.y<origin.y&&begin.x<origin.x))
            {
                return -M_PI/2;
            }
            return M_PI/2;
        }
        else
        {
            CGFloat tanA = (begin.x-origin.x)/(begin.y-origin.y);
            return atanf(tanA);
        }
    }
    
    CGFloat k1 = (begin.y-origin.y)/(begin.x-origin.x);
    CGFloat k2 = (end.y-origin.y)/(end.x-origin.x);
    
    CGFloat tanA = (k2-k1)/(1+k1*k2);
    return atanf(tanA);
}

/**
 * @brief  添加一个新的泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (BOOL)addWordBalloon
{
    if (self.balloonArray != nil)
    {
        for (int i = 0; i < [self.balloonArray count]; i++)
        {
            CustomBalloonView *balloonView = [self.balloonArray objectAtIndex:i];
            [balloonView.sublayer setHidden:YES];
        }
    }
    
    float imageViewWidth;
    float imageViewHeight;
    if (self.sourcePicture.size.width/self.sourcePicture.size.height >= kImageViewWidth/kImageViewHeight)
    {
        imageViewWidth = kImageViewWidth;
        imageViewHeight = kImageViewWidth*self.sourcePicture.size.height/self.sourcePicture.size.width;
    }
    else
    {
        imageViewWidth = kImageViewHeight*self.sourcePicture.size.width/self.sourcePicture.size.height;
        imageViewHeight = kImageViewHeight;
    }
    
    CustomBalloonView *balloonView = [[CustomBalloonView alloc]initWithFrame:CGRectMake(imageViewWidth/2 - kBalloonWidth/2, imageViewHeight/2 - kBalloonHeight/2, kBalloonWidth, kBalloonHeight)];
    balloonView.tag = kWordBalloonTag + theNumberOfBalloonsCreated_;
    balloonView.rotateButtonView.tag = kRotateButtonViewTag + theNumberOfBalloonsCreated_;
    
    selectedBalloonTag_ = kWordBalloonTag + theNumberOfBalloonsCreated_;
    
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc]initWithTarget:self 
                                                                         action:@selector(doPan:)];
    
    [balloonView addGestureRecognizer:pgr];
    [pgr release];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self 
                                                                                      action:@selector(doLongPress:)];
    [balloonView addGestureRecognizer:lpgr];
    [lpgr release];
    [self.currentImageView addSubview:balloonView];
    [self.balloonArray addObject:balloonView];
    [balloonView release];
    theNumberOfBalloonsCreated_++;
    
    self.rotateAndZoomImageView.center = [balloonView convertPoint:balloonView.rotateButtonView.center
                                                            toView:self.currentImageView];
    [self.rotateAndZoomImageView setHidden:NO];
    [self.currentImageView bringSubviewToFront:self.rotateAndZoomImageView];
    
    balloonsOnView_++;
    return YES;
}

- (void)savePicture
{
    CustomBalloonView *balloonView = nil;
    {
        
        [balloonView.sublayer setHidden:YES];
        [self.rotateAndZoomImageView setHidden:YES];
        UIImage *currentImage = nil;
        UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
        [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        currentImage = UIGraphicsGetImageFromCurrentImageContext();	
        UIGraphicsEndImageContext();
        [[ReUnManager sharedReUnManager] storeSnap:currentImage];
        
    }
    [balloonView.sublayer setHidden:NO];
    [self.rotateAndZoomImageView setHidden:NO];
}

#pragma mark - touchesBegan, Moved, End

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    int count = 0;
    if (self.balloonArray != nil)
    {
        //判断当前点击位置是否是空白处
        for (int i = 0; i < [self.balloonArray count]; i++) 
        {
            CustomBalloonView *balloonView = [self.balloonArray objectAtIndex:i];
            if (touch.view.tag == balloonView.tag)
            {
                break;
            }
            count++;
        }
        if (count < [self.balloonArray count] || touch.view.tag == kRotateAndZoomImageViewTag)
        {
            isBlank_ = NO;
        }
        else
        {
            isBlank_ = YES;
            return;
        }
    }
    
    
    if (self.balloonArray != nil)
    {
        //全部泡泡的边框，按钮隐藏
        for (int i = 0; i < [self.balloonArray count]; i++) 
        {
            CustomBalloonView *balloonView = [self.balloonArray objectAtIndex:i];
            [balloonView.sublayer setHidden:YES];
        }
        [self.rotateAndZoomImageView setHidden:YES];
        
        
        for (int i = 0; i < [self.balloonArray count]; i++)
        {
            CustomBalloonView *balloonView = [self.balloonArray objectAtIndex:i];
            
            if (touch.view.tag == kRotateAndZoomImageViewTag)//是旋转放缩按钮
            {
                for ( UIGestureRecognizer *pgr in balloonView.gestureRecognizers)
                {
                    if ([pgr isKindOfClass:[UIPanGestureRecognizer class]])
                    {
                        //给选中的旋转按钮对应的泡泡移除拖动手势,因为这回影响旋转放缩
                        self.panGestureRecognizer = (UIPanGestureRecognizer *)pgr;
                        [balloonView removeGestureRecognizer:pgr];
                        break;
                    }
                    
                }
                begPoint_ = [touch locationInView:self.currentImageView];
                inBalloon_ = YES;
                //将选中的泡泡移到最上层
                CustomBalloonView *customBalloonViewTmp = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
                [self.currentImageView bringSubviewToFront:customBalloonViewTmp];
                
                printf("begin：点击的是旋转按钮\n");
                break;
            }
            if (touch.view.tag != balloonView.tag)//不是泡泡
            {
                [balloonView.sublayer setHidden:YES];
                printf("begin：点击的是空白处\n");
            }
            else
            {
                [balloonView.sublayer setHidden:NO];
                selectedBalloonTag_ = touch.view.tag;
                //将选中的泡泡移到最上层
                CustomBalloonView *customBalloonViewTmp = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
                [self.currentImageView bringSubviewToFront:customBalloonViewTmp];
                
                self.rotateAndZoomImageView.center = [balloonView convertPoint:balloonView.rotateButtonView.center toView:self.currentImageView];
                [self.rotateAndZoomImageView setHidden:NO];
                [self.currentImageView bringSubviewToFront:self.rotateAndZoomImageView];
                
                printf("begin:点击的是气泡\n");
                break;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CustomBalloonView *balloonView = nil;
    balloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
    
    
    UITouch *touch = [touches anyObject];
    if (inBalloon_)
    {
        printf("move:点击的是旋转按钮");
        curPoint_ = [touch locationInView:self.currentImageView];
        
        CGFloat angle = [self makeRotate:balloonView.center withBegin:begPoint_ andEnd:curPoint_];
        CGFloat scale = [self makeScale:balloonView.center beginPoint:begPoint_ andEndPoint:curPoint_];
        
        balloonView.transform = CGAffineTransformScale(CGAffineTransformRotate(balloonView.transform, angle), scale, scale);
        
        begPoint_ = curPoint_;
        
        
        //        /*******当前的每次计算旋转角度都会出现正常的误差，这种误差一般用户分辨不出，但是长时间操作可能会让用户发现，
        //         所以需要二次对切图和图钉位置进行调整，但是二次更正也有可能使误差增大，今后如有更好办法需要删除此段**************/        
        //        //切图和图钉位置进行更正
        
        CGPoint deleteBtnCenter = [balloonView convertPoint:balloonView.deleteButton.center 
                                                     toView:self.currentImageView];
        printf("delete:%f,%f\n",deleteBtnCenter.x,deleteBtnCenter.y);
        btnPointFirst_ = [balloonView convertPoint:balloonView.rotateButtonView.center 
                                           toView:self.currentImageView];
        printf("rotate:%f,%f\n",btnPointFirst_.x,btnPointFirst_.y);
        printf("current:%f,%f\n\n",curPoint_.x,curPoint_.y);
        CGFloat angle1 = [self makeRotate:balloonView.center 
                                withBegin:btnPointFirst_
                                   andEnd:curPoint_];
        balloonView.transform = CGAffineTransformRotate(balloonView.transform, angle1);
        
        if ((pow(curPoint_.x-deleteBtnCenter.x, 2)+pow(curPoint_.y-deleteBtnCenter.y, 2))<(pow(curPoint_.x-btnPointFirst_.x, 2)+pow(curPoint_.y-btnPointFirst_.y, 2)))
        {
            balloonView.transform = CGAffineTransformRotate(balloonView.transform, M_PI);
        }
        
        self.rotateAndZoomImageView.center = balloonView.rotateButtonView.center;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CustomBalloonView *balloonView = nil;
    if (!isBlank_)
    {
//        balloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
//        [balloonView addGestureRecognizer:self.panGestureRecognizer];
//        [balloonView.firstLine setHidden:NO];
//        [balloonView.secondLine setHidden:NO];
//        [balloonView.thirdLine setHidden:NO];
//        [balloonView.fourthLine setHidden:NO];
//        
//        self.rotateAndZoomImageView.center = [balloonView convertPoint:balloonView.rotateButtonView.center toView:self.currentImageView];
//        [self.rotateAndZoomImageView setHidden:NO];
//        [self.currentImageView bringSubviewToFront:self.rotateAndZoomImageView];
        
        [balloonView.sublayer setHidden:YES];
        [self.rotateAndZoomImageView setHidden:YES];
        UIImage *currentImage = nil;
        UIGraphicsBeginImageContext(self.currentImageView.bounds.size);
        [self.currentImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        currentImage = UIGraphicsGetImageFromCurrentImageContext();	
        UIGraphicsEndImageContext();
        [[ReUnManager sharedReUnManager] storeSnap:currentImage];
        
    }
    else
    {
        balloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
        [balloonView addGestureRecognizer:self.panGestureRecognizer];
        [balloonView.sublayer setHidden:YES];
        
        self.rotateAndZoomImageView.center = [balloonView convertPoint:balloonView.rotateButtonView.center
                                                                toView:self.currentImageView];
        [self.rotateAndZoomImageView setHidden:YES];
        [self.currentImageView bringSubviewToFront:self.rotateAndZoomImageView];
    }
    
    if (!isBlank_)
    {
        balloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
        [balloonView addGestureRecognizer:self.panGestureRecognizer];
        [balloonView.sublayer setHidden:NO];
        
        self.rotateAndZoomImageView.center = [balloonView convertPoint:balloonView.rotateButtonView.center 
                                                                toView:self.currentImageView];
        [self.rotateAndZoomImageView setHidden:NO];
        [self.currentImageView bringSubviewToFront:self.rotateAndZoomImageView];
    }
    inBalloon_ = NO;
    
    NSLog(@"end");
}

#pragma mark - actionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) 
    {
        case 0://编辑，跳到选择泡泡页面，修改文字。。。
        {
            CustomBalloonView *customBalloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
            NSLog(@"%d",selectedBalloonTag_);
            BalloonViewController *balloonViewController = [[BalloonViewController alloc]init];
            
            [self.navigationController pushViewController:balloonViewController 
                                                 animated:YES];
            balloonViewController.isNewBalloon = NO;
            balloonViewController.textField.text = customBalloonView.label.text;
            balloonViewController.label.text = customBalloonView.label.text;
            balloonViewController.label.textColor = customBalloonView.label.textColor;
            balloonViewController.label.font = customBalloonView.label.font;
            NSString *balloonName = @"balloon";
            balloonName = [balloonName stringByAppendingFormat:@"%d.png",(customBalloonView.balloonStyle+1)];
            balloonViewController.wordBalloonName = balloonName;
            balloonViewController.balloonStyle = customBalloonView.balloonStyle;
            balloonViewController.balloonImageView.image = [UIImage imageNamed:balloonName];
            balloonViewController.label.frame = customBalloonView.label.frame;
            [balloonViewController release];
        }
            break;
        case 1://删除泡泡
        {
            CustomBalloonView *customBalloonView = (CustomBalloonView *)[self.view viewWithTag:selectedBalloonTag_];
            [customBalloonView deleteBalloon];
            [self.rotateAndZoomImageView setHidden:YES];
            balloonsOnView_--;
            //需要从array中删除。。。
        }
            break;
        default:
            break;
    }
}
@end
