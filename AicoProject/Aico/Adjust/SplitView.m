//
//  SplitView.m
//  DSM_iPad
//
//  Created by Wu Rongtao on 11-12-29.
//  Copyright 2011 cienet. All rights reserved.
//

#import "SplitView.h"
#import "ReUnManager.h"
#import <QuartzCore/CALayer.h>

@interface SplitView(private)

-(BOOL)isPointInArea:(CGPoint)curPoint andRect:(CGRect)rect;

@end

@implementation SplitDisplayView
@synthesize displayImageView = displayImageView_;
@synthesize scale;

#define  kCornerViewWidth     10
#define  kCornerViewHeight    10
#define  kLineWidth           1
#define  kCornerImageAray    [NSArray arrayWithObjects:@"ImageClipLeftUp.png",@"ImageClipLeftDown.png",@"ImageClipRightUp.png",@"ImageClipRightDown.png",nil]
#define  kLineImage          @"ImageClipLine.png"

/**
 * @brief 
 *
 * 重置倍数
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)resetScaleValue
{
    scale = 1.0;
}

/**
 * @brief 
 *
 * 重绘四个边角视图
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)resetCornerViewFrame
{
    CGFloat viewWidth = self.frame.size.width;               //视图宽度
    CGFloat viewHeight = self.frame.size.height;             //视图高度
    
    displayImageView_.frame = CGRectMake(kAdjustMarginWidth, 
                                         kAdjustMarginWidth,
                                         viewWidth -  kAdjustMarginWidth * 2,
                                         viewHeight - kAdjustMarginWidth * 2);
    CALayer *layer = [displayImageView_ layer];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 1.0f;
    CGFloat displayImageViewWidth = displayImageView_.frame.size.width;
    CGFloat displayImageViewHeight = displayImageView_.frame.size.height;
    
    
    for (int i = 0; i < [cornerImageViewArray_ count]; i++)
    {
        //重设四个边角视图Frame
        UIImageView *imageView = (UIImageView *)[cornerImageViewArray_ objectAtIndex:i];
        UIImageView *lineImageView = (UIImageView *)[lineImageViewArray_ objectAtIndex:i];
        switch (i) 
        {
            case 0:
            {
                imageView.frame = CGRectMake(0, 0, kCornerViewWidth, kCornerViewHeight);
                lineImageView.frame = CGRectMake(displayImageViewWidth/3, 0, kLineWidth/scale, displayImageViewHeight);
            }
                break;
            case 1:
            {
                imageView.frame = CGRectMake(0, 
                                             viewHeight - kCornerViewHeight, 
                                             kCornerViewWidth, 
                                             kCornerViewHeight);
                lineImageView.frame = CGRectMake(2 * displayImageViewWidth/3, 0, kLineWidth/scale, displayImageViewHeight);
                
            }
                break;
            case 2:
            {
                imageView.frame = CGRectMake(viewWidth - kCornerViewWidth, 
                                             0, 
                                             kCornerViewWidth, 
                                             kCornerViewHeight);
                lineImageView.frame = CGRectMake(0, displayImageViewHeight/3, displayImageViewWidth, kLineWidth/scale);
            }
                break;
            case 3:
            {
                imageView.frame = CGRectMake(viewWidth - kCornerViewWidth ,
                                             viewHeight - kCornerViewHeight, 
                                             kCornerViewWidth, 
                                             kCornerViewHeight);
                lineImageView.frame = CGRectMake(0, displayImageViewHeight * 2/3, displayImageViewWidth, kLineWidth/scale);
            }
                break;
                
            default:
                break;
        }
    }    
}

/**
 * @brief 
 *
 * 绘制视图操作
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([lineImageViewArray_ count] != 0)
    {
        [lineImageViewArray_ removeAllObjects];
    }
    if ([cornerImageViewArray_ count] != 0)
    {
        [cornerImageViewArray_ removeAllObjects];
    }
    for (UIView *subviews in [self subviews])
    {
        [subviews removeFromSuperview];
    }

    for (UIView *subviews in [displayImageView_ subviews])
    {
        [subviews removeFromSuperview];
    }
    [self addSubview:displayImageView_]; 


    for (int i = 0; i < 4; i++)
    {
        //添加四个边角视图
        NSArray *imageArray = kCornerImageAray;
        UIImage *cornerImage = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        UIImageView *cornerImageView = [[UIImageView alloc] initWithImage:cornerImage];
        [cornerImageViewArray_ addObject:cornerImageView];            
        [self addSubview:cornerImageView];
        [cornerImageView release];
        
        //添加分割线
        UIImageView *lineImageView = [[UIImageView alloc] init];
        [lineImageView setBackgroundColor:[UIColor lightGrayColor]];
        [lineImageViewArray_ addObject:lineImageView];   
        [displayImageView_ addSubview:lineImageView];
        [lineImageView release];
    };
    
    [self resetCornerViewFrame];        
    [self setBackgroundColor:[UIColor clearColor]];        
    
}
/**
 * @brief 
 * 初始化
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
        scale = 1;
        cornerImageViewArray_  = [[NSMutableArray alloc] initWithCapacity:0];
        lineImageViewArray_ = [[NSMutableArray alloc] initWithCapacity:0];
        
        //添加显示截取图片视图
        displayImageView_ = [[UIImageView alloc] init];
        [self addSubview:displayImageView_];     
        [self setBackgroundColor:[UIColor clearColor]];  
        scale = 1.0;
    }
    return self;
}

/**
 * @brief 
 * 改变裁剪框内四根线条的宽度或高度，让它们不随图片的放大而放大
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)changeLineWidth:(NSNotification*)notification
{
    NSNumber *number = [notification object];
	scale = [number floatValue];
    for (int i = 0; i < 4; i++)
    {
        UIImageView *lineImageView = [lineImageViewArray_ objectAtIndex:i];
        if (i < 2)
        {
            lineImageView.frame = CGRectMake(lineImageView.frame.origin.x, lineImageView.frame.origin.y, 1.0/scale, lineImageView.frame.size.height);  
        }
        else
        {
            lineImageView.frame = CGRectMake(lineImageView.frame.origin.x, lineImageView.frame.origin.y, lineImageView.frame.size.width, 1.0/scale);
        }
    }
}
/**
 * @brief 
 * 对象析构释放内存
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)dealloc
{
    self.displayImageView = nil;
    [cornerImageViewArray_ release];
    [lineImageViewArray_ release];
    [super dealloc];
}

@end

@implementation SplitView
@synthesize imageView = imageView_;
@synthesize mouseXY,sx,sy,w,h,ex,ey,sxm,sym,number;
@synthesize srcImage = srcImage_;
@synthesize dstImage = dstImage_;
@synthesize imageRightEdge = imageRightEdge_;
@synthesize imageBottomEdge = imageBottomEdge_;
@synthesize clipRatioIndex = clipRatioIndex_;
@synthesize isFromInsert;

#define kRectMarginWidth 25
#define kSizeArray [NSArray arrayWithObjects:@"1:1",@"2:3",@"3:2",@"3:4",@"4:3",@"16:9",nil]


/**
 * @brief 
 * 初始化
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
        //根据视图实际大小计算剪切框大小 默认 1 : 1;
        CGFloat viewWidth = frame.size.width;
        CGFloat viewHeight = frame.size.height;
        imageRightEdge_ = viewWidth;
        imageBottomEdge_ = viewHeight;
        CGFloat width,height;
        CGFloat minValue = viewWidth > viewHeight ? viewHeight : viewWidth;
        height = 120 > minValue ? minValue : 120;
        
        //设定裁减框比例 默认 1 : 1
        width = height;
        clipRatioIndex_ = -1;                //记录该比例下索引
        
        imageView_ = [[SplitDisplayView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView_.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:imageView_];        
    }
    magnification = 1;
    return self;
}

/**
 * @brief 
 * 获得图片的放大倍数
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)getMagnification:(NSNotification*)notification
{
    NSNumber *tmpNumber = [notification object];
	magnification = [tmpNumber floatValue];
}
/**
 * @brief 
 * 对象析构释放内存
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)dealloc
{
	self.imageView = nil;
	[imageView_ release];
	[srcImage_ release];
	[dstImage_ release];
    [clipImage_ release];
    [super dealloc];
}

/**
 * @brief 
 * 设置裁减视图的图片源
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(void)setSourceImage:(UIImage *)image
{
    if (clipImage_)
    {
        [clipImage_ release],clipImage_ = nil;
    }
    
    CGFloat sizeWidth = (self.frame.size.width - kAdjustMarginWidth * 2) * 2;
    CGFloat sizeHeight =(self.frame.size.height - kAdjustMarginWidth * 2) * 2;
    
    clipImage_ = [[self scaleFromImage:image toSize:CGSizeMake(sizeWidth, sizeHeight)] retain];
   
}

/**
 * @brief 
 * 触摸开始时获取截取区域初始坐标点
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	//获取触摸点
	UITouch *touch = [touches anyObject]; 
	mouseXY = [touch locationInView:self];
	
	//获取触摸时的各个参数
	sx = imageView_.frame.origin.x;
	sy = imageView_.frame.origin.y;
	w = imageView_.frame.size.width;
	h = imageView_.frame.size.height;
	ex = sx + w;
	ey = sy + h;
	
    beginX = mouseXY.x;
    beginY = mouseXY.y;
	//记录触摸点的所在位置
	if(mouseXY.x > sx + kRectMarginWidth && 
	   mouseXY.x < ex - kRectMarginWidth && 
	   mouseXY.y > sy + kRectMarginWidth && 
	   mouseXY.y < ey - kRectMarginWidth){
		//默认进入
		sxm = mouseXY.x - sx; 
		sym = mouseXY.y - sy;
		number = 1;
	}else if(mouseXY.x >= ex - kRectMarginWidth &&
			 mouseXY.x <= ex + kRectMarginWidth && 
			 mouseXY.y >= ey - kRectMarginWidth &&
			 mouseXY.y <= ey + kRectMarginWidth){
		//右下角顶点
		number = 2;
	}else if(mouseXY.x >= ex - kRectMarginWidth && 
			 mouseXY.x <= ex + kRectMarginWidth && 
			 mouseXY.y >= sy - kRectMarginWidth && 
			 mouseXY.y <= sy + kRectMarginWidth){
		//右上角顶点
		number = 3;
	}else if(mouseXY.x >= sx - kRectMarginWidth && 
			 mouseXY.x <= sx + kRectMarginWidth && 
			 mouseXY.y >= ey - kRectMarginWidth && 
			 mouseXY.y <= ey + kRectMarginWidth){
		//左下角顶点
		number = 4;
	}else if(mouseXY.x >= sx - kRectMarginWidth && 
			 mouseXY.x <= sx + kRectMarginWidth && 
			 mouseXY.y >= sy - kRectMarginWidth && 
			 mouseXY.y <= sy + kRectMarginWidth){
		//左上角顶点
		number = 5;
	}else if(mouseXY.x >= sx - kRectMarginWidth &&
			 mouseXY.x <= sx + kRectMarginWidth &&
			 mouseXY.y >= sy - kRectMarginWidth && 
			 mouseXY.y <= ey + kRectMarginWidth){
		//左侧边界线
		number = 6;	
	}else if(mouseXY.x >= ex - kRectMarginWidth &&
			 mouseXY.x <= ex + kRectMarginWidth &&
			 mouseXY.y >= sy - kRectMarginWidth &&
			 mouseXY.y <= ey + kRectMarginWidth) {
		//右侧边界线
		number = 7;
	}else if (mouseXY.x >= sx - kRectMarginWidth && 
			  mouseXY.x <= ex + kRectMarginWidth && 
			  mouseXY.y >= sy - kRectMarginWidth && 
			  mouseXY.y <= sy + kRectMarginWidth) {
		//上侧边界线
		number = 8;
	}else if (mouseXY.x >= sx - kRectMarginWidth &&
			  mouseXY.x <= ex + kRectMarginWidth &&
			  mouseXY.y >= ey - kRectMarginWidth && 
			  mouseXY.y <= ey + kRectMarginWidth) {
		//下侧边界线         
		number = 9;
	}else{
		//在图像外侧
		number = 10;
	}
}

/**
 * @brief 
 * 计算截取区域并在界面展示
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGFloat x,y,width,height;
    
    if (!CGRectContainsPoint(self.bounds, point)) 
    {
        return;
    }
   
    if (self.clipRatioIndex != -1)
    {
        //获取当前选取的切割比例
        NSArray   *sizeArray = kSizeArray;
        NSString  *sizeString = [sizeArray objectAtIndex:self.clipRatioIndex];
        NSInteger sizeX = [[[sizeString componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        NSInteger sizeY = [[[sizeString componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
        
        //获取变化的寬高
        CGFloat deltWidth = point.x - beginX;        
        CGFloat deltHeight;
        [self setFrameFromRatio:self.clipRatioIndex rangeX:&deltWidth rangeY:&deltHeight];
        
        if(number == 1){
            //触摸点在imageview中
            x = point.x - sxm;
            y = point.y - sym;
            width = w;
            height = h;
            if(x < 0)
            {
                width = imageView_.frame.size.width;
                x = 0;
            }
            if(y < 0)
            {
                height = imageView_.frame.size.height;
                y = 0;
            }
            CGFloat xL,yL;
            xL = x + width;
            if(xL > imageRightEdge_)
            {
                x = imageRightEdge_ - width;
            }
            yL = y + height;
            if(yL > imageBottomEdge_)
            {
                y = imageBottomEdge_ - height;
            }
        }else if (number == 2) {
            //触摸点在imageview的右下角

            CGFloat newEx = ex + deltWidth;
            CGFloat newEy = ey + deltHeight;
            
            x = sx;
            y = sy;
            width = newEx - x;
            height = newEy - y;
#if 1          
            if (newEx > imageRightEdge_)
            {
                x = sx;
                y = sy;
                CGFloat deltX = imageRightEdge_ - ex;
                CGFloat deltY = deltX * sizeY/sizeX;
                width = imageRightEdge_ - x;
                height = ey + deltY - y;
                
            }
            
            if (newEy > imageBottomEdge_)
            {
                x = sx;
                y = sy;
                CGFloat deltY = imageBottomEdge_ - ey;
                CGFloat deltX = deltY * sizeX/sizeY;
                width = ex + deltX - sx;
                height = imageBottomEdge_ - sy;
            }
#endif

#if 0
            if (deltWidth/deltHeight > sizeX/sizeY)
            {
                if (newEx > imageRightEdge_)
                {
                    x = sx;
                    y = sy;
                    CGFloat deltX = imageRightEdge_ - ex;
                    CGFloat deltY = deltX * sizeY/sizeX;
                    width = imageRightEdge_ - x;
                    height = ey + deltY - y;
                    
                }
            }
            else 
            {
                if (newEy > imageBottomEdge_)
                {
                    x = sx;
                    y = sy;
                    CGFloat deltY = imageBottomEdge_ - ey;
                    CGFloat deltX = deltY * sizeX/sizeY;
                    width = ex + deltX - sx;
                    height = imageBottomEdge_ - sy;
                }
            }
#endif
            
            
        }else if(number == 3){
            //触摸点在imageview的右上角
            
            CGFloat maxdeltWidth = imageRightEdge_ - ex;
            CGFloat maxdeltHeight =  sy;
            
            
            if (deltWidth < maxdeltWidth && deltHeight < maxdeltHeight)
            {
                CGFloat newEx = ex + deltWidth;
                CGFloat newSy = sy - deltHeight;
                
                x = sx;
                y = newSy;
                width = newEx - x;
                height = ey - y;
            }
            else 
            {
                CGFloat maxdeltWidthY = sy - maxdeltWidth * sizeY/sizeX;
                if (maxdeltWidthY < 0)
                {
                    CGFloat deltY = -sy;
                    CGFloat deltX = deltY * sizeX/sizeY;
                    x = sx;
                    y = 0;
                    width = ex - deltX - sx;
                    height = ey - y;               
                }
                
                CGFloat maxdeltHeightEx = ex + maxdeltHeight * sizeX/sizeY;
                if (maxdeltHeightEx > imageRightEdge_)
                {
                    CGFloat deltX = imageRightEdge_ - ex;
                    CGFloat deltY = deltX * sizeY/sizeX;
                    x = sx;
                    y = sy - deltY;
                    width = imageRightEdge_ - sx;
                    height = ey - y;
                }
            }
            
            
        }else if(number == 4){
            
           //触摸点在imageview的左下角
            CGFloat newSx = sx + deltWidth;
            CGFloat newEy = ey - deltHeight;
            
            x = newSx;
            y = sy;
            width = ex - x;
            height = newEy - y;

            if (newSx < 0)
            {
                CGFloat deltX = -sx;
                CGFloat deltY;
                [self setFrameFromRatio:self.clipRatioIndex rangeX:&deltX rangeY:&deltY];                 
                
                
                if (ey - deltY > imageBottomEdge_)
                {
                    CGFloat deltY = imageBottomEdge_ - ey;
                    CGFloat deltX = deltY * sizeX/sizeY;
                    
                    x = sx - deltX;
                    y = sy;
                    width = ex - x;
                    height = imageBottomEdge_ - y;
                }
                else 
                {
                    x = 0;
                    y = sy;
                    width = ex;
                    height = ey - deltY - sy;
                }
                
            }
            
            if (newEy > imageBottomEdge_) 
            {
                CGFloat deltY = imageBottomEdge_ - ey;
                CGFloat deltX = deltY * sizeX/sizeY;
                
                x = sx - deltX;
                y = sy;
                width = ex - x;
                height = imageBottomEdge_ - y;
            }
                            
            
        }else if(number == 5){
            //触摸点在imageview的左上角  
            x = point.x;
            y = point.y;
            if ((y - ey)/(x - ex) < (sy - ey)/(sx - ex))
            {
                y = (y > 0)? y : 0;
                CGFloat deltY = y - sy;
                CGFloat deltX = deltY * sizeX/sizeY;
                x = sx + deltX;
                              
            }
            else 
            {
                x = (x > 0) ? x : 0;
                CGFloat deltX = x - sx;
                CGFloat deltY = deltX * sizeY/sizeX;
                y = sy + deltY;
            }
            width = ex - x;
            height = ey - y;           
            
            
        }else if(number == 6){
            
            //触摸点在左侧边界界线上
            if (!isFreedomRatio_)
            {
                return;
            }
            x = point.x > 0 ? point.x : 0;
            y = sy;
            width = ex - x;
            height = h;	      
        }else if (number == 7) {
            //触摸点在右侧边界界线上
            if (!isFreedomRatio_)
            {
                return;
            }
            x = sx;
            y = sy;
            width = (point.x > imageRightEdge_? imageRightEdge_: point.x) - x;
            height = h;
            
        }else if (number == 8) {
            //触摸点在上侧边界界线上
            if (!isFreedomRatio_)
            {
                return;
            }
            x = sx;
            y = point.y > 0 ? point.y : 0;
            width = w;
            height = ey - y;
            
        }else if (number == 9) {
            //触摸点在下侧边界界线上
            if (!isFreedomRatio_)
            {
                return;
            }
            x = sx;
            y = sy;
            width = w;
            height = (point.y > imageBottomEdge_ ? imageBottomEdge_ : point.y) - y;
            
        }else {
            //触摸点不在imageview上
            x = imageView_.frame.origin.x;
            y = imageView_.frame.origin.y;
            width = w;
            height = h;
        }
        
        //上边界超出范围
        if (y + height < 0)
        {
            height = -y;
        };
        //下边界超出范围    
        if (height < 0 && ey < y)
        {
            height = fabs(height);
            y = ey;
            if (y + height > self.frame.size.height)
            {
                height = self.frame.size.height - ey;
            }
        }
        //左侧边界超出范围
        if (x + width < 0)
        {
            width =  - x;        
        }
        //右侧边界超出范围
        if (x > ex && width < 0)
        {
            width = fabsf(width);
            x = ex;
            if (x + width > self.frame.size.width)
            {
                width = self.frame.size.width - x;
            }
            //        width = point.x > self.frame.size.width ? self.frame.size.width : x - x;
        }
        
        //限定最小的裁减边界
        if (width < 20 || height < 20)
        {
            return;
        }

    }
    else 
    {
        if(number == 1){
            //触摸点在imageview中
            x = point.x - sxm;
            y = point.y - sym;
            width = w;
            height = h;
            if(x < 0)
            {
                width = imageView_.frame.size.width;
                x = 0;
            }
            if(y < 0)
            {
                height = imageView_.frame.size.height;
                y = 0;
            }
            CGFloat xL,yL;
            xL = x + width;
            if(xL > imageRightEdge_)
            {
                x = imageRightEdge_ - width;
            }
            yL = y + height;
            if(yL > imageBottomEdge_)
            {
                y = imageBottomEdge_ - height;
            }
        }else if (number == 2) {
            //触摸点在imageview的右下角
            x = sx;
            y = sy;
            width = (point.x > imageRightEdge_ ? imageRightEdge_ : point.x) - x;
            height = (point.y > imageBottomEdge_ ? imageBottomEdge_ : point.y) - y;
        }else if(number == 3){
            //触摸点在imageview的右上角
            x = sx;
            width = (point.x > imageRightEdge_? imageRightEdge_: point.x) - x;
            y = point.y > 0 ? point.y : 0;
            height = ey - y;        
            
        }else if(number == 4){
            //触摸点在imageview的左下角
            x = point.x > 0 ? point.x : 0;
            y = sy;
            height = (point.y > imageBottomEdge_ ? imageBottomEdge_ : point.y) - y;
            width = ex - x;
            
        }else if(number == 5){
            //触摸点在imageview的左上角
            x = point.x > 0 ? point.x : 0;
            y = point.y > 0 ? point.y : 0;
            height = ey - y;
            width = ex - x;
        }else if(number == 6){
            //触摸点在左侧边界界线上
            x = point.x > 0 ? point.x : 0;
            y = sy;
            width = ex - x;
            height = h;		
        }else if (number == 7) {
            //触摸点在右侧边界界线上
            x = sx;
            y = sy;
            width = (point.x > imageRightEdge_? imageRightEdge_: point.x) - x;
            height = h;
            NSLog(@"x:%f 右侧边界%f",point.x,imageRightEdge_);
            
        }else if (number == 8) {
            //触摸点在上侧边界界线上
            x = sx;
            y = point.y > 0 ? point.y : 0;
            width = w;
            height = ey - y;
            
        }else if (number == 9) {
            //触摸点在下侧边界界线上
            x = sx;
            y = sy;
            width = w;
            height = (point.y > imageBottomEdge_ ? imageBottomEdge_ : point.y) - y;
            
        }else {
            //触摸点不在imageview上
            x = imageView_.frame.origin.x;
            y = imageView_.frame.origin.y;
            width = w;
            height = h;
        }
        
        //上边界超出范围
        if (y + height < 0)
        {
            height = -y;
        };
        //下边界超出范围    
        if (height < 0 && ey < y)
        {
            height = fabs(height);
            y = ey;
            if (y + height > self.frame.size.height)
            {
                height = self.frame.size.height - ey;
            }
        }
        //左侧边界超出范围
        if (x + width < 0)
        {
            width =  - x;        
        }
        //右侧边界超出范围
        if (x > ex && width < 0)
        {
            width = fabsf(width);
            x = ex;
            if (x + width > self.frame.size.width)
            {
                width = self.frame.size.width - x;
            }
        }
    }
    
    if (width < 80 || height < 80)
    {
        return;
    }
    
    NSLog(@"%f:%f",clipImage_.size.width,clipImage_.size.height);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
        
        CGRect realImageRect = CGRectMake(x, y, width - kAdjustMarginWidth * 2, height - kAdjustMarginWidth * 2);
        
        
        UIImage *endImage = [self imageFromImage:clipImage_ inRect:realImageRect];     
        
		dispatch_async(dispatch_get_main_queue(), ^{
           
            imageView_.frame = CGRectMake(x, y,width,height);
            [imageView_ resetCornerViewFrame];
            imageView_.displayImageView.image = endImage;
            self.dstImage = endImage;
		});
	});
    
	NSLog(@"ImageViewFrame(%f,%f,%f,%f)",x,y,width,height);   
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    ReUnManager *rm = [ReUnManager sharedReUnManager];
    if (!isFromInsert) 
    {
        [rm storeSnap:self.dstImage];
    }
}

/**
 * @brief 
 * 进入裁剪，不做任何操作，直接点击确定,需要走本函数，设定frame
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)splitWithNoOperation
{
	CGFloat x,y,width,height;
    x = imageView_.frame.origin.x;
    y = imageView_.frame.origin.y;
    width = imageView_.frame.size.width;
    height = imageView_.frame.size.height;
    CGRect realImageRect = CGRectMake((x + kAdjustMarginWidth), 
                                      (y + kAdjustMarginWidth), 
                                      (width - kAdjustMarginWidth * 2),
                                      (height- kAdjustMarginWidth * 2));    
	UIImage *endImage = [[UIImage alloc] initWithCGImage:[[self imageFromImage:srcImage_ inRect:realImageRect] CGImage]];
	imageView_.frame = CGRectMake(x, y,width,height);
    [imageView_ resetCornerViewFrame];
	imageView_.displayImageView.image = endImage;
	self.dstImage = endImage;
    [endImage release];
}

/**
 * @brief 
 * 根据索引修正裁减框的比例
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)setFrameFromRatio:(NSInteger )index rangeX:(CGFloat *)deltX rangeY:(CGFloat *)deltY
{

    switch (index)
    {
        case 0:       //1：1
        {            
            *deltY = *deltX;
        }
            break;
        case 1:      //2:3
        {   
            *deltY = *deltX * 3/2;
        }
            break;
        case 2:      //3:2
        {
            *deltY = *deltX * 2/3;
        }
            break;
        case 3:      //3:4
        {
            *deltY = *deltX * 4/3;
        }
            break;
        case 4:      //4:3
        {
            *deltY = *deltX * 3/4;
        }
            break;
        case 5:     //16:9
        {
            *deltY = *deltX * 9/16;
        }
            break;
            
        default:
            break;
    }
}



/**
 * @brief 
 * 判断点是否在矩形区域内
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(BOOL)isPointInArea:(CGPoint)curPoint andRect:(CGRect)rect
{
    CGFloat orignX = rect.origin.x;
    CGFloat orignY = rect.origin.y;
    CGFloat externX = rect.size.width + orignX;
    CGFloat externY = rect.size.height + orignY;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    //移动到起始点
    CGPathMoveToPoint(pathRef, NULL, orignX, orignY);
    CGPathAddLineToPoint(pathRef, NULL, orignX, externY);   
    CGPathAddLineToPoint(pathRef, NULL, externX, orignY);
    CGPathMoveToPoint(pathRef, NULL, externX, orignY);
     CGPathAddLineToPoint(pathRef, NULL, externX, externY);
    //将这个路径封闭起来
    CGPathCloseSubpath(pathRef);
    BOOL result = CGPathContainsPoint(pathRef, NULL, curPoint, NO); 
    CGPathRelease(pathRef);
    return result;
}
/**
 * @brief 
 * 根据区域截取图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    //adjust frame
    CGFloat scaleValue = image.size.width/(self.frame.size.width - kAdjustMarginWidth * 2);
    CGFloat orignX = rect.origin.x;
    CGFloat orignY = rect.origin.y;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    CGRect  newRect = CGRectMake(scaleValue * orignX, 
                                 scaleValue * orignY, 
                                 scaleValue * rectWidth, 
                                 scaleValue * rectHeight);
    
	CGImageRef sourceImageRef = [image CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, newRect); 
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef]; 
    CGImageRelease(newImageRef);
	return newImage;      
}  

/**
 * @brief 
 * 调整图片大小
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
