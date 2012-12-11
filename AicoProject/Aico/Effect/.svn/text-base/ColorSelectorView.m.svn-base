//
//  ColorSelectorView.m
//  Aico
//
//  Created by cienet on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColorSelectorView.h"

@implementation ColorSelectorView
@synthesize colorArray = colorArray_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *cover = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reflectBar.png"]];
        [self addSubview:cover];
        [cover release];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4]; 
    }
    return self;
}

- (void)dealloc
{
    self.colorArray = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    int count = [colorArray_ count];
    CGFloat *components = malloc(sizeof(CGFloat)*4*count);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < count; ++i) 
    {
		UIColor *color = [self.colorArray objectAtIndex:i];
		const CGFloat *rgba = CGColorGetComponents(color.CGColor);
        components[i*4] = rgba[0];
        components[i*4+1] = rgba[1];
        components[i*4+2] = rgba[2];
        components[i*4+3] = rgba[3];
	}
	CGGradientRef gradient = CGGradientCreateWithColorComponents(CGBitmapContextGetColorSpace(context), 
                                                                 components,
                                                                 nil, 
                                                                 count);
	CGContextDrawLinearGradient(context, 
                                gradient, 
                                CGPointZero, 
                                CGPointMake(rect.origin.x +rect.size.width, rect.origin.y),
                                kCGGradientDrawsAfterEndLocation);
    free(components);
    CGGradientRelease(gradient);
}
@end
