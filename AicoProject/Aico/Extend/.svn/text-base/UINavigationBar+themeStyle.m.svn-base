//
//  UINavigationBar+themeStyle.m
//  DSM_iPad
//
//  Created by Wang Dean on 11-8-31.
//  Copyright 2011 cienet. All rights reserved.
//

#import "UINavigationBar+themeStyle.h"


@implementation UINavigationBar (UINavigationBar_themeStyle)

- (void)drawRect:(CGRect)rect {
    
	//颜色填充
    //	UIColor *color = [UIColor redColor];
    //	CGContextRef context = UIGraphicsGetCurrentContext();
    //	CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    //	CGContextFillRect(context, rect);
    //	self.tintColor = color;
    
    //UIColor *color = [UIColor colorWithRed:46.0f/255.0f green:87.0f/255.0f blue:29.0f/255.0f alpha:1.0f];
    
	//图片填充
    UIImage *img = [UIImage imageNamed: @"navigationbarBkg.png"];
    [img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

}

@end

