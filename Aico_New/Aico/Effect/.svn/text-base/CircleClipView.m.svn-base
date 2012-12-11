//
//  CircleClipView.m
//  Aico
//
//  Created by zhou yong on 4/13/12.
//  Copyright 2012 cienet. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CircleClipView.h"
#import "EffectMethods.h"
#import "ImageInfo.h"
#import "ReUnManager.h"

#define kPhotoEffectsAreaWidth		15
#define kPhotoEffectsMinRadius		10
#define kPI							3.1415926f
#define kPI_4						(kPI / 4.0f)
#define kCircleCount				8
#define kBigCircleSize				30

@implementation CircleClipView

@synthesize circle		= circle_;
@synthesize imageInfo	= imageInfo_;
@synthesize scale		= scale_;

#pragma mark -
#pragma mark View Life

/**
 * @brief 初始化本view 
 *
 * @param [in] frame: view的区域
 * @param [in] pCircle: view的聚光灯区域
 * @param [in] imageView: 图片所在的imageview
 * @param [out]
 * @return 初始化好view
 * @note 
 */
-(id)initWithFrame:(CGRect)frame circle:(ConcentricCirclePtr)pCircle imageView:(UIImageView*)imageView
{
	self = [super initWithFrame:frame];
	if (self)
	{
		arrayViewEdge_ = [[NSMutableArray alloc] initWithCapacity:kCircleCount];
		
		UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_big.png"]];
		view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, kBigCircleSize, kBigCircleSize);
		view.userInteractionEnabled = NO;
		[arrayViewEdge_ addObject:view];
		
		
		for (int i=0; i<7; ++i) 
		{
			UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_small.png"]];
			[arrayViewEdge_ addObject:view];
			[self addSubview:view];
			[view release];
		}
		
		[self addSubview:view];	// 大图在最上面
		[view release];
		      
		circle_.x = pCircle->x;
		circle_.y = pCircle->y;
		circle_.minRadius = pCircle->minRadius;
		circle_.maxRadius = pCircle->maxRadius;
		circle_.xView = pCircle->xView;
		circle_.yView = pCircle->yView;
//		self.layer.borderColor = [UIColor blueColor].CGColor;
//		self.layer.borderWidth = 1;
		viewImageDest_ = imageView;
		self.imageInfo = [ImageInfo UIImageToImageInfo:viewImageDest_.image];
		
		angle_ = 0.75f * kPI;
		[self updateCircle];
	}
	return self;
}

- (void)dealloc 
{
	[imageInfo_ release];
    [super dealloc];
}

#pragma mark -
#pragma mark Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	ptTouchBegin_ = [touch locationInView:self];
	
	int offsetx = self.frame.origin.x + ptTouchBegin_.x - circle_.xView;
	int offsety = self.frame.origin.y + ptTouchBegin_.y - circle_.yView;
	int distance = offsetx * offsetx + offsety * offsety;
	
	if (circle_.minRadius <= kPhotoEffectsAreaWidth+5)
	{
//		if (distance > (circle_.minRadius + kPhotoEffectsAreaWidth) * (circle_.minRadius + kPhotoEffectsAreaWidth))
//			dragType_ = DragTypeNone;
//		else
			dragType_ = DragTypeRadius;
	}
	else
	{
		CGFloat minRadius = circle_.minRadius / scale_ - kPhotoEffectsAreaWidth;
		CGFloat maxRadius = circle_.minRadius / scale_ + kPhotoEffectsAreaWidth;
		
		CGFloat disOriginType = minRadius * minRadius;
		CGFloat disNoneType = maxRadius * maxRadius;
		
		if (distance > disNoneType)
			dragType_ = DragTypeNone;
		else if (distance < disOriginType)
			dragType_ = DragTypeOrigin;
		else
			dragType_ = DragTypeRadius;
	}	
//	[self updateCircleAngle:ptTouchBegin_];
}

//NSLog(@"point = [%.1f,%.1f], offset = [%d,%d]", point.x, point.y, offsetx, offsety)

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	CGRect frameView = self.frame;
	
	CGFloat offsetx = point.x - ptTouchBegin_.x;
	CGFloat offsety = point.y - ptTouchBegin_.y;
	
	if (dragType_ == DragTypeOrigin) 
	{
		circle_.x += offsetx * scale_;
		circle_.y += offsety * scale_;
		
		CGPoint pt = frameView.origin;
		pt.x += offsetx;
		pt.y += offsety;
		circle_.xView += offsetx;
		circle_.yView += offsety;
		
		self.frame = CGRectMake(pt.x, pt.y, frameView.size.width, frameView.size.height);
	}
	else if (dragType_ == DragTypeRadius)
	{
		CGPoint pt = self.frame.origin;
		
		CGFloat offsetx = pt.x + point.x - circle_.xView;
		CGFloat offsety = pt.y + point.y - circle_.yView;
		CGFloat newRadius = sqrtf(offsetx*offsetx + offsety*offsety) * scale_;
		
		if (newRadius <= kPhotoEffectsMinRadius)
			return;
		
		circle_.maxRadius = newRadius + circle_.maxRadius - circle_.minRadius;
		circle_.minRadius = newRadius;
		
		CGFloat radiusView = circle_.minRadius/scale_;
		self.frame = CGRectMake(circle_.xView-radiusView, circle_.yView-radiusView, radiusView*2, radiusView*2);
		self.layer.cornerRadius = radiusView;
	}
	
	[self effect];
	[self updateCircle];
//	[self updateCircleAngle:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UIImageView *imageView = (UIImageView *)[self.superview viewWithTag:kZoomViewTag];
    [[ReUnManager sharedReUnManager] storeSnap:imageView.image];
}

#pragma mark -
#pragma mark Custom Methods

/**
 * @brief 对当前的图片应用聚光灯效果 
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)effect
{
	ImageInfo *copyInfo = [imageInfo_ clone];
	[EffectMethods concentricCircleClip:copyInfo circle:&circle_];
	UIImage *newImage = [ImageInfo ImageInfoToUIImage:copyInfo];
	viewImageDest_.image = newImage;
    [copyInfo release];
}

/**
 * @brief 更新聚光灯边框上的8个点，来显示聚光灯中心全亮部分的边框 
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateCircle
{
	CGFloat radius = self.bounds.size.width / 2.0f;
	
	for (int i=0; i<kCircleCount; ++i)
	{
		CGFloat x = radius + radius * sin(angle_ + i * kPI_4);
		CGFloat y = radius - radius * cos(angle_ + i * kPI_4);
		UIImageView *view = [arrayViewEdge_ objectAtIndex:i];
		view.center = CGPointMake(x, y);
	}
}

@end
