//
//  GradientView.m
//  Aico
//
//  Created by jiang liyin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.alpha = 0.7;
        // Initialization code
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //Gradient related variables
    CGGradientRef myGradient;
    CGColorSpaceRef myColorSpace;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat colorList[] = 
    {
        //red, green, blue, alpha
        1.0, 0.0, 0.0, 1.0,
        1.0, 0.5, 0.0, 1.0,
        1.0, 1.0, 0.0, 1.0,
        0.0, 1.0, 0.0, 1.0,
        0.0, 0.0, 1.0, 1.0,
        0.0, 1.0, 1.0, 1.0,
        1.0, 0.0, 1.0, 1.0
     
    };
    myColorSpace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents       
    (myColorSpace, colorList, NULL, sizeof(colorList)/(sizeof(colorList[0])*4));
    //Paint a linear gradient
    CGPoint startPoint, endPoint;
    startPoint.x = 0;
    startPoint.y = 0;
    endPoint.x = CGRectGetMaxX(self.bounds);
    endPoint.y = CGRectGetMaxY(self.bounds);

    CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint,0);
    CGColorSpaceRelease(myColorSpace);
    CGGradientRelease(myGradient);
}


@end
