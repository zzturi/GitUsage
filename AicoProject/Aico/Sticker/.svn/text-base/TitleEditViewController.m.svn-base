//
//  TitleEditViewController.m
//  Aico
//
//  Created by 勇 周 on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TitleEditViewController.h"
#import "ReUnManager.h"
#import "FXLabel.h"
#import "TitleViewController.h"
#import "CGPointExtension.h"

#define kImageViewRotateSize	20
#define kDefaultTagImageView    7998
#define kDefaultTagButton       7999
#define kTitleTagOffset			8000

//定义全局文字视图，用于标记当前第一响应的文字视图
//static UIView *viewCurrentEdit_ = nil;

@implementation TitleEditViewController

@synthesize viewCurrentEdit	= viewCurrentEdit_;

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

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImage.png"]];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    //添加导航栏
    [Common setNavigationBarBackgroundBkg:self.navigationController.navigationBar];
    self.navigationItem.title = @"预览";
    self.navigationController.navigationBarHidden = NO;
    
    [self initNavigatinBarButtons];
    
    imageView_ = [[UIImageView alloc] init];
    imageView_.image = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
	imageView_.userInteractionEnabled = YES;
    imageView_.clipsToBounds = YES;
    imageView_.tag = kDefaultTagImageView;
    [Common imageView:imageView_ autoFitView:self.view margin:CGPointMake(10, 10)];
    [self.view addSubview:imageView_];
    
    
    //初始化旋转图钉 
    CGRect rect = CGRectMake(0,0, kInsertButtonLen, kInsertButtonLen);
	imageViewRotate_ = [[UIImageView alloc] initWithFrame:rect];
	imageViewRotate_.image = [UIImage imageNamed:@"insertBtn.png"];
    imageViewRotate_.userInteractionEnabled = YES;
    imageViewRotate_.tag = kDefaultTagButton;
    [imageView_ addSubview:imageViewRotate_];
    
    arrViewTag_ = [[NSMutableArray alloc] init];
	
	//注册通知，用于切后台保存图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageSnap) name:kMagicWandNotificationEnterBackground object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[ReUnManager sharedReUnManager] setIsMagicWand:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[ReUnManager sharedReUnManager] setIsMagicWand:NO];
    [super viewWillDisappear:animated];
}

- (void)releaseObjects
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    RELEASE_OBJECT(imageView_);
    RELEASE_OBJECT(imageViewRotate_);
    RELEASE_OBJECT(arrViewTag_);
}

- (void)viewDidUnload
{
    [self releaseObjects];
    [super viewDidUnload];
}
- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark 自定义初始化函数

- (id)initWithParentViewController:(TitleViewController*)vcParent
{
    self = [super init];
    if (self) 
	{
        vcParent_ = vcParent;
    }
    return self;
}

/**
 * @brief 初始化导航栏上的button
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)initNavigatinBarButtons
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"backIcon.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    [cancelBtn release];
    [cancelBarBtn release];
	
	UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [confirmBtn setImage:[UIImage imageNamed:@"confirm.png"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    self.navigationItem.rightBarButtonItem = confirmBarBtn;
    [confirmBarBtn release];
    [confirmBtn release];
}

#pragma mark -
#pragma mark 导航栏按钮响应函数

/**
 * @brief 点击导航栏上的confirm按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)confirmButtonPressed
{
	UIImage *image = [self mergeImage];
	if (image != nil)
	{
		[[ReUnManager sharedReUnManager] storeImage:image];
	}
    
    NSArray *vcArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:(UIViewController *)[vcArray objectAtIndex:([vcArray count] - 4)] animated:YES];
}

/**
 * @brief 点击导航栏上的back按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)backButtonPressed
{	
	vcParent_.operateType = TitleOperateTypeAdd;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 添加，编辑标题

/**
 * @brief 初始化文字，或者是编辑文字
 *
 * @param [in] title: 将要处理的视图
 * @param [in] tag: 视图的标记
 * @param [in] type: 处理的类型: 添加或编辑
 * @param [out]
 * @return 
 * @note 
 */
- (void)addTitle:(FXButton*)title tag:(NSInteger)tag operateType:(int)type
{
	CGSize btnSize = [title.titleLabel.text sizeWithFont:title.titleLabel.font];
		
    FXButton *btn = [[FXButton alloc] initWithFrame:CGRectMake(8, 0, btnSize.width, btnSize.height)];
    btn.titleLabel.text = title.titleLabel.text;
    btn.enabled = NO;    //button中必须将enabled属性设置NO，否则无法响应
    btn.userInteractionEnabled = NO;
    [btn updateFromButton:title fontSize:kTitlePreviewFontSize];
	
    if (type == TitleOperateTypeEdit)		//编辑标题
	{
		CGPoint center = viewCurrentEdit_.center;
		
        if (tag != viewCurrentEdit_.tag)
		{
            viewCurrentEdit_ = (UIView*)[imageView_ viewWithTag:tag];
        }
        //要将之前视图中的文字信息清除
        for (UIView *subview in [viewCurrentEdit_ subviews])
		{
            [subview removeFromSuperview];
        }

		viewCurrentEdit_.bounds = CGRectMake(0, 0, btnSize.width+16, btnSize.height);
		viewCurrentEdit_.center = center;
        [viewCurrentEdit_ insertSubview:btn atIndex:0];
    }
    else if (type == TitleOperateTypeAdd)	//创建新标题
	{
		int newTag = [arrViewTag_ count] == 0 ? kTitleTagOffset : [[arrViewTag_ lastObject] intValue] + 1;
		
        UIView *titleView = [[UIView alloc] init];
		titleView.bounds = CGRectMake(0, 0, btnSize.width+16, btnSize.height);
		titleView.center = CGPointMake(imageView_.bounds.size.width/2, imageView_.bounds.size.height/2);
        titleView.backgroundColor = [UIColor clearColor];
        titleView.tag = newTag;
        [titleView addSubview:btn];
		
        
        if (titleView != nil)
		{
            viewCurrentEdit_ = titleView;
        }
        viewCurrentEdit_.userInteractionEnabled = YES;
        [imageView_ addSubview:viewCurrentEdit_];

        //如果是新建文字视图，需要添加长按手势
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longpress.minimumPressDuration = 0.5f;
        [viewCurrentEdit_ addGestureRecognizer:longpress];
        [longpress release];
        
        [titleView release];
        
        //每成功创建一个文字视图，需要将其tag增加到数组中
        [arrViewTag_ addObject:[NSNumber numberWithInt:newTag]];
    }
	[btn release];
    
    [self resetRotatoButtonCenter];
}

/**
 * @brief 切换后台进行保存当前图片
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateImageSnap
{
    UIImage *image = [self mergeImage];
    if (image)
    {
        [[ReUnManager sharedReUnManager] storeSnap:image];
        [[ReUnManager sharedReUnManager] saveMagicWandView];
    }
}

/**
 * @brief 合成最终图像
 *
 * @param [in] 
 * @param [out]
 * @return 合成后的图片
 * @note 
 */
- (UIImage *)mergeImage
{
    if (viewCurrentEdit_==nil)
        return nil;
    
    imageViewRotate_.hidden = YES;
    UIImage *currentImage = nil;
    
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
 * @brief 动态重置控制字体缩放和旋转的按钮
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)resetRotatoButtonCenter
{
    imageViewRotate_.hidden = NO;
    imageViewRotate_.center = [viewCurrentEdit_ convertPoint:CGPointMake(viewCurrentEdit_.bounds.size.width, viewCurrentEdit_.bounds.size.height) toView:imageView_];
    //旋转图钉始终要保持在所有子视图的最上层
    [imageView_ bringSubviewToFront:imageViewRotate_];
}

/**
 * @brief 长按手势
 *
 * @param [in] recognizer: 手势识别器
 * @param [out]
 * @return 
 * @note 
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    switch (recognizer.state)
	{
        case UIGestureRecognizerStateBegan:
        {
            UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:nil 
															   delegate:self
													  cancelButtonTitle:nil
												 destructiveButtonTitle:@"编辑"
													  otherButtonTitles:@"删除",@"取消" ,nil] autorelease]
			;
            sheet.destructiveButtonIndex = 1;
            [sheet showInView:self.view];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	int tag = viewCurrentEdit_.tag;
	
    switch (buttonIndex) 
    {
        case 0:		//edit
			
			vcParent_.operateType = TitleOperateTypeEdit;
			vcParent_.viewCurrentEdit = viewCurrentEdit_;
			
            [self.navigationController popViewControllerAnimated:YES];
			
            break;
			
        case 1:		//delete
            //将需要删除的视图tag 从数组中移除
            for (int i=0; i<[arrViewTag_ count]; ++i)
			{
                if ([[arrViewTag_ objectAtIndex:i] intValue] == tag)
				{
                    [arrViewTag_ removeObjectAtIndex:i];
                    break;
                }
            }
            //将要删除的视图从父视图中清除
            [viewCurrentEdit_ removeFromSuperview];
            
            NSNumber *number = [arrViewTag_ lastObject];
            if (number == nil)	//删除后，界面上没有文字，需要将旋转图钉隐藏
			{
                viewCurrentEdit_ = nil;
                imageViewRotate_.hidden = YES;
            }
            else	 //全局视图viewCurrentEdit_需要重置，图钉位置重置
			{
                viewCurrentEdit_ = (UIView *)[imageView_ viewWithTag:[number intValue]];
                [self resetRotatoButtonCenter];
            }
            break;
			
        default:
            break;
    }
}
#pragma mark -
#pragma mark Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[event allTouches] count] > 1)
		return;
	
	UITouch *touch = [touches anyObject];
    
    //操作的是当前第一响应的文字视图
    if (touch.view.tag == viewCurrentEdit_.tag)
	{
        NSLog(@"触摸点位于文字图片上");
        //移动
        ptFirst_ = [touch locationInView:imageView_];
        imageViewRotate_.hidden = NO;
    }
    else if (touch.view.tag == kDefaultTagButton)
    {
        NSLog(@"触摸点位于旋转按钮上");
        //旋转
         ptFirst_ = [touch locationInView:imageView_];
    }
    else if (touch.view.tag == kDefaultTagImageView)
    {
        NSLog(@"触摸位于底图上");
        imageViewRotate_.hidden = YES;
    }
    //操作的不是当前第一响应的文字视图，需要将此视图转化为第一响应
    else if (touch.view.tag != self.view.tag) 
    {
        viewCurrentEdit_ = nil;
        viewCurrentEdit_ = (UIView *)touch.view;
        [imageView_ bringSubviewToFront:viewCurrentEdit_];
        [self resetRotatoButtonCenter];
        ptFirst_ = [touch locationInView:imageView_];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[event allTouches] count] > 1)
        return;
	
	UITouch *touch = [touches anyObject];
	ptLast_ = [touch locationInView:imageView_];
    
    //旋转
    if (touch.view.tag==kDefaultTagButton)
	{
        imageViewRotate_.center = ptLast_;
        
        CGFloat angle = [Common makeRotate:viewCurrentEdit_.center withBegin:ptFirst_ andEnd:ptLast_];
        CGFloat scale = [Common makeScale:viewCurrentEdit_.center beginPoint:ptFirst_ andEndPoint:ptLast_];
        
        viewCurrentEdit_.transform = CGAffineTransformScale(CGAffineTransformRotate(viewCurrentEdit_.transform, angle), scale, scale);
        ptFirst_ = ptLast_;
        //跟进操作，减少误差
        CGPoint begin = [viewCurrentEdit_ convertPoint:CGPointMake(viewCurrentEdit_.bounds.size.width, viewCurrentEdit_.bounds.size.height) toView:imageView_];
        CGPoint end = imageViewRotate_.center;
        CGFloat angle1 = [Common makeRotate:viewCurrentEdit_.center withBegin:begin andEnd:end];
        CGFloat scale1 = [Common makeScale:viewCurrentEdit_.center beginPoint:begin andEndPoint:end];
        viewCurrentEdit_.transform = CGAffineTransformScale(CGAffineTransformRotate(viewCurrentEdit_.transform, angle1), scale1, scale1);
    }
    //移动
    else if (touch.view.tag == viewCurrentEdit_.tag)
	{
        viewCurrentEdit_.center = CGPointMake(viewCurrentEdit_.center.x+ptLast_.x-ptFirst_.x, 
                                        viewCurrentEdit_.center.y+ptLast_.y-ptFirst_.y);
        imageViewRotate_.center = CGPointMake(imageViewRotate_.center.x+ptLast_.x-ptFirst_.x, 
                                              imageViewRotate_.center.y+ptLast_.y-ptFirst_.y);
        ptFirst_ = ptLast_;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] > 1)
        return;
    
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    if (view != viewCurrentEdit_)
        return;
    
	CGPoint ptCenterTitle = viewCurrentEdit_.center;          // 调整后的标题的中心位置
	CGPoint ptCenterTitleBackup = ptCenterTitle;
    CGPoint ptCenterRotateButton = imageViewRotate_.center;   // 旋转按钮的中心位置
	
    CGRect rect = imageView_.bounds;
    if (CGRectContainsPoint(rect, ptCenterTitle))
        return;
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGFloat width = CGRectGetWidth(viewCurrentEdit_.bounds);
//    CGFloat height = CGRectGetHeight(viewCurrentEdit_.bounds);
    
    int position = [self getPointPositionOfRect:rect point:ptCenterTitle];
    
    // 字符太长的话就不用调整center.x
	if (viewCurrentEdit_.frame.size.width > self.view.frame.size.width * 2) 
	{
		if (!CGRectContainsPoint(imageView_.bounds, viewCurrentEdit_.center)) 
        {
            if (position == PositionTypeOfPointInRectTop || position == PositionTypeOfPointInRectTopLeft || position == PositionTypeOfPointInRectTopRight)
            {
                ptCenterTitle.y = miny;
//                ptCenterRotateButton = CGPointMake(ptCenterTitle.x + width/2, ptCenterTitle.y + height/2);
            }
            else if (position == PositionTypeOfPointInRectBottom || position == PositionTypeOfPointInRectBottomLeft || position == PositionTypeOfPointInRectBottomRight)
            {
                ptCenterTitle.y = maxy;
//                ptCenterRotateButton = CGPointMake(ptCenterTitle.x + width/2, ptCenterTitle.y + height/2);
            }
            else if (position == PositionTypeOfPointInRectLeft)
            {
                CGPoint ptRight = {ptCenterTitle.x+width/2-40, ptCenterTitle.y};
                if (!CGRectContainsPoint(rect, ptRight) && ptRight.x < minx)
                {
                    ptCenterTitle.x = minx - width/2 + 40;
//                    ptCenterRotateButton.x = ptCenterTitle.x + width/2;
                }
            }
            else if (position == PositionTypeOfPointInRectRight)
            {
                CGPoint ptLeft = {ptCenterTitle.x-width/2+40, ptCenterTitle.y};
                if (!CGRectContainsPoint(rect, ptLeft)  && ptLeft.x > maxx)
                {
                    ptCenterTitle.x = maxx + width/2 - 40;
//                    ptCenterRotateButton.x = ptCenterTitle.x + width/2;
                }
            }
            
            [UIView beginAnimations:@"ImagePounceBack" context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationBeginsFromCurrentState:YES];
            viewCurrentEdit_.center = ptCenterTitle;
            imageViewRotate_.center = CGPointMake(ptCenterRotateButton.x + ptCenterTitle.x - ptCenterTitleBackup.x, ptCenterRotateButton.y + ptCenterTitle.y - ptCenterTitleBackup.y);
            [UIView commitAnimations];
            return;
        }
	}
    
    if (position == PositionTypeOfPointInRectTopLeft)
    {
        ptCenterTitle = CGPointMake(minx, miny);
//        ptCenterRotateButton = CGPointMake(width/2, height/2);
    }
    else if (position == PositionTypeOfPointInRectLeft)
    {
        ptCenterTitle.x = minx;
//        if (ptCenterTitle.y + height/2 + kImageViewRotateSize/2 > maxy)
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x+width/2, ptCenterTitle.y-height/2);
//        else
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x+width/2, ptCenterTitle.y+height/2);
    }
    else if (position == PositionTypeOfPointInRectBottomLeft)
    {
        ptCenterTitle = CGPointMake(minx, maxy);
//        ptCenterRotateButton = CGPointMake(ptCenterTitle.x+width/2, ptCenterTitle.y-height/2);
    }
    else if (position == PositionTypeOfPointInRectTop)
    {
        ptCenterTitle.y = miny;
//        if (ptCenterTitle.x + width/2 + kImageViewRotateSize/2 > maxx)
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x-width/2, ptCenterTitle.y+height/2);
//        else
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x+width/2, ptCenterTitle.y+height/2);
    }
    else if (position == PositionTypeOfPointInRectIn)
    {
        
    }
    else if (position == PositionTypeOfPointInRectBottom)
    {
        ptCenterTitle.y = maxy;
//        if (ptCenterTitle.x + width/2 + kImageViewRotateSize/2 > maxx)
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x-width/2, ptCenterTitle.y-height/2);
//        else
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x+width/2, ptCenterTitle.y-height/2);
    }
    else if (position == PositionTypeOfPointInRectTopRight)
    {
        ptCenterTitle = CGPointMake(maxx, miny);
//        ptCenterRotateButton = CGPointMake(ptCenterTitle.x-width/2, ptCenterTitle.y+height/2);
    }
    else if (position == PositionTypeOfPointInRectRight)
    {
        ptCenterTitle.x = maxx;
//        if (ptCenterTitle.y - height/2 - kImageViewRotateSize/2 > miny)
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x-width/2, ptCenterTitle.y-height/2);
//        else
//            ptCenterRotateButton = CGPointMake(ptCenterTitle.x-width/2, ptCenterTitle.y+height/2);
    }
    else if (position == PositionTypeOfPointInRectBottomRight)
    {
        ptCenterTitle = CGPointMake(maxx, maxy);
//        ptCenterRotateButton = CGPointMake(ptCenterTitle.x-width/2, ptCenterTitle.y-height/2);
    }
    
    [UIView beginAnimations:@"ImagePounceBack" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    viewCurrentEdit_.center = ptCenterTitle;
    imageViewRotate_.center = CGPointMake(ptCenterRotateButton.x + ptCenterTitle.x - ptCenterTitleBackup.x, ptCenterRotateButton.y + ptCenterTitle.y - ptCenterTitleBackup.y);
	if (!CGRectContainsRect(viewCurrentEdit_.frame, imageView_.bounds)) 
	{
		imageViewRotate_.hidden = NO;
	}
    [UIView commitAnimations];
}

/**
 * @brief 获取指定点在指定矩形区域内的位置
 *
 * @param [in] rect: 指定区域
 * @param [in] pt: 指定位置
 * @param [out]
 * @return 位置标记
 * @note 
 */
- (int)getPointPositionOfRect:(CGRect)rect point:(CGPoint)pt
{
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    if (pt.x < minx) 
    {
        if (pt.y < miny)
            return PositionTypeOfPointInRectTopLeft;
        else if (pt.y < maxy)
            return PositionTypeOfPointInRectLeft;
        else
            return PositionTypeOfPointInRectBottomLeft;
    }
    else if (pt.x < maxx)
    {
        if (pt.y < miny)
            return PositionTypeOfPointInRectTop;
        else if (pt.y < maxy)
            return PositionTypeOfPointInRectIn;
        else
            return PositionTypeOfPointInRectBottom;
    }
    else
    {
        if (pt.y < miny)
            return PositionTypeOfPointInRectTopRight;
        else if (pt.y < maxy)
            return PositionTypeOfPointInRectRight;
        else
            return PositionTypeOfPointInRectBottomRight;
    }
}

@end
