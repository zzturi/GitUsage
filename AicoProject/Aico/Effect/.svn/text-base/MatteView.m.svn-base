//
//  MatteView.m
//  Aico
//
//  Created by cienet on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MatteView.h"
#import "ReUnManager.h"
#import <CoreGraphics/CGContext.h>

@implementation MatteView
@synthesize sourcePicture = sourcePicture_;
@synthesize radius = radius_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        ReUnManager *rum = [ReUnManager sharedReUnManager];
        self.sourcePicture = [rum getGlobalSrcImage];
    }
    return self;
}

- (void)dealloc
{
    self.sourcePicture = nil;
	[super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(sourcePicture_.size);
    CGContextRef thisctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(thisctx, CGRectMake(0, 0, sourcePicture_.size.width, sourcePicture_.size.height), [self.sourcePicture CGImage]);
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[3]= {0,.5,1};
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, (size_t)3);
    //圆形边框，亦可
//    CGContextDrawRadialGradient(thisctx, 
//                                myGradient1, 
//                                CGPointMake(self.frame.size.width/2, self.frame.size.height/2), 
//                                radius_, 
//                                CGPointMake(self.frame.size.width/2, self.frame.size.height/2), 
//                                sqrtf(self.frame.size.width*self.frame.size.width + self.frame.size.height*self.frame.size.height)/2, 
//                                kCGGradientDrawsAfterEndLocation);
    
    if (fabsf(radius_) > 0.000001)
    {
        //矩形边框
        CGContextDrawLinearGradient(thisctx,
                                    myGradient, 
                                    CGPointMake(0, radius_),
                                    CGPointMake(0, 0), 
                                    (CGGradientDrawingOptions)NULL);
        CGContextDrawLinearGradient(thisctx,
                                    myGradient, 
                                    CGPointMake(radius_, 0),
                                    CGPointMake(0, 0), 
                                    (CGGradientDrawingOptions)NULL);
        CGContextDrawLinearGradient(thisctx,
                                    myGradient, 
                                    CGPointMake(sourcePicture_.size.width-radius_, sourcePicture_.size.height), 
                                    CGPointMake(sourcePicture_.size.width, sourcePicture_.size.height),
                                    (CGGradientDrawingOptions)NULL);
        CGContextDrawLinearGradient(thisctx,
                                    myGradient, 
                                    CGPointMake(sourcePicture_.size.width, sourcePicture_.size.height-radius_), 
                                    CGPointMake(sourcePicture_.size.width, sourcePicture_.size.height),
                                    (CGGradientDrawingOptions)NULL);
    }
    
    CGColorSpaceRelease(myColorSpace);
    CGGradientRelease(myGradient);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *npView = [[UIImageView alloc]initWithFrame:self.frame];
    npView.image = newPic;
    //因为坐标系颠倒了，所以在这里相应调整仿射矩阵
    npView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    [self addSubview:npView];
    [npView release];
}

/**
 * @brief 
 * 给颜色数组components[12]赋值
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (void)setComponentsArray:(CGFloat [])array
{
    for (int i = 0; i < kColorComponentArraySize; i++)
    {
        components[i] = array[i];
    }
}

/**
 * @brief 
 * 生成特效列表table cell中的小图片，并返回
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
- (UIImage *)getSmallImage:(UIImage *)inImage
{
    CGFloat component[kColorComponentArraySize]= {1, 1, 1, 0,
                                                  1, 1, 1, 0.75/2,
                                                  1, 1, 1, 0.75};
    [self setComponentsArray:component];
    radius_ = inImage.size.width/3.0;
    self.frame = CGRectMake(0, 0, inImage.size.width, inImage.size.height);
    
    UIImage *image = nil;    
    UIGraphicsBeginImageContext(CGSizeMake(inImage.size.width, inImage.size.height));
    CGContextRef thisctx = UIGraphicsGetCurrentContext();
    
    CGContextRotateCTM(thisctx, M_PI);
    CGContextTranslateCTM(thisctx, -inImage.size.width, 0);
    CGContextScaleCTM(thisctx, -1, 1);
    
    CGContextDrawImage(thisctx, CGRectMake(-inImage.size.width, -inImage.size.height, inImage.size.width, inImage.size.height), [inImage CGImage]);
    
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[3]= {0,.5,1};
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, (size_t)3);
    
    CGContextDrawLinearGradient(thisctx,
                                myGradient, 
                                CGPointMake(0, -radius_),
                                CGPointMake(0, 0), 
                                (CGGradientDrawingOptions)NULL);
    CGContextDrawLinearGradient(thisctx,
                                myGradient, 
                                CGPointMake(-radius_, 0),
                                CGPointMake(0, 0), 
                                (CGGradientDrawingOptions)NULL);
    CGContextDrawLinearGradient(thisctx,
                                myGradient, 
                                CGPointMake(-self.frame.size.width+radius_, self.frame.size.height), 
                                CGPointMake(-self.frame.size.width, self.frame.size.height),
                                (CGGradientDrawingOptions)NULL);
    CGContextDrawLinearGradient(thisctx,
                                myGradient, 
                                CGPointMake(-self.frame.size.width, -self.frame.size.height+radius_), 
                                CGPointMake(-self.frame.size.width, -self.frame.size.height),
                                (CGGradientDrawingOptions)NULL);
    
    CGColorSpaceRelease(myColorSpace);
    CGGradientRelease(myGradient);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
