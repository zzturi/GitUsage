//
//  EraseView.m
//  Aico
//
//  Created by Yin Cheng on 7/30/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import "EraseView.h"
#import "ImageInfo.h"
#import "PointTransforms.h"

@implementation EraseView
@synthesize srcImage = srcImage_;
@synthesize brushMode = brushMode_;
@synthesize brushType = brushType_;
@synthesize brushRadius = brushRadius_;
@synthesize brushOpacity = brushOpacity_;
@synthesize touchesData = touchesData_;
@synthesize undoNumber = undoNumber_;
@synthesize redoNumber = redoNumber_;
@synthesize delegate = delegate_;

#pragma mark - init && destroy
/**
 * @brief 初始化 
 * @param [in] frame image
 * @param [out]
 * @return
 * @note 
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.srcImage = img;
        self.brushMode = YES; //yes:erase no:restore
        self.brushType = YES; //yes:round no:square
        self.brushRadius = 5.0f;
        self.brushOpacity = 0;
        
        self.image = self.srcImage;
        self.userInteractionEnabled = YES;
        
        imageInfo_ = [[ImageInfo UIImageToImageInfo:self.srcImage] clone];
        sourceInfo_ = [imageInfo_ clone];
        touchesArray_ = [[NSMutableArray alloc] initWithCapacity:0];
        self.undoNumber = 0;
        self.redoNumber = 0;
        drawType_ = YES;
    }
    return self;
}

/**
 * @brief 析构 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
- (void)dealloc
{
    self.srcImage = nil;
    self.touchesData = nil;
    if ([imageInfo_ isValid]) 
    {
        [imageInfo_ release];
    }
    if ([sourceInfo_ isValid]) 
    {
        [sourceInfo_ release];
    }
    
    [touchesArray_ release];
    [super dealloc];
}

#pragma mark - Core components - draw line or point
/**
 * @brief 橡皮擦核心功能 -- 画点操作
 * @param [in] point:操作点
 *             mode:橡皮擦模式 YES/擦除 NO/反擦除
 *             type:橡皮擦笔刷类型 YES/圆形 NO/正方形
 *             radius:橡皮擦笔刷大小 
 *             opacity:橡皮擦笔刷透明度 0~255
 * @param [out] nil
 * @return
 * @note 
 */
- (void)drawPoint:(CGPoint)point
             mode:(BOOL)mode
             type:(BOOL)type 
           radius:(CGFloat)radius
          opacity:(int)opacity
{
    int width	= imageInfo_.width;
	int height	= imageInfo_.height;
	int stride	= imageInfo_.bytesPerRow;
	int bpp		= imageInfo_.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *data	= imageInfo_.data;
    
    CGFloat ratioWidth = width / self.bounds.size.width;
    CGFloat ratioHeight = height / self.bounds.size.height;
    
    /* 
     *   此处需要进行说明：由于EraseView(self)transform进行了改变，radius已EraseView的父视图为基准故
     * 需要从EraseView的父视图进行定位。
     */
    CGPoint superPoint = [self convertPoint:point toView:self.superview];
    CGRect superRect = CGRectMake(superPoint.x - radius, superPoint.y - radius, 2 * radius, 2 * radius);
    CGRect newRect_ = [self convertRect:superRect fromView:self.superview];
    NSLog(@"point:newRect_ is %f,%f",newRect_.size.width / 2,newRect_.size.width / 2);
    
    CGFloat newW,newH;
    
    int i,j;
    CGFloat length,w1,w2,h1,h2;
    
    w1 = point.x - newRect_.size.width * 0.5;
    w2 = point.x + newRect_.size.width * 0.5;
    h1 = point.y - newRect_.size.width * 0.5;
    h2 = point.y + newRect_.size.width * 0.5;
    
    if (mode)
    {
        if (type)//round 
        {
            for (i=0; i < height; ++i) 
            {
                newH = i / ratioHeight;
                for (j=0; j < width; ++j) 
                {
                    newW = j / ratioWidth;
                    
                    if (newH >= h1 && newH <= h2 && newW >= w1 && newW <= w2)
                    {
                        length = sqrtf(powf((newW - point.x), 2) + powf((newH - point.y), 2));
                        BOOL roundFlag =  (length <= (newRect_.size.width * 0.5)) ? YES : NO;
                        if (roundFlag)
                        {
                            data[0] = data[0] * opacity / 255.0;   
                            data[1] = data[1] * opacity / 255.0;  
                            data[2] = data[2] * opacity / 255.0;  
                            data[3] = data[3] * opacity / 255.0;    
                        }
                    }
                    data += bpp;
                }
                data += offset;
            }
        }
        else //擦除---矩形
        {
            for (int i=0; i < height; ++i) 
            {
                newH = i / ratioHeight;
                for (int j=0; j < width; ++j) 
                {
                    newW = j / ratioWidth;
                    
                    CGPoint newPoint = [self convertPoint:CGPointMake(newW, newH) toView:self.superview];
                    
                    if (CGRectContainsPoint(superRect, newPoint)) 
                    {
                        data[0] = data[0] * opacity / 255.0;  
                        data[1] = data[1] * opacity / 255.0;  
                        data[2] = data[2] * opacity / 255.0;  
                        data[3] = data[3] * opacity / 255.0; 
                    }
                    data += bpp;
                }
                data += offset;
            }
        }
    }
    else
    {
        ImageInfo *oldInfo = [sourceInfo_ retain];
        unsigned char *oldData = oldInfo.data;
        
        if (type) //恢复---圆形
        {
            for (i=0; i < height; ++i) 
            {
                newH = i / ratioHeight;
                for (j=0; j < width; ++j) 
                {
                    newW = j / ratioWidth;
                    
                    if (newH >= h1 && newH <= h2 && newW >= w1 && newW <= w2)
                    {
                        length = sqrtf(powf((newW - point.x), 2) + powf((newH - point.y), 2));
                        BOOL roundFlag =  (length <= (newRect_.size.width * 0.5)) ? YES : NO;
                        if (roundFlag)
                        {
                            for (int k=0; k<4; ++k)
                            {
                                int newdata = fminf(oldData[k],(data[k] + oldData[k] * (255 - opacity) / 255.0));
                                data[k] = newdata;
                            }   
                        }
                    }
                    data += bpp;
                    oldData += bpp;
                }
                data += offset;
                oldData += offset;
            }
        }
        else //恢复---矩形
        {
            for (int i=0; i < height; ++i) 
            {
                newH = i / ratioHeight;
                for (int j=0; j < width; ++j) 
                {
                    newW = j / ratioWidth;
                    
                    CGPoint newPoint = [self convertPoint:CGPointMake(newW, newH) toView:self.superview];
                    
                    if (CGRectContainsPoint(superRect, newPoint)) 
                    {
                        for (int k=0; k<4; ++k)
                        {
                            int newdata = fminf(oldData[k],(data[k] + oldData[k] * (255 - opacity) / 255.0));
                            data[k] = newdata;
                        } 
                    }
                    data += bpp;
                    oldData += bpp;
                }
                data += offset;
                oldData += offset;
            }
        }
        [oldInfo release];
    }
}

/**
 * @brief 橡皮擦核心功能 -- 画线操作
 * @param [in] previousPoint:上一个操作点
 *             currentPoint:当前操作点
 *             mode:橡皮擦模式 YES/擦除 NO/反擦除
 *             type:橡皮擦笔刷类型 YES/圆形 NO/正方形
 *             radius:橡皮擦笔刷大小 
 *             opacity:橡皮擦笔刷透明度 0~255
 * @param [out] nil
 * @return
 * @note 
 */
- (void)drawLine:(CGPoint)previousPoint 
            currentPoint:(CGPoint)currentPoint
                    mode:(BOOL)mode
                    type:(BOOL)type 
                  radius:(CGFloat)radius
                 opacity:(int)opacity
{
    int width	= imageInfo_.width;
	int height	= imageInfo_.height;
	int stride	= imageInfo_.bytesPerRow;
	int bpp		= imageInfo_.bytesPerPixel;
	int offset	= stride - width * bpp;
	unsigned char *data	= imageInfo_.data;
    
    CGFloat ratioWidth = width / self.bounds.size.width;
    CGFloat ratioHeight = height / self.bounds.size.height;
    
    /* 
     *   此处需要进行说明：由于EraseView(self)transform进行了改变，radius已EraseView的父视图为基准故
     * 需要从EraseView的父视图进行定位。
     */
    CGRect newRect = [self convertRect:CGRectMake(0, 0, radius, radius) fromView:self.superview];
    radius = newRect.size.width;
    
    NSLog(@"Line: newRect is %f,%f",newRect.size.width,newRect.size.height);
    
    CGPoint p1 = previousPoint;
    CGPoint p2 = currentPoint;
    
    CGFloat rake1 = (p2.y-p1.y)/(p2.x-p1.x);
    CGFloat rake2 = -1/rake1;
    
    CGFloat a0,a1,a2,a3;
    CGFloat b0,b1,b2,b3;
    CGFloat c0,c1,c2,c3;
    
    a0 = a2 = -1 * rake1;
    a1 = a3 = -1 * rake2;
    
    b0 = b1 = b2 = b3 = 1;
    
    CGFloat off = sqrtf(powf((radius), 2) + powf((rake1*radius), 2));
    
    c0 = rake1 * p1.x - p1.y + off;
    c2 = rake1 * p1.x - p1.y - off;
    
    c1 = -1 * a1 * p1.x - b1 * p1.y;
    c3 = -1 * a3 * p2.x - b3 * p2.y;

    CGFloat newArray[3][4] = {
        a0,a1,a2,a3,
        b0,b1,b2,b3,
        c0,c1,c2,c3,
    };
    
    int i,j,k;
    CGFloat length,newW,newH,w1,w2,h1,h2;
    
    w1 = fminf(previousPoint.x, currentPoint.x) - radius;
    w2 = fmaxf(previousPoint.x, currentPoint.x) + radius;
    h1 = fminf(previousPoint.y, currentPoint.y) - radius;
    h2 = fmaxf(previousPoint.y, currentPoint.y) + radius;
    
    if (mode) //erase
    {
        if (type)//round 
        {
            for (i=0; i < height; ++i) 
            {
                newH = i / ratioHeight;
                for (j=0; j < width; ++j) 
                {
                    newW = j / ratioWidth;
                    
                    if (newH >= h1 && newH <= h2 && newW >= w1 && newW <= w2)
                    {
                        length = sqrtf(powf((newW - previousPoint.x), 2) + powf((newH - previousPoint.y), 2));
                        BOOL squareFlag = pointInRec(newArray,CGPointMake(newW, newH));
                        BOOL roundFlag =  (length <= radius) ? YES : NO;
                        
                        if (squareFlag || roundFlag)
                        {
                            data[0] = data[0] * opacity / 255.0;  
                            data[1] = data[1] * opacity / 255.0;  
                            data[2] = data[2] * opacity / 255.0;  
                            data[3] = data[3] * opacity / 255.0;    
                        }
                    }
                    data += bpp;
                }
                data += offset;
            }
        }
        else //square
        {
            for (i=0; i < height; ++i) 
            {
                newH = i / ratioHeight;
                for (j=0; j < width; ++j) 
                {
                    newW = j / ratioWidth;
                    
                    if (newH >= h1 && newH <= h2 && newW >= w1 && newW <= w2)
                    {                        
                        BOOL squareFlag = NO;
                        
                        if (!CGPointEqualToPoint(previousPoint,CGPointZero)) 
                        {
                            squareFlag = pointInRec(newArray,CGPointMake(newW, newH));
                        }
                        if (squareFlag)
                        {
                            data[0] = data[0] * opacity / 255.0;  
                            data[1] = data[1] * opacity / 255.0;  
                            data[2] = data[2] * opacity / 255.0;  
                            data[3] = data[3] * opacity / 255.0;    
                        }
                    }
                    data += bpp;
                }
                data += offset;
            }
        }
    }
    else // restore
    {
        ImageInfo *oldInfo = [sourceInfo_ retain];
        unsigned char *oldData = oldInfo.data;
        
        if (type) //round 
        {
            for (int i=0; i<height; i++) 
            {
                newH = i / ratioHeight;
                for (int j=0; j<width; j++) 
                {
                    newW = j / ratioWidth;
                    
                    if (newH >= h1 && newH <= h2 && newW >= w1 && newW <= w2)
                    {
                        length = sqrtf(powf((newW - currentPoint.x), 2) + powf((newH - currentPoint.y), 2));
                        
                        BOOL squareFlag = NO;
                        BOOL roundFlag = (length <= radius) ? YES : NO;
                        
                        if (!CGPointEqualToPoint(previousPoint,CGPointZero)) 
                        {
                            squareFlag = pointInRec(newArray,CGPointMake(newW, newH));
                        }
                        if (squareFlag || roundFlag)
                        {
                            for (k=0; k<4; k++) 
                            {
                                int newdata = fminf(oldData[k],(data[k] + oldData[k] * (255 - opacity) / 255.0));
                                data[k] = newdata;
                            } 
                        }
                    }
                    data += bpp;
                    oldData += bpp;
                }
                data += offset;
                oldData += offset;
            }
        }
        else // square
        {
            for (int i=0; i<height; i++) 
            {
                for (int j=0; j<width; j++) 
                {
                    ///??????????????
                    data += bpp;
                    oldData += bpp;
                }
                data += offset;
                oldData += offset;
            }
        }
        [oldInfo release];
    }
}

#pragma mark - Touches Gestures
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1)
    {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
                
        if (CGRectContainsPoint(self.bounds, point)) 
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
            
            touchesData_ = [[TouchesData alloc] init];
            self.touchesData.brushType = self.brushType;      //保存笔刷类型
            self.touchesData.brushRadius = self.brushRadius;  //保存笔刷大小
            self.touchesData.brushMode = self.brushMode;      //保存笔刷模式
            self.touchesData.brushOpacity = self.brushOpacity;//保存笔刷透明度
            [self.touchesData addLastPoint:point];            //添加触摸点
            
            //check redo & undo alright
            [self.delegate eraseImageViewHasChanged];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self];
        
        CGPoint previousPoint = [touch previousLocationInView:self];
        
        if (CGRectContainsPoint(self.bounds, currentPoint)) 
        {
            [self drawLine:previousPoint currentPoint:currentPoint mode:self.brushMode type:self.brushType radius:self.brushRadius opacity:self.brushOpacity];
            [self.touchesData addLastPoint:currentPoint];//添加触摸点
            self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
        }
        drawType_ = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesData != nil) 
    {
        if ([self.touchesData.pointArray count] > 0)
        {
            //画单个圆形
            if (self.touchesData.brushType)
            {
                [self drawPoint:[self.touchesData getLastPoint] mode:self.touchesData.brushMode type:self.touchesData.brushType radius:self.touchesData.brushRadius opacity:self.touchesData.brushOpacity];
                self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
            }
            else
            {
                //画点操作
                if (drawType_) 
                {
                    [self drawPoint:[self.touchesData getLastPoint] mode:self.touchesData.brushMode type:self.touchesData.brushType radius:self.touchesData.brushRadius opacity:self.touchesData.brushOpacity];
                    self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
                }
            }
            
            [touchesArray_ addObject:self.touchesData];
        }
        NSLog(@"Now tochesData has:%d",[self.touchesData.pointArray count]);
        self.touchesData = nil;
    }
    drawType_ = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesData != nil) 
    {
        if ([self.touchesData.pointArray count] > 0)
        {
            //画单个圆形
            if (self.touchesData.brushType)
            {
                [self drawPoint:[self.touchesData getLastPoint] mode:self.touchesData.brushMode type:self.touchesData.brushType radius:self.touchesData.brushRadius opacity:self.touchesData.brushOpacity];
                self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
            }
            else
            {
                //画点操作
                if (drawType_) 
                {
                    [self drawPoint:[self.touchesData getLastPoint] mode:self.touchesData.brushMode type:self.touchesData.brushType radius:self.touchesData.brushRadius opacity:self.touchesData.brushOpacity];
                    self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
                }
            }
            [touchesArray_ addObject:self.touchesData];
        }
        self.touchesData = nil;
    }
    drawType_ = YES;
}

#pragma mark - Undo&Redo manager operation
/**
 * @brief 撤销恢复操作管理
 * @param [in] managerType:YES/撤销 NO/恢复
 * @param [out] 返回操作后的图片
 * @return
 * @note 
 */
- (void)undoManagerOperation:(BOOL)managerType
{
    //undo操作其实就是使用原图，再进行绘图操作
    if (managerType) 
    {
        if ([imageInfo_ isValid]) 
        {
            [imageInfo_ release];
        }
        imageInfo_ = [sourceInfo_ clone];
    }
    
    if (managerType)
    {
        for (int i=0; i<self.undoNumber-1; ++i) 
        {
            if ([touchesArray_ count] > i)
            {
                TouchesData *tdata = [touchesArray_  objectAtIndex:i];
                NSInteger count = [tdata countOfPoint];
                if (count != 0) 
                {
                    BOOL mode = tdata.brushMode;
                    BOOL type = tdata.brushType;
                    CGFloat radius = tdata.brushRadius;
                    int opacity = tdata.brushOpacity;
                    
                    //draw line
                    if ([tdata.pointArray count] > 1)
                    {
                        for (int j=1; j<[tdata.pointArray count]; j++)
                        {
                            CGPoint prev,current;
                            prev = [tdata getPointAtIndex:j-1];
                            current = [tdata getPointAtIndex:j];
                            [self drawLine:prev currentPoint:current mode:mode type:type radius:radius opacity:opacity];
                        }
                        //draw last point
                        [self drawPoint:[tdata getLastPoint] mode:mode type:type radius:radius opacity:opacity];
                    }
                    //draw point
                    else
                    {
                        [self drawPoint:[tdata getLastPoint] mode:mode type:type radius:radius opacity:opacity];
                    }
                }
                else
                {
                    [self transformAlphaFromViewToPixel:tdata.alpha];
                }
            }
        }
        
        --self.undoNumber;
        ++self.redoNumber;
    }
    else
    {
        if ([touchesArray_ count] >= self.undoNumber && 
            [touchesArray_ count] > 0 &&
            self.undoNumber >= 0)
        {
            TouchesData *tdata = [touchesArray_  objectAtIndex:self.undoNumber];
            
            NSInteger count = [tdata countOfPoint];
            if (count != 0) 
            {
                BOOL mode = tdata.brushMode;
                BOOL type = tdata.brushType;
                CGFloat radius = tdata.brushRadius;
                int opacity = tdata.brushOpacity;

                //draw line
                if ([tdata.pointArray count] > 1)
                {
                    for (int i=1; i<[tdata.pointArray count]; i++)
                    {
                        CGPoint prev,current;
                        prev = [tdata getPointAtIndex:i-1];
                        current = [tdata getPointAtIndex:i];
                        [self drawLine:prev currentPoint:current mode:mode type:type radius:radius opacity:opacity];
                    }
                    //add last point
                    [self drawPoint:[tdata getLastPoint] mode:mode type:type radius:radius opacity:opacity];
                }
                //draw point
                else
                {
                    [self drawPoint:[tdata getLastPoint] mode:mode type:type radius:radius opacity:opacity];
                }
            }
            else
            {
                [self transformAlphaFromViewToPixel:tdata.alpha];
            }
        }
        --self.redoNumber;
        ++self.undoNumber;
    }
    
    self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
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
        [self undoManagerOperation:NO];
    }
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
        [self undoManagerOperation:YES];
    }
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

#pragma mark - other methods
/**
 * @brief 首次进入橡皮擦页面需要将视图的alpha转化成像素的alpha
 * @param [in] alpha:转化的比例
 * @param [out]
 * @return
 * @note 
 */
- (void)transformViewAlpha:(CGFloat)alpha
{
    if (alpha < 1.0f) 
    {
        [self transformAlphaFromViewToPixel:alpha];
        self.undoNumber++;
    }
}

/**
 * @brief 将视图的alpha转化成像素的alpha
 * @param [in] alpha:转化的比例
 * @param [out]
 * @return
 * @note 
 */
- (void)transformAlphaFromViewToPixel:(CGFloat)alpha
{
    int width	= imageInfo_.width;
    int height	= imageInfo_.height;
    int stride	= imageInfo_.bytesPerRow;
    int bpp		= imageInfo_.bytesPerPixel;
    int offset	= stride - width * bpp;
    unsigned char *data	= imageInfo_.data;
    
    for (int i=0; i<height; i++) 
    {
        for (int j=0; j<width; j++) 
        {
            for (int k=0; k<4; k++) 
            {
                int newdata = data[k] * alpha;
                data[k] = newdata;
            }
            data += bpp;
        }
        data += offset;
    }
            
    touchesData_ = [[TouchesData alloc] init];
    touchesData_.alpha = alpha;
    [touchesArray_ addObject:touchesData_];
    self.touchesData = nil;
    self.image = [ImageInfo ImageInfoToUIImage:imageInfo_];
}
@end
