//
//  RotateView.m
//  Aico
//
//  Created by rongtaowu on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RotateView.h"

@interface RotateView()
- (void)setPointPositon;
@end

@implementation RotateView
@synthesize radius = radius_;
@synthesize centerPoint = centerPoint_;

#define  kLargeNumber  1000000
#define  kAdjustNumber 2.0

/**
 * @brief 初始化函数
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        radius_ = 80.0;
        centerPoint_ = self.center;
        
        rotateView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        rotateView_.image = [UIImage imageNamed:@"RotateRound.png"];
        rotateView_.center = CGPointMake(centerPoint_.x, centerPoint_.y + radius_);
        [self addSubview:rotateView_];
        
    }
    return self;
}

/**
 * @brief 绘画函数
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)drawRect:(CGRect)rect
{   
    UIImage *smallRoundImage = [UIImage imageNamed:@"SmallRound.png"];
    [self setPointPositon];
    for (int i = 0; i < 8; i++)
    {
        [smallRoundImage drawAtPoint:pointArray[i]];
    }
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
    [rotateView_ release];
    [super dealloc];
}

/**
 * @brief 设置显示位置
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setPointPositon
{
    for (int i = 0; i < 8; i++)
    {
        CGFloat degree = i * M_PI/4;        
        //kAdjustNumber:手动调节界面坐标误差
        CGFloat pointX = centerPoint_.x + sinf(degree) * radius_ - kAdjustNumber;
        CGFloat pointY = centerPoint_.y - cosf(degree) * radius_ - kAdjustNumber;
        CGPoint imagePoint = CGPointMake(pointX, pointY);
        pointArray[i] = imagePoint;
    }
}

/**
 * @brief 设置指示视图的位置 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setAutoPosition
{
    [self setPointPositon];
    CGPoint screenCenter = CGPointMake(160.0, 240.0);    
    int index = 0;  
    
    //赋值一个比较大的数,大于屏幕任意两点之间距离
    CGFloat minDistance = kLargeNumber;
    
    for (int i = 0; i < 8; i++)
    {
        CGPoint currentPoint = [self convertPoint:pointArray[i] 
                                           toView:self.superview];
        CGFloat curDistane = sqrtf(powf(currentPoint.x - screenCenter.x, 2) +
                                   powf(currentPoint.y - screenCenter.y, 2));
        if (curDistane <= minDistance)
        {
            minDistance = curDistane;
            index = i;
        }
    }
    
    rotateView_.center = pointArray[index];
}
/**
 * @brief 设置指示视图的位置 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setAccuartePosition:(CGPoint)inPoint
{
    [self setPointPositon];
    int index = 0;
    CGFloat minDistance = kLargeNumber;
    
    CGPoint touchPoint = [self convertPoint:inPoint fromView:self.superview];
    for (int i = 0; i < 8; i++)
    {
        CGPoint currentPoint = pointArray[i];
        CGFloat curDistance = sqrtf(powf(currentPoint.x - touchPoint.x, 2) + 
                                    powf(currentPoint.y - touchPoint.y, 2));
        if (curDistance <= minDistance) 
        {
            minDistance = curDistance;
            index = i;
        }
    }
    rotateView_.center = pointArray[index];    
}
@end
