//
//  VegnetteView.m
//  Aico
//
//  Created by chentao on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VegnetteView.h"
#import "ReUnManager.h"
#import "Common.h"

@implementation VegnetteView
@synthesize srcImg = srcImg_;
@synthesize radius = radius_;
@synthesize opacityValue = opacityValue_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {       
        self.srcImg = [[ReUnManager sharedReUnManager] getGlobalSrcImage];
        endRadius_ = sqrtf(self.srcImg.size.width*self.srcImg.size.width + self.srcImg.size.height*self.srcImg.size.height)/2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.srcImg.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, self.srcImg.size.width, self.srcImg.size.height), [self.srcImg CGImage]);
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();

    CGFloat colorRgb[12] = {0.03, 0.03, 0.03, 0,
                            0.03, 0.03, 0.03, 0,
                            0.03, 0.03, 0.03, 1};
    
    colorRgb[11] = self.opacityValue;
    CGFloat locations[3]= {0, 0.25, 1};
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(rgb, colorRgb, locations, (size_t)3);
    // 圆形边框
    CGContextDrawRadialGradient(contextRef, 
                                myGradient, 
                                CGPointMake(self.srcImg.size.width/2, self.srcImg.size.height/2), 
                                self.radius, 
                                CGPointMake(self.srcImg.size.width/2, self.srcImg.size.height/2), 
                                endRadius_, 
                                kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(rgb);
    CGGradientRelease(myGradient);
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *newView = [[UIImageView alloc] initWithFrame:self.frame];
    newView.image = newImg;
    // 调整纵坐标
    newView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    [self addSubview:newView];
    [newView release];
}
/**
 * @brief 
 * 生成特效列表界面的小图片
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (UIImage *)getEffectSmallImage:(UIImage *)img
{
    float Rmin =  MIN(img.size.width, img.size.height)/20;
    float Rmax = sqrtf(img.size.width * img.size.width + img.size.height * img.size.height)/2;

    UIGraphicsBeginImageContext(img.size);
    UIImage *newImg = nil;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // 变换图像上下文坐标
    CGContextScaleCTM(contextRef, 1, -1);
    CGContextTranslateCTM(contextRef, 0, -img.size.height);    
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, img.size.width, img.size.height), [img CGImage]);
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorRgb[12] = {0.03, 0.03, 0.03, 0,
                            0.03, 0.03, 0.03, 0,
                            0.03, 0.03, 0.03, 0.2};
    CGFloat locations[3]= {0, 0.25, 1};
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(rgb, colorRgb, locations, (size_t)3);
    // 圆形边框
    CGContextDrawRadialGradient(contextRef, 
                                myGradient, 
                                CGPointMake(self.srcImg.size.width/2, self.srcImg.size.height/2), 
                                (Rmax+0.21*(Rmin-Rmax)), 
                                CGPointMake(self.srcImg.size.width/2, self.srcImg.size.height/2), 
                                sqrtf(self.srcImg.size.width*self.srcImg.size.width + self.srcImg.size.height*self.srcImg.size.height)/2, 
                                kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(rgb);
    CGGradientRelease(myGradient);    
        
    newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    
    return newImg;
}

- (void)dealloc
{
    self.srcImg = nil;
    [super dealloc];
}
@end
