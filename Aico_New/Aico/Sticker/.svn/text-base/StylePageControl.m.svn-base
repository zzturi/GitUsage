//
//  StylePageControl.m
//  Aico
//
//  Created by dai ye on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StylePageControl.h"

@interface StylePageControl(private)
/**
 * @brief 更新显示所有点
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateDots;
@end

@implementation StylePageControl

@synthesize normalImage = normalImage_;
@synthesize selectedImage = selectedImage_;


- (id)initWithFrame:(CGRect)frame 
{ 
    self = [super initWithFrame:frame];
    return self;
}

/**
 * @brief 设置正常状态点的图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)setNormalImage:(UIImage *)normalImage 
{  
    if(normalImage_ != normalImage)
    {
        [normalImage_ release];
        normalImage_ = [normalImage retain];
        [self updateDots];
    }
}

/**
 * @brief 设置选中状态点的图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)setSelectedImage:(UIImage *)selectedImage 
{ 
    if(selectedImage_ != selectedImage)
    {
        [selectedImage_ release];
        selectedImage_ = [selectedImage retain];
        [self updateDots];
    }
}

/**
 * @brief 设置点击事件
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{ 
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

/**
 * @brief 更新显示所有点
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateDots 
{ 
    if (normalImage_ || selectedImage_)
    {
        NSArray *subview = self.subviews;  
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIImageView *dot = [subview objectAtIndex:i];  
            if (i == self.currentPage)  dot.image = selectedImage_;
            else dot.image = normalImage_;
        }
    }
}

- (void)dealloc 
{ 
    [normalImage_ release];
	normalImage_ = nil;
	[selectedImage_ release];
	selectedImage_ = nil;
    [super dealloc];
}

@end

