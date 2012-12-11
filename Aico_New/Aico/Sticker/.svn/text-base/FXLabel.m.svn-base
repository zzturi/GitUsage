//
//  FXLabel.m
//
//  Version 1.3.3
//
//  Created by Nick Lockwood on 20/08/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib license
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#fxlabel
//  https://github.com/nicklockwood/FXLabel
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import <CoreFoundation/CoreFoundation.h>
#import "FXLabel.h"
#import "Common.h"

@interface FXButton ()

@property (nonatomic, assign) NSUInteger minSamples;
@property (nonatomic, assign) NSUInteger maxSamples;

@end


@implementation FXButton

@synthesize shadowBlur;
@synthesize innerShadowOffset;
@synthesize innerShadowColor;
@synthesize gradientColors;
@synthesize gradientStartPoint;
@synthesize gradientEndPoint;
@synthesize oversampling;
@synthesize minSamples;
@synthesize maxSamples;
@synthesize textInsets;

@synthesize fillColor;
@synthesize strokeColor;
@synthesize colorType;

- (void)setDefaults
{
    gradientStartPoint = CGPointMake(0.5f, 0.0f);
    gradientEndPoint = CGPointMake(0.5f, 0.75f);
    minSamples = maxSamples = 1;
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        minSamples = [UIScreen mainScreen].scale;
        maxSamples = 32;
    }
    oversampling = minSamples;
    
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = nil;
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setDefaults];
    }
    return self;
}

- (void)setInnerShadowOffset:(CGSize)offset
{
    if (!CGSizeEqualToSize(innerShadowOffset, offset))
    {
        innerShadowOffset = offset;
        [self setNeedsDisplay];
    }
}

- (void)setInnerShadowColor:(UIColor *)color
{
    if (innerShadowColor != color)
    {
        AH_RELEASE(innerShadowColor);
        innerShadowColor = AH_RETAIN(color);
        [self setNeedsDisplay];
    }
}

- (UIColor *)gradientStartColor
{
    return [gradientColors count]? [gradientColors objectAtIndex:0]: nil;
}

- (void)setGradientStartColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([gradientColors count] < 2)
    {
        self.gradientColors = [NSArray arrayWithObjects:color, color, nil];
    }
    else if ([gradientColors objectAtIndex:0] != color)
    {
        NSMutableArray *colors = [gradientColors mutableCopy];
        [colors replaceObjectAtIndex:0 withObject:color];
        self.gradientColors = colors;
        AH_RELEASE(colors);
    }
}

- (UIColor *)gradientEndColor
{
    return [gradientColors lastObject];
}

- (void)setGradientEndColor:(UIColor *)color
{
    if (color == nil)
    {
        self.gradientColors = nil;
    }
    else if ([gradientColors count] < 2)
    {
        self.gradientColors = [NSArray arrayWithObjects:color, color, nil];
    }
    else if ([gradientColors lastObject] != color)
    {
        NSMutableArray *colors = [gradientColors mutableCopy];
        [colors replaceObjectAtIndex:[colors count] - 1 withObject:color];
        self.gradientColors = colors;
        AH_RELEASE(colors);
    }
}

- (void)setGradientColors:(NSArray *)colors
{
    if (gradientColors != colors)
    {
        AH_RELEASE(gradientColors);
        gradientColors = [colors copy];
        [self setNeedsDisplay];
    }
}

- (void)setOversampling:(NSUInteger)samples
{
    samples = MIN(maxSamples, MAX(minSamples, samples));
    if (oversampling != samples)
    {
		oversampling = samples;
        [self setNeedsDisplay];
    }
}

- (void)setTextInsets:(UIEdgeInsets)insets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(textInsets, insets))
    {
        textInsets = insets;
        [self setNeedsDisplay];
    }
}

- (void)getComponents:(CGFloat *)rgba forColor:(CGColorRef)color
{
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace(color));
    const CGFloat *components = CGColorGetComponents(color);
    switch (model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            rgba[0] = components[0];
            rgba[1] = components[0];
            rgba[2] = components[0];
            rgba[3] = components[1];
            break;
        }
        case kCGColorSpaceModelRGB:
        {
            rgba[0] = components[0];
            rgba[1] = components[1];
            rgba[2] = components[2];
            rgba[3] = components[3];
            break;
        }
        default:
        {
            NSLog(@"Unsupported gradient color format: %i", model);
            rgba[0] = 0.0f;
            rgba[1] = 0.0f;
            rgba[2] = 0.0f;
            rgba[3] = 1.0f;
            break;
        }
    }
}

- (UIColor *)color:(CGColorRef)a blendedWithColor:(CGColorRef)b
{
    CGFloat aRGBA[4];
    [self getComponents:aRGBA forColor:a];
    CGFloat bRGBA[4];
    [self getComponents:bRGBA forColor:b];
    CGFloat source = aRGBA[3];
    CGFloat dest = 1.0f - source;
    return [UIColor colorWithRed:source * aRGBA[0] + dest * bRGBA[0]
                           green:source * aRGBA[1] + dest * bRGBA[1]
                            blue:source * aRGBA[2] + dest * bRGBA[2]
                           alpha:bRGBA[3] + (1.0f - bRGBA[3]) * aRGBA[3]];
}

static const void* TTRetain(CFAllocatorRef allocator, const void *value) { return [(id)value retain]; }
static void TTRelease(CFAllocatorRef allocator, const void *value) { [(id)value release];}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //get drawing context
	if (oversampling > minSamples || (self.backgroundColor && ![self.backgroundColor isEqual:[UIColor clearColor]]))
    {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, oversampling);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //apply insets
    rect = self.bounds;
    rect.origin.x += textInsets.left;
    rect.origin.y += textInsets.top;
    rect.size.width -= (textInsets.left + textInsets.right);
    rect.size.height -= (textInsets.top + textInsets.bottom);
    
    //get label size
    CGRect textRect = rect;
    
    UILabel *label = self.titleLabel;
    CGFloat fontSize = label.font.pointSize;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = UITextAlignmentCenter;
    if (label.adjustsFontSizeToFitWidth && label.numberOfLines == 1)
    {
        textRect.size = [label.text sizeWithFont:label.font
                                    minFontSize:label.minimumFontSize
                                 actualFontSize:&fontSize
                                       forWidth:rect.size.width
                                  lineBreakMode:label.lineBreakMode];
    }
    else
    {
        textRect.size = [label.text sizeWithFont:label.font
                              constrainedToSize:rect.size
                                  lineBreakMode:label.lineBreakMode];
    }
    
    //set font
    UIFont *font = [label.font fontWithSize:fontSize];
    
    //set color
	if (fillColor != nil)
	{
		label.textColor = fillColor;
	}
//    UIColor *highlightedColor = label.highlightedTextColor ?: label.textColor;
//    UIColor *textColor = self.highlighted? highlightedColor: label.textColor;
//    textColor = textColor ?: [UIColor clearColor];
    UIColor *textColor = label.textColor;
	if (textColor == nil)
	{
		textColor = [UIColor clearColor];
	}
	
    //set position
    switch (label.textAlignment)
    {
        case UITextAlignmentCenter:
        {
            textRect.origin.x = rect.origin.x + (rect.size.width - textRect.size.width) / 2.0f;
            break;
        }
        case UITextAlignmentRight:
        {
            textRect.origin.x = textRect.origin.x + rect.size.width - textRect.size.width;
            break;
        }
        default:
        {
            textRect.origin.x = rect.origin.x;
            break;
        }
    }
    switch (self.contentMode)
    {
        case UIViewContentModeTop:
        case UIViewContentModeTopLeft:
        case UIViewContentModeTopRight:
        {
            textRect.origin.y = rect.origin.y;
            break;
        }
        case UIViewContentModeBottom:
        case UIViewContentModeBottomLeft:
        case UIViewContentModeBottomRight:
        {
            textRect.origin.y = rect.origin.y + rect.size.height - textRect.size.height;
            break;
        }
        default:
        {
            textRect.origin.y = rect.origin.y + (rect.size.height - textRect.size.height)/2.0f;
            break;
        }
    }
        
    if (fillColor != nil)
    {
        CGFloat r, g, b, a;
        [Common getRed:&r green:&g blue:&b alpha:&a fromUIColor:fillColor];
        CGContextSetRGBFillColor(context, r, g, b, a);
    }
    if (strokeColor != nil)
    {
        CGFloat r, g, b, a;
        [Common getRed:&r green:&g blue:&b alpha:&a fromUIColor:strokeColor];
        CGContextSetRGBStrokeColor(context, r, g, b, a);
    }
    
    if (fillColor != nil)
    {
        if (strokeColor != nil)
            CGContextSetTextDrawingMode(context, kCGTextFillStroke);
        else
            CGContextSetTextDrawingMode(context, kCGTextFill);
    }
    else if (strokeColor != nil)
        CGContextSetTextDrawingMode(context, kCGTextStroke);
    
    if (fillColor != nil || strokeColor != nil)
    {
        const char *ch = [label.text UTF8String];
        if (ch != NULL)
        {
            CGContextShowTextAtPoint(context, textRect.origin.x, textRect.origin.y, ch, strlen(ch));
        }
    }
    
//	BOOL hasColor = label.shadowColor != nil;
//	BOOL notClearColor = ![label.shadowColor isEqual:[UIColor clearColor]];
//	BOOL blur = shadowBlur > 0.0f || !CGSizeEqualToSize(label.shadowOffset, CGSizeZero);
	
	
    BOOL hasShadow = label.shadowColor &&
    ![label.shadowColor isEqual:[UIColor clearColor]] &&
    (shadowBlur > 0.0f || !CGSizeEqualToSize(label.shadowOffset, CGSizeZero));
    
    BOOL hasInnerShadow = innerShadowColor &&
    ![self.innerShadowColor isEqual:[UIColor clearColor]] &&
    !CGSizeEqualToSize(innerShadowOffset, CGSizeZero);
    
    BOOL hasGradient = [gradientColors count] > 1;
    
    BOOL needsMask = hasInnerShadow || hasGradient;
    
    CGImageRef alphaMask = NULL;
    if (needsMask)
    {
        //draw mask
        CGContextSaveGState(context);
        [label.text drawInRect:textRect withFont:font lineBreakMode:label.lineBreakMode alignment:label.textAlignment];
        CGContextRestoreGState(context);
        
        // Create an image mask from what we've drawn so far
        alphaMask = CGBitmapContextCreateImage(context);
        
        //clear the context
        CGContextClearRect(context, textRect);
    }
    
    if (hasShadow)
    {
        //set up shadow
        CGContextSaveGState(context);
        CGFloat textAlpha = CGColorGetAlpha(textColor.CGColor);
        CGContextSetShadowWithColor(context, label.shadowOffset, shadowBlur, label.shadowColor.CGColor);
        [needsMask? [label.shadowColor colorWithAlphaComponent:textAlpha]: textColor setFill];
        [label.text drawInRect:textRect withFont:font lineBreakMode:label.lineBreakMode alignment:label.textAlignment];
        CGContextRestoreGState(context);
    }
    else if (!needsMask)
    {
        //just draw the text
        [textColor setFill];
        [label.text drawInRect:textRect withFont:font lineBreakMode:label.lineBreakMode alignment:label.textAlignment];
    }
    
    if (needsMask)
    {
        //clip the context
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, rect, alphaMask);
        
        if (hasInnerShadow)
        {
            //fill inner shadow
            [innerShadowColor setFill];
            CGContextFillRect(context, textRect);
            
            //clip to unshadowed part
            CGContextTranslateCTM(context, innerShadowOffset.width, -innerShadowOffset.height);
            CGContextClipToMask(context, rect, alphaMask);
        }
        
        if (hasGradient)
        {
            //create array of pre-blended CGColors
            CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
            callbacks.retain = TTRetain;
            callbacks.release = TTRelease;
            CFMutableArrayRef colors = CFArrayCreateMutable(kCFAllocatorDefault, 0, &callbacks);
//            NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[gradientColors count]];
            for (UIColor *color in gradientColors)
            {
                UIColor *blended = [self color:color.CGColor blendedWithColor:textColor.CGColor];
                CFArrayAppendValue(colors, blended.CGColor);
//                [colors addObject:blended.CGColor];
            }
            
            //draw gradient
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -rect.size.height);
            CGGradientRef gradient = CGGradientCreateWithColors(NULL, colors, NULL);
            CGPoint startPoint = CGPointMake(textRect.origin.x + gradientStartPoint.x * textRect.size.width,
                                             textRect.origin.y + gradientStartPoint.y * textRect.size.height);
            CGPoint endPoint = CGPointMake(textRect.origin.x + gradientEndPoint.x * textRect.size.width,
                                           textRect.origin.y + gradientEndPoint.y * textRect.size.height);
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                        kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
            CGGradientRelease(gradient);
            CFRelease(colors);
        }
        else
        {
            //fill text
            [textColor setFill];
            CGContextFillRect(context, textRect);
        }
        
        //end clipping
        CGContextRestoreGState(context);
        CGImageRelease(alphaMask);
    }
    
    if (oversampling)
    {
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [image drawInRect:rect];
    }
}

- (void)dealloc
{
    self.innerShadowColor   = nil;
    self.gradientStartColor = nil;
    self.gradientEndColor   = nil;
    self.gradientColors     = nil;
    self.fillColor          = nil;
    self.strokeColor        = nil;
    [super dealloc];
}

/**
 * @brief 用指定button的样式更新自己
 *
 * @param [in] button: 指定的button
 * @param [in] fontSize: 显示文字的字体大小
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateFromButton:(FXButton *)button fontSize:(CGFloat)fontSize
{
	UIFont *fontDest = button.titleLabel.font;
    self.titleLabel.font         = [UIFont fontWithName:fontDest.fontName size:fontSize];
	
    self.titleLabel.shadowColor  = button.titleLabel.shadowColor;
    self.titleLabel.shadowOffset = button.titleLabel.shadowOffset;
    
    self.shadowBlur              = button.shadowBlur;
    self.innerShadowOffset       = button.innerShadowOffset;
    self.innerShadowColor        = button.innerShadowColor;
    self.gradientColors          = button.gradientColors;
    self.gradientStartPoint      = button.gradientStartPoint;
    self.gradientEndPoint        = button.gradientEndPoint;
    self.oversampling            = button.oversampling;
    self.textInsets              = button.textInsets;
    self.fillColor               = button.fillColor;
    self.strokeColor             = button.strokeColor;
    self.colorType               = button.colorType;
    
    [self setNeedsDisplay];
}

@end



