//
//  DrawImageView.m
//  Aico
//
//  Created by rongtaowu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawingImageView.h"
#import "Common.h"
#import "TwistHandle.h"
#import "ImageInfo.h"
#import "RotateView.h"

@interface DrawingImageView()

- (void)addCycleView:(CGFloat)radius center:(CGPoint)point;
- (void)setCycleViewRadius:(CGFloat)radius;
- (void)setCycleViewPosition:(CGPoint)centerPoint;
- (void)initImageInfo;
- (void)handleSingleTap:(id)sender;

@end

@implementation DrawingImageView
@synthesize srcImage = srcImage_;
@synthesize effecttype = effecttype_;

#define kScreenWidth    320
#define kScreenHeight   480 
#define kAdjustWidth    50

/**
 * @brief 改变图片大小 
 * 
 * @param [in]  image:源图片 size:目标尺寸
 * @param [out] 目标图片
 * @return 
 * @note 
 */
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * @brief  根据选择特效绘图操作
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)drawImage
{
    ImageInfo *destImage = [srcImageInfo_ clone];
    
    switch (effecttype_) 
    {
        case kSpherize:
        {
            [TwistHandle spherize:srcImageInfo_
                        destImage:destImage
                      CycleCenter:adjustPoint_
                           Radius:radius_
                       scaleRatio:scaleRatio_];
        }
            break;
        case kTwirl:
        {
            [TwistHandle rotate:srcImageInfo_         
                      destImage:destImage
                    CycleCenter:adjustPoint_ 
                         degree:30
                         radius:radius_];
            NSLog(@"Twirl .......");
        }
            break;
        case kPinch:
        {               
            
             NSLog(@"Pinch .......");
        }
            break;
        case kSplash:
        {
            [TwistHandle pinch:srcImageInfo_
                     destImage:destImage
                   CycleCenter:adjustPoint_
                        degree:60
                      inRadius:radius_];
             NSLog(@"Splash .......");
        }
            break;
            
        default:
            break;
    }
    
    if (dstImage_ != nil)
    {
        [dstImage_ release],dstImage_ = nil;
    }
    dstImage_ = [[ImageInfo ImageInfoToUIImage:destImage] retain];
    [dstImage_ drawAtPoint:srcPoint_];
    
}

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)srcImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        centerPoint_ = CGPointMake(160.0, 240.0);
        radius_ = 80.0;
        scaleRatio_ = 2.0;
        self.srcImage = srcImage;
        [self addCycleView:radius_ center:centerPoint_];
        [self initImageInfo];
        
        
        //添加单击手势
        UITapGestureRecognizer *singleTapRecognizer;
        singleTapRecognizer = [[UITapGestureRecognizer alloc] 
                                 initWithTarget:self
                                         action:@selector(handleSingleTap:)];
        singleTapRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleTapRecognizer];
        [singleTapRecognizer release];
    }
    return self;
}

/**
 * @brief  绘图 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)drawRect:(CGRect)rect
{
    [self drawImage];    
}

/**
 * @brief  析构 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)dealloc
{
    self.srcImage = nil;
    [cycleView_ release];
    [srcImageInfo_ release];
    [dstImage_ release];
    [super dealloc];
}

/**
 * @brief  触摸操作开始 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

/**
 * @brief  触摸操作移动事件 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    //计算触摸点的位置，进行改变操作区域大小还是进行移动
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat distanX = currentPoint.x - centerPoint_.x;
    CGFloat distanY = currentPoint.y - centerPoint_.y;
    CGFloat newRadius = sqrtf(distanX * distanX + distanY * distanY);
        
    if (radius_ <= 60 || (newRadius >= radius_ * 2/3 && newRadius <= radius_ * 4/3)){
        
        [cycleView_ setHidden:NO];
        [self setCycleViewRadius:newRadius];
        [cycleView_ setAccuartePosition:currentPoint];
    } 
    else if(newRadius < radius_ * 2/3 && newRadius > 30){
        CGPoint previousPoint = [touch previousLocationInView:self];
        CGFloat deltX = currentPoint.x - previousPoint.x;
        CGFloat deltY = currentPoint.y - previousPoint.y;
        CGPoint newCenter = CGPointMake(centerPoint_.x + deltX, centerPoint_.y + deltY);
        [self setCycleViewPosition:newCenter]; 
        [cycleView_ setHidden:YES];
        
    } 
    //此处需要将触摸坐标转换为图片实际坐标
    adjustPoint_ = CGPointMake(centerPoint_.x - srcPoint_.x, 
                               centerPoint_.y - srcPoint_.y);    
    [self setNeedsDisplay];
}

/**
 * @brief  触摸操作结束 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [cycleView_ setHidden:NO];
    
}

/**
 * @brief 添加圆形视图
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)addCycleView:(CGFloat)radius center:(CGPoint)point;
{
    CGFloat width = 2 * radius + kAdjustWidth;
    cycleView_ = [[RotateView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    cycleView_.center = point;
    cycleView_.layer.cornerRadius = width/2;
    cycleView_.layer.masksToBounds = YES;
    cycleView_.radius = radius;
    cycleView_.backgroundColor = [UIColor clearColor];
    [self addSubview:cycleView_];
}

/**
 * @brief  通过半径改变视图 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setCycleViewRadius:(CGFloat)radius
{
    CGFloat deltRadius = radius - radius_;
    CGFloat viewWidth = radius * 2 + kAdjustWidth;
    CGFloat newCenterX = centerPoint_.x - deltRadius/2;
    CGFloat newCenterY = centerPoint_.y - deltRadius/2;
    cycleView_.center = CGPointMake(newCenterX, newCenterY);
    CGRect newFrame = CGRectMake(cycleView_.frame.origin.x, 
                                 cycleView_.frame.origin.y, 
                                 viewWidth, 
                                 viewWidth);
    cycleView_.frame = newFrame;
    cycleView_.layer.cornerRadius = viewWidth/2;
    radius_ = radius;
    cycleView_.radius = radius;
    
    //重设绘图中心点坐标，
    cycleView_.centerPoint = CGPointMake(cycleView_.frame.size.width/2, 
                                         cycleView_.frame.size.height/2);
    [cycleView_ setNeedsDisplay];
}

/**
 * @brief 改变视图位置 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setCycleViewPosition:(CGPoint)centerPoint
{
    cycleView_.center = centerPoint;
    centerPoint_ = centerPoint;
    [cycleView_ setAutoPosition];
}

/**
 * @brief 初始化图片信息 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)initImageInfo
{
    CGFloat imageWidth = self.srcImage.size.width;
    CGFloat imageHeight = self.srcImage.size.height; 
    CGFloat imageFrameWidth = imageWidth;
    CGFloat imageFrameHeight = imageHeight;  
    
    if (self.srcImage)
    {
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
    }
    srcPoint_ = CGPointMake(kScreenWidth/2 - imageFrameWidth/2, 
                            kScreenHeight/2 - imageFrameHeight/2);
    adjustPoint_ = CGPointMake(centerPoint_.x - srcPoint_.x, 
                               centerPoint_.y - srcPoint_.y);
    UIImage *newSrcImage = [self scaleFromImage:self.srcImage 
                                         toSize:CGSizeMake(imageFrameWidth, imageFrameHeight)];   
    srcImageInfo_ = [[ImageInfo UIImageToImageInfo:newSrcImage] retain];
}

/**
 * @brief 处理单击操作手势
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)handleSingleTap:(id)sender
{
    if (cycleView_.hidden)
    {
        cycleView_.hidden = NO;
    }
    else 
    {
        cycleView_.hidden = YES;
        
    }    
}

/**
 * @brief 改变特效幅度 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)changeEffectRatio:(CGFloat)ratio
{
    scaleRatio_ = ratio;
    [self setNeedsDisplay];
}

/**
 * @brief 获取处理之后的图片 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (UIImage *)getEffectImage
{
    return dstImage_;
}

@end
