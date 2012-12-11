//
// Scratch and See 
//
// The project provides en effect when the user swipes the finger over one texture 
// and by swiping reveals the texture underneath it. The effect can be applied for 
// scratch-card action or wiping a misted glass.
//
// Copyright (C) 2012 http://moqod.com Andrew Kopanev <andrew@moqod.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do so, 
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//

#import "ImageMaskView.h"
#import "PointTransforms.h"

@interface ImageMaskView()

- (UIImage *)addTouches:(UITouch *)touch;

@property (nonatomic,assign) int undoNumber;
@property (nonatomic,assign) int redoNumber;
@property (nonatomic) CGContextRef imageContext;
@property (nonatomic) CGColorSpaceRef colorSpace;
@end

@implementation ImageMaskView
@synthesize imageMaskFilledDelegate;
@synthesize radius,type;
@synthesize undoNumber,redoNumber;
@synthesize imageContext,colorSpace;
@synthesize touchesData = touchesData_;
@synthesize srcImage = srcImage_;

#pragma mark - memory management

- (void)dealloc 
{
	CGColorSpaceRelease(self.colorSpace);
	CGContextRelease(self.imageContext);
    [touchesArray_ release];
    [super dealloc];
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img
{
    if (self = [super initWithFrame:frame]) 
    {
        // Initialization code
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		self.imageMaskFilledDelegate = nil;
		
		self.image = img;
        self.srcImage = img;
		CGSize size = self.image.size;
		self.radius = 5.0;
        self.type = NO;
        
		// initalize bitmap context
		self.colorSpace = CGColorSpaceCreateDeviceRGB();
		self.imageContext = CGBitmapContextCreate(0, size.width, size.height, 8, size.width*4, colorSpace, kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(self.imageContext, CGRectMake(0, 0, size.width, size.height), self.image.CGImage);
		
		int blendMode = kCGBlendModeClear;
		CGContextSetBlendMode(self.imageContext, (CGBlendMode) blendMode);
				
        self.undoNumber = 0;
        self.redoNumber = 0;
        
        touchesArray_ = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark -
- (CGFloat)procentsOfImageMasked 
{
	return 100.0;
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1)
    {
        //能redo的时候进行操作，需要将redo后面部分清除
        if (self.redoNumber > 0)
        {
            for (int i=0; i<self.redoNumber; i++) 
            {
                if ([touchesArray_ count] > 0)
                {
                    [touchesArray_ removeLastObject];
                }
                
            }
            self.redoNumber = 0;
        }
        self.undoNumber++;
        
        UITouch *touch = [touches anyObject];
        self.image = [self addTouches:touch];
        //添加触摸操作记录
        touchesData_ = [[TouchesData alloc] init]; 
        self.touchesData.brushType = self.type;     //保存笔刷类型
        self.touchesData.brushRadius = self.radius; //保存笔刷大小
        [self.touchesData addLastPoint:[touch locationInView:self]]; //添加触摸点
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[event allTouches]count] == 1)
    {
        UITouch *touch = [touches anyObject];
        self.image = [self addTouches:touch];
        
        [self.touchesData addLastPoint:[touch locationInView:self]];//添加触摸点
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesData != nil) 
    {
        if ([self.touchesData.pointArray count] > 0)
        {
            [touchesArray_ addObject:self.touchesData];
        }
        self.touchesData = nil;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesData != nil) 
    {
        if ([self.touchesData.pointArray count] > 0)
        {
            [touchesArray_ addObject:self.touchesData];
        }
        self.touchesData = nil;
    } 
}

#pragma mark -
- (UIImage *)addTouches:(UITouch *)touch
{
	CGSize size = self.image.size;
	CGContextRef ctx = self.imageContext;
	
	CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
	
    CGContextBeginPath(ctx);
        
    CGFloat width = radius * self.image.size.width / self.bounds.size.width;
    CGFloat height = radius * self.image.size.height / self.bounds.size.height;
    
    CGRect rect = {[touch locationInView:self], {2*width, 2*height}};
    rect.origin = fromUItoQuartz(rect.origin, self.bounds.size);
		
    if(UITouchPhaseBegan == touch.phase)
    {
        firstPoint = [touch locationInView:self];
        // on begin, we just draw ellipse
        
        rect.origin = scalePoint(rect.origin, self.bounds.size, size);
        
        rect.origin.y -= width;
        rect.origin.x -= height;
        
        //画画矩形或者圆形
        self.type ? (CGContextAddRect(ctx, rect)) : (CGContextAddEllipseInRect(ctx, rect));
        
        CGContextFillPath(ctx);
    }
    else if(UITouchPhaseMoved == touch.phase)
    {
        // then touch moved, we draw superior-width line
        rect.origin = scalePoint(rect.origin, self.bounds.size, size);
        CGPoint prevPoint = [touch previousLocationInView:self];
        prevPoint = fromUItoQuartz(prevPoint, self.bounds.size);
        prevPoint = scalePoint(prevPoint, self.bounds.size, size);
        
        firstPoint = fromUItoQuartz(firstPoint, self.bounds.size);
        firstPoint = scalePoint(firstPoint, self.bounds.size, size);
        
        if (!self.type) 
        {
            CGContextSetStrokeColor(ctx,CGColorGetComponents([UIColor yellowColor].CGColor));
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetLineWidth(ctx, 2*width);
            CGContextMoveToPoint(ctx, prevPoint.x, prevPoint.y);
            CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
            CGContextStrokePath(ctx);
        }
        else 
        {
            CGContextSetStrokeColor(ctx,CGColorGetComponents([UIColor yellowColor].CGColor));
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetLineWidth(ctx, 2*width);
            CGContextMoveToPoint(ctx,firstPoint.x, firstPoint.y);
            CGContextMoveToPoint(ctx, prevPoint.x, prevPoint.y);
            CGContextAddLineToPoint(ctx, rect.origin.x, rect.origin.y);
            CGContextStrokePath(ctx);
            firstPoint = prevPoint;
        }			
    } 
    
    [self.imageMaskFilledDelegate imageMaskView:self cleatPercentWasChanged:[self procentsOfImageMasked]];
	
	CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	
	return image;
}

/**
 * @brief 根据操作数据，进行绘制操作
 * @param [in] TouchesData:图片绘制需要的数据信息
 * @param [out]
 * @return
 * @note 
 */
- (void)drawOperation:(TouchesData *)data
{
    CGContextRef ctx = self.imageContext;
    CGContextSetFillColorWithColor(ctx,[UIColor clearColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor);
    CGContextBeginPath(ctx);
    
    CGFloat width = data.brushRadius * self.image.size.width / self.bounds.size.width;
    CGFloat height = data.brushRadius * self.image.size.height / self.bounds.size.height;
    
    if (data.brushType) //矩形
    {
        //画点
        if ([data.pointArray count] == 1) 
        {
            CGRect rect = {[data getLastPoint], {2*width, 2*height}};
            rect.origin = fromUItoQuartz(rect.origin, self.bounds.size);
            rect.origin = scalePoint(rect.origin, self.bounds.size, self.image.size);
            
            rect.origin.y -= width;
            rect.origin.x -= height;
            
            CGContextAddRect(ctx, rect);
            CGContextFillPath(ctx);
        }
        //画线
        else
        {
            CGContextSetStrokeColor(ctx,CGColorGetComponents([UIColor yellowColor].CGColor));
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetLineWidth(ctx, 2*width);
            
            CGPoint beginPoint = [data getPointAtIndex:0];
            beginPoint = fromUItoQuartz(beginPoint, self.bounds.size);
            beginPoint = scalePoint(beginPoint, self.bounds.size, self.image.size);
            CGContextMoveToPoint(ctx, beginPoint.x, beginPoint.y);
            
            for (int i=1; i<[data.pointArray count]; i++) 
            {
                CGPoint pointTmp = [data getPointAtIndex:i];
                pointTmp = fromUItoQuartz(pointTmp, self.bounds.size);
                pointTmp = scalePoint(pointTmp, self.bounds.size, self.image.size);
                CGContextAddLineToPoint(ctx, pointTmp.x, pointTmp.y);
            }
            CGContextStrokePath(ctx);
        }
    }
    else //圆形
    {
        //画点
        if ([data.pointArray count] == 1) 
        {
            CGRect rect = {[data getLastPoint], {2*width, 2*height}};
            rect.origin = fromUItoQuartz(rect.origin, self.bounds.size);
            rect.origin = scalePoint(rect.origin, self.bounds.size, self.image.size);
            
            rect.origin.y -= width;
            rect.origin.x -= height;
            
            CGContextAddEllipseInRect(ctx, rect);
            CGContextFillPath(ctx);
        }
        //画线
        else
        {
            CGContextSetStrokeColor(ctx,CGColorGetComponents([UIColor yellowColor].CGColor));
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetLineWidth(ctx, 2*width);
        
            CGPoint beginPoint = [data getPointAtIndex:0];
            beginPoint = fromUItoQuartz(beginPoint, self.bounds.size);
            beginPoint = scalePoint(beginPoint, self.bounds.size, self.image.size);
            CGContextMoveToPoint(ctx, beginPoint.x, beginPoint.y);
            
            for (int i=1; i<[data.pointArray count]; i++) 
            {
                CGPoint pointTmp = [data getPointAtIndex:i];
                pointTmp = fromUItoQuartz(pointTmp, self.bounds.size);
                pointTmp = scalePoint(pointTmp, self.bounds.size, self.image.size);
                CGContextAddLineToPoint(ctx, pointTmp.x, pointTmp.y);
            }
            CGContextStrokePath(ctx);
        }
    }
}

/**
 * @brief 撤销恢复操作管理
 * @param [in] managerType:YES/撤销 NO/恢复
 * @param [out] 返回操作后的图片
 * @return
 * @note 
 */
- (UIImage *)undoManagerOperation:(BOOL)managerType
{
    //undo操作其实就是使用原图，再进行绘图操作
    if (managerType) 
    {
        CGContextRelease(self.imageContext);
        self.imageContext = CGBitmapContextCreate(0, self.srcImage.size.width, self.srcImage.size.height, 8, self.srcImage.size.width*4, colorSpace, kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(self.imageContext, CGRectMake(0, 0, self.srcImage.size.width, self.srcImage.size.height), self.srcImage.CGImage);
		CGContextSetBlendMode(self.imageContext, (CGBlendMode) kCGBlendModeClear);
    }
    
    if (managerType)
    {
        for (int i=0; i<self.undoNumber-1; i++) 
        {
            if ([touchesArray_ count] > i)
            {
                [self drawOperation:[touchesArray_ objectAtIndex:i]];
            }
        }
        --self.undoNumber;
        ++self.redoNumber;
    }
    else
    {
        if ([touchesArray_ count] > self.undoNumber && 
            self.undoNumber >= 0)
        {
            [self drawOperation:[touchesArray_ objectAtIndex:self.undoNumber]];
        }
        --self.redoNumber;
        ++self.undoNumber;
    }
    
    [self.imageMaskFilledDelegate imageMaskView:self cleatPercentWasChanged:[self procentsOfImageMasked]];
	
	CGImageRef cgImage = CGBitmapContextCreateImage(self.imageContext);
	UIImage *image = [UIImage imageWithCGImage:cgImage];
	CGImageRelease(cgImage);
	
	return image;
}

/**
 * @brief 执行undo(撤销)操作
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undo
{
    if ([self canUndo]) 
    {
        self.image = [self undoManagerOperation:YES];
    }
}

/**
 * @brief 执行redo(恢复)操作
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redo
{
    if ([self canRedo]) 
    {
        self.image = [self undoManagerOperation:NO];
    }
}

/**
 * @brief 当前能否进行撤销操作
 * @param [in]
 * @param [out] YES:可以撤销 NO:不能撤销
 * @return
 * @note 
 */
- (BOOL)canUndo
{
    return (self.undoNumber>0)?YES:NO;
}

/**
 * @brief 当前能否进行恢复操作
 * @param [in]
 * @param [out] YES:可以恢复 NO:不能恢复
 * @return
 * @note 
 */
- (BOOL)canRedo
{
    return (self.redoNumber>0)?YES:NO;
}
@end
