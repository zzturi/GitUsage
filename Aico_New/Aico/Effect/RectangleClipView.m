//
//  RectangleClipView.m
//  Aico
//
//  Created by  jiang liyin on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RectangleClipView.h"
#import "ImageInfo.h"
#import "ReUnManager.h"
#import "PhotoEffectsViewController.h"
#import "ColorEffectsCommon.h"


@implementation RectangleClipView
@synthesize rectangle = rectangle_;
@synthesize imageInfo = imageInfo_;
@synthesize scale = scale_;
@synthesize clearView = clearView_;

/**
 * @brief 移动手势
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)doPanGesture:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self hidenLayer:NO];
            ptTouchBegin_ = touchPoint;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint touchPointInView = [self convertPoint:touchPoint toView:clearBackgroundView_];
            CGPoint ptTouchBeginInView = [self convertPoint:ptTouchBegin_ toView:clearBackgroundView_];
            CGFloat offsetY = touchPointInView.y - ptTouchBeginInView.y;

            if (ptTouchBeginInView.y != touchPointInView.y)
            {
                CGPoint center = clearView_.center ;
                center.y += offsetY;
                //限制矩形区域的位置，矩形中心越过图片区域则不能再移动
                CGPoint centerInSelf = [clearBackgroundView_ convertPoint:center toView:self];
                if (centerInSelf.x < 0 || centerInSelf.x > self.frame.origin.x + self.frame.size.width
                    || centerInSelf.y < 0 || centerInSelf.y > self.frame.origin.y + self.frame.size.height) 
                {
                    break;
                }
                clearView_.center = center;
                
                //调整topLayer_的位置
                CGPoint position = topLayer_.position;
                position.y += offsetY;
                topLayer_.position = position;
                
                //调整bottomLayer_的位置
                position = bottomLayer_.position;
                position.y += offsetY;
                bottomLayer_.position = position;
            
            }
            ptTouchBegin_ = touchPoint;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self performSelectorInBackground:@selector(effect) withObject:nil];
            //调用父视图的该函数来保存当前图片
            [(PhotoEffectsViewController *)superViewController_ sliderTouchUp];
            break;
        }
            
        default:
            break;
    }
}


/**
 * @brief 捏合手势
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)doPinchGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        [self hidenLayer:NO];
    }
    //当手指离开屏幕时,将lastscale设置为1.0  
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {  
        lastScale_ = 1.0; 
        [self performSelectorInBackground:@selector(effect) withObject:nil];
        //调用父视图的该函数来保存当前图片
        [(PhotoEffectsViewController *)superViewController_ sliderTouchUp];
        return;  
    }  
    
    CGFloat scale = 1.0 - (lastScale_ - [(UIPinchGestureRecognizer *)gestureRecognizer scale]); 
    CGRect bounds = clearView_.bounds;
    //不能无限放大和缩小，当放大后的小矩形的高度大于界面高度－5时，不能再放大，当放大后的小矩形的高度小于界面高度的十分之一时不能再缩小
    if (bounds.size.height * scale > self.bounds.size.height - 5.0f  
        || bounds.size.height * scale < self.bounds.size.height/10.0)
    {
        return;
    }
    lastScale_ = [(UIPinchGestureRecognizer *)gestureRecognizer scale];
    
    bounds.size.height *=scale;
    CGFloat offsetY = bounds.size.height - clearView_.bounds.size.height;
    clearView_.bounds = bounds;
    //调整topLayer_的位置
    CGPoint position = topLayer_.position;
    position.y += -offsetY/2;
    topLayer_.position = position;

    //调整bottomLayer_的位置
    position = bottomLayer_.position;
    position.y += offsetY/2;
    bottomLayer_.position = position;

}

/**
 * @brief 单击手势
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)doTapGesture:(UIGestureRecognizer *)gestureRecognizer
{

    [self hidenLayer:NO];
    //因为触点是相对于clearview的父视图所在的坐标系的，所以需要将相对于clearview父视图self的坐标转换到相对于clearview所在坐标系进行计算
    CGPoint tapPoint = [gestureRecognizer locationInView:self];
    CGPoint tapPointInView  = [self convertPoint:tapPoint toView:clearBackgroundView_];
    CGFloat offsetY;
    if ((tapPoint.x > 0 && tapPoint.x < self.frame.origin.x + self.frame.size.width)
        && (tapPoint.y >0 && tapPoint.y < self.frame.origin.y + self.frame.size.height)) 
    {
        CGPoint center = clearView_.center ;
        offsetY = (tapPointInView.y - center.y);
        center.y += offsetY;
        clearView_.center = center;
        
        //调整topLayer_的位置
        CGPoint position = topLayer_.position;
        position.y += offsetY;
        topLayer_.position = position;
        
        //调整bottomLayer_的位置
        position = bottomLayer_.position;
        position.y += offsetY;
        bottomLayer_.position = position;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateCancelled || [gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        [self performSelectorInBackground:@selector(effect) withObject:nil];
        
        //调用父视图的该函数来保存当前图片
        [(PhotoEffectsViewController *)superViewController_ sliderTouchUp];
    }
    
}


/**
 * @brief 旋转手势
 *
 * @param [in] 
 * @param [out]
 * @return 
 * @note 
 */
- (void)doRotationGesture:(UIRotationGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        [self hidenLayer:NO];
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) 
    {  
        clearBackgroundView_.transform = CGAffineTransformRotate([clearBackgroundView_ transform], [gestureRecognizer rotation]);
        rotateAngle_ += [gestureRecognizer rotation];
        [gestureRecognizer setRotation:0];
    }  
    if ([gestureRecognizer state] == UIGestureRecognizerStateCancelled || [gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        [self performSelectorInBackground:@selector(effect) withObject:nil];
        //调用父视图的该函数来保存当前图片
        [(PhotoEffectsViewController *)superViewController_ sliderTouchUp];
    }

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

/**
 * @brief 初始化本view 
 *
 * @param [in] frame: view的区域
 * @param [in] pRectangle: view的清晰矩形区域
 * @param [in] imageView: 图片所在的imageview
 * @param [in] superViewController: 父视图控制器
 * @param [out]
 * @return 初始化好view
 * @note 
 */
-(id)initWithFrame:(CGRect)frame rectangle:(RectanglePtr)pRectangle imageView:(UIImageView *)imageView superController:(UIViewController *)superViewController
{
	self = [super initWithFrame:frame];
	if (self)
	{
        superViewController_ = superViewController;
        
        rectangle_.x = pRectangle->x;
        rectangle_.y = pRectangle->y;

        rectangle_.heightInView = pRectangle->heightInView;
        rectangle_.widthInView = pRectangle->widthInView;
        rectangle_.xView = pRectangle->xView;
        rectangle_.yView = pRectangle->yView;
        viewImageDest_ = imageView;
        self.imageInfo = [ImageInfo UIImageToImageInfo:imageView.image];
        
        CGFloat viewWidth = 4 * rectangle_.widthInView;//防止在变换过程中，此view的两边跑到图片中间
        clearBackgroundView_ = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - viewWidth)/2, (frame.size.height - viewWidth)/2, viewWidth, viewWidth)];
        clearView_ = [[UIView alloc] initWithFrame:CGRectMake(0, rectangle_.yView - rectangle_.heightInView/2 + frame.origin.y - clearBackgroundView_.frame.origin.y, viewWidth, rectangle_.heightInView)];
        clearView_.backgroundColor = [UIColor clearColor];
        clearView_.tag = 2097;
        clearBackgroundView_.backgroundColor = [UIColor clearColor];
        
        //上方的蒙板
        topLayer_ = [[CAGradientLayer alloc] init];
        topLayer_.bounds = CGRectMake(0, 0, viewWidth, viewWidth - clearView_.frame.origin.y - clearView_.frame.size.height);
        CGFloat location = 15.0/topLayer_.bounds.size.height;
        topLayer_.position = CGPointMake(CGRectGetMidX(topLayer_.bounds), CGRectGetMidY(topLayer_.bounds));
        topLayer_.colors = [NSArray arrayWithObjects:(id)[[[UIColor whiteColor] colorWithAlphaComponent:0.7] CGColor], (id)[[UIColor clearColor] CGColor],nil];
        topLayer_.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1 - location],[NSNumber numberWithFloat:1.0], nil];
        [clearBackgroundView_.layer addSublayer:topLayer_];
        
        //下方的蒙板
        bottomLayer_ = [[CAGradientLayer alloc] init];
        bottomLayer_.frame = CGRectMake(0, clearView_.frame.origin.y + clearView_.frame.size.height, viewWidth, viewWidth - (clearView_.frame.origin.y + clearView_.frame.size.height));
        bottomLayer_.position = CGPointMake(CGRectGetMidX(bottomLayer_.frame), CGRectGetMidY(bottomLayer_.frame));

        location = 15.0/bottomLayer_.frame.size.height;
        bottomLayer_.colors = [NSArray arrayWithObjects:(id)[[[UIColor whiteColor] colorWithAlphaComponent:0.7] CGColor], (id)[[UIColor clearColor] CGColor],nil];
        bottomLayer_.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1 - location],[NSNumber numberWithFloat:1.0],nil];
        bottomLayer_.startPoint = CGPointMake(1, 1);
        bottomLayer_.endPoint = CGPointMake(1, 0);
        [clearBackgroundView_.layer addSublayer:bottomLayer_];
        [clearBackgroundView_ addSubview:clearView_];
        [self addSubview:clearBackgroundView_];
        
        //subview中超出本view的区域不显示
        self.clipsToBounds = YES;
        
        //移动手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPanGesture:)];
        [self addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
        
        //捏合手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinchGesture:)];
        [self addGestureRecognizer:pinchGestureRecognizer];
        [pinchGestureRecognizer release];
        
        //单击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapGesture:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        //旋转手势
        UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(doRotationGesture:)];
        [self addGestureRecognizer:rotationGestureRecognizer];
        [rotationGestureRecognizer release];
        
        cloneImageInfo_ = [imageInfo_ clone];
        [ColorEffectsCommon fastBlurImage:cloneImageInfo_ radius:7];
        
        
    }
	return self;
}
        

- (void)dealloc 
{
    self.imageInfo = nil;
    self.clearView = nil;
    [blurImageView_ release];
    [cloneImageInfo_ release];
    superViewController_ = nil;
    RELEASE_OBJECT(topLayer_);
    RELEASE_OBJECT(bottomLayer_);
    RELEASE_OBJECT(clearBackgroundView_);
    [super dealloc];
}


#pragma mark -
#pragma mark Custom Methods

/**
 * @brief 对当前的图片应用移轴效果 
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)effect
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    ImageInfo *copyInfo = [cloneImageInfo_ clone];
	[EffectMethods rectangleClip:copyInfo withClearView:clearView_ withRotationAngle:rotateAngle_ withScale:scale_];
    UIImage *newImage = [ImageInfo ImageInfoToUIImage:copyInfo];
    blurImageView_.image = newImage;
    if (blurImageView_ == nil)
    {
        blurImageView_ = [[UIImageView alloc] initWithImage:newImage];
        blurImageView_.frame = CGRectMake(0, 0, viewImageDest_.frame.size.width, viewImageDest_.frame.size.height);
        blurImageView_.backgroundColor = [UIColor clearColor];
        blurImageView_.alpha = 0.5;
        [viewImageDest_ addSubview:blurImageView_];
    }

    [self hidenLayer:YES];
    [copyInfo release];
    [pool release];
}

/**
 * @brief 隐藏蒙板层
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)hidenLayer:(BOOL)hidden
{
    topLayer_.hidden = hidden;
    bottomLayer_.hidden = hidden;
}
@end
