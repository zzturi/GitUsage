//
//  StickerProcess.m
//  Aico
//
//  Created by Yincheng on 12-5-15.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "StickerProcess.h"
#import "StickerMainViewController.h"
#import "Common.h"
#import "NSData+QBase64.h"

#define kDefaultRect CGRectMake(0, 0, 400, 400)
@implementation StickerProcess
@synthesize posType = posType_;
@synthesize delegateVC = delegateVC_;
@synthesize imageName = imageName_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 * @brief 初始化入口 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (id)initWithImageName:(NSString *)name
{
    self.imageName = name;
    CGRect frame = kDefaultRect;
    
    self = [self initWithFrame:frame];
    
    if (self)
    {
        self.scalesPageToFit = NO;
        [self loadImage:self.imageName andSize:self.bounds.size.height];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UIScrollView *subview = [[self subviews] lastObject];
        subview.bounces = NO;
        subview.userInteractionEnabled = NO;
        [self hideGradientBackground:self];
        
        //add LongPressGesture
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.5f;
        [self addGestureRecognizer:longPress];
        [longPress release];
        
        self.transform = CGAffineTransformMakeScale(1.0f/4.0, 1.0f/4.0);
        
    }
    
    return self;
}

/**
 * @brief 隐藏webview的背景 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (void)hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        [self hideGradientBackground:subview];
    }
}

/**
 * @brief 加载webview信息 
 * @param [in] imageStr 需要加载的svg图片
 * @param [in] lenght   以此值进行重设webview的bounds值
 * @param [out]
 * @return
 * @note 
 */
- (void)loadImage:(NSString *)imageStr andSize:(CGFloat)length
{
#if 1
    NSString *path = imageStr;//[[NSBundle mainBundle] pathForResource:imageStr ofType:@"svg"];
    
    //读取svg图片中viewBox信息，获取svg图片的width和height值
    CGSize size = [Common parseLoginResAndSaveInfo:path];
    
    int nwidth = size.width;
    int nheight = size.height;
    
    if (nwidth>=nheight) 
    {
        nheight = (nheight*100)/nwidth*4;
        nwidth = 400;
    }
    else 
    {
        nwidth = (nwidth*100)/nheight*4;
        nheight = 400;
    }
    self.bounds = CGRectMake(0, 0, nwidth, nheight);
    nwidth *= 0.95;
    nheight *= 0.95;
    NSLog(@"nwidth:%d,nheight:%d\n",nwidth,nheight);
    NSString *HTMLString = nil;
    HTMLString = [NSString stringWithFormat:@" \
                  <div align='center' style='margin-top:0px'> \
                  <img src='%@' alt='picture' width='%dpx' height='%dpx'> \
                  </div> \
                  ",path,nwidth,nheight];
    
    
    [self loadHTMLString:HTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
#else
    //LoadData
    NSString *path = imageStr;//[[NSBundle mainBundle] pathForResource:imageStr ofType:@"svg"];
    
    //读取svg图片中viewBox信息，获取svg图片的width和height值
    CGSize size = [Common parseLoginResAndSaveInfo:path];
    
    int nwidth = size.width;
    int nheight = size.height;
    
    if (nwidth>=nheight) 
    {
        nheight = (nheight*100)/nwidth*4;
        nwidth = 400;
    }
    else 
    {
        nwidth = (nwidth*100)/nheight*4;
        nheight = 400;
    }
    
    self.bounds = CGRectMake(0, 0, nwidth, nheight);
    
    NSLog(@"nwidth:%d,nheight:%d\n",nwidth,nheight);
    nwidth *= 0.95;
    nheight *= 0.95;
    NSLog(@"nwidth:%d,nheight:%d\n",nwidth,nheight);
    NSString *HTMLString = nil;
    
    if (1) 
    {
        NSData* imageData = [[NSData alloc] initWithContentsOfFile:path];
        NSString* imageString = [imageData base64EncodedString];
        
        HTMLString = [NSString stringWithFormat:@" \
                      <div align='left' style='margin-top:0px'> \
                      <img src='data:image/svg+xml;base64,%@' width='%dpx' height='%dpx'> \
                      </div> \
                      ",imageString,nwidth,nheight];
        
        [self loadHTMLString:HTMLString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        [imageData release];
    }
    
#endif
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
    self.imageName = nil;
    [super dealloc];
}

/**
 * @brief 长按手势处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    switch (recognizer.state) 
    {
        case UIGestureRecognizerStateBegan:
        {
            if ([delegateVC_ isKindOfClass:[StickerMainViewController class]])
            {
                [(StickerMainViewController *)delegateVC_ showStickerSheet:self.tag];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
        }
            break;
        default:
            break;
    }   
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 UIImage *image = [UIImage imageNamed:self.imageName];
 [image drawInRect:rect];
 }
 */
/**
 * @brief 重绘图片 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (void)reloadImage:(NSString *)newName
{
    if (newName && ![newName isEqualToString:self.imageName])
    {
        self.imageName = newName;
        //每次进行替换装饰图片的时候，需要调用次方法，同时需要进行重绘图片，重绘要重设bounds 以400为准
        [self loadImage:self.imageName andSize:400];
    }
}
@end
