//
//  HorizontalStretchViewController.m
//  HorizontalStretch
//
//  Created by yu cao on 12-6-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HorizontalStretchViewController.h"
#import "ReUnManager.h"
#import "Common.h"


@implementation HorizontalStretchViewController

@synthesize horizontalStretch = horizontalStretch_;


/**
 * @brief 水平拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageHStretch:(UIImage *)image   
{
    unsigned char *imagePixel_ = [Common RequestImagePixelData:image];
    unsigned char *destImagePixel_ = (unsigned char *)malloc(4*image.size.width*image.size.height);    
  
    int imageWidth_ = image.size.width;
    int imageHeight_ = image.size.height;    
    
    float stretchRateTmp = 100.0f;
        
    if (stretchRateTmp > 0) 
    {
        stretchRateTmp *= -1;
        stretchRateTmp /= 200;
        stretchRateTmp += 1;
    }
    else 
    {
        stretchRateTmp /= -100;
        stretchRateTmp += 1;
    }
    
    CGRect leftStretchRect = CGRectMake(0, 0, image.size.width/2, image.size.height);
    CGRect rightStretchRect = CGRectMake(image.size.width/2, 
                                         0, 
                                         image.size.width/2, 
                                         image.size.height);
    
	int leftImageWidth = leftStretchRect.size.width;
    int rightImageWidth = rightStretchRect.size.width;
    
	int index = 0;
    int indexSrc = 0;    
	
	int row=0;
	int col=0;
    
    float leftMaxWidth = powf(leftImageWidth, stretchRateTmp);
    float leftScale = leftMaxWidth/leftImageWidth;
    float leftWidth = 0;
    
    float rightMaxWidth = powf(rightImageWidth, stretchRateTmp);
    float rightScale = rightMaxWidth/rightImageWidth;
    float rightWidth = 0;
    
    for (row=0; row<imageHeight_; ++row)
    {		
        for (col=0; col<imageWidth_; ++col)
        {
            if ((col > leftStretchRect.origin.x) 
                && (col < leftStretchRect.origin.x+leftStretchRect.size.width)) 
            {
                if (leftImageWidth < kEPSINON)
                {
                    continue;
                }
                
                leftWidth = powf(col-leftStretchRect.origin.x, stretchRateTmp);
                indexSrc = leftStretchRect.origin.x+leftWidth/leftScale;
                indexSrc = 4*(row*imageWidth_+indexSrc);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3];              
            }
            else if ((col > rightStretchRect.origin.x) 
                     && (col < rightStretchRect.origin.x+rightStretchRect.size.width)) 
            {
                if (rightImageWidth < kEPSINON)
                {
                    continue;
                }
                
                rightWidth = powf(rightStretchRect.origin.x+rightStretchRect.size.width-col, stretchRateTmp);
                indexSrc = rightStretchRect.origin.x+rightStretchRect.size.width
                - rightWidth/rightScale;
                indexSrc = 4*(row*imageWidth_+indexSrc);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3]; 
            }
            else 
            {
                destImagePixel_[index] = (unsigned char)imagePixel_[index];
                destImagePixel_[index+1] = (unsigned char)imagePixel_[index+1];
                destImagePixel_[index+2] = (unsigned char)imagePixel_[index+2];
                destImagePixel_[index+3] = (unsigned char)imagePixel_[index+3];
            }
            
            index += 4;
		}
	}  
    
    return [DistirtBaseViewController GenerateImageFromData:destImagePixel_
                                          withImgPixelWidth:imageWidth_ 
                                         withImgPixelHeight:imageHeight_];   
}

/**
 * @brief 水平拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)imageHStretch
{      
    float stretchRateTmp = stretchRate_;
    
    CGRect leftStretchRect = CGRectMake(leftLineImageView_.frame.origin.x-imageRect_.origin.x, 
                                        0, 
                                        middleRoundView_.frame.origin.x+diamondImageSize_/2
                                        -leftLineImageView_.frame.origin.x, 
                                        imageHeight_);
    CGRect rightStretchRect = CGRectMake(middleRoundView_.frame.origin.x+diamondImageSize_/2
                                         -imageRect_.origin.x, 
                                         0, 
                                         rightLineImageView_.frame.origin.x
                                         -(middleRoundView_.frame.origin.x+diamondImageSize_/2), 
                                         imageHeight_);
    
	int leftImageWidth = leftStretchRect.size.width;
    int rightImageWidth = rightStretchRect.size.width;
    
    float leftwidthSize = leftStretchRect.origin.x+leftStretchRect.size.width;
    float rightwidthSize = rightStretchRect.origin.x+rightStretchRect.size.width;
    
	int index = 0;
    int indexSrc = 0;    
	
	int row=0;
	int col=0;
    
    float leftMaxWidth = powf(leftImageWidth, stretchRateTmp);
    float leftScale_ = leftImageWidth/leftMaxWidth;
    float leftWidth = 0;
    
    float rightMaxWidth = powf(rightImageWidth, stretchRateTmp);
    float rightScale_ = rightImageWidth/rightMaxWidth;
    float rightWidth = 0;
    
    int imageWidth = srcImage_.size.width;
    int imageHeight = srcImage_.size.height;
    
    float scaleWidth = imageWidth_*1.0f/imageWidth;
    int width = 0;
    
    float screenX = 0;
    
    NSLog(@"imageHStretch begin");
    
	for (col=0; col<imageWidth; ++col)
	{
		for (row=0; row<imageHeight; ++row)
        {
            index = 4*(row*imageWidth+col);     
            screenX = col*scaleWidth;
            
            if ((screenX > leftStretchRect.origin.x) 
                && (screenX < leftwidthSize)) 
            {                
                leftWidth = powf(screenX-leftStretchRect.origin.x, stretchRateTmp);
                indexSrc = leftStretchRect.origin.x+leftWidth*leftScale_;
                width = indexSrc/scaleWidth;
                indexSrc = 4*(row*imageWidth+width);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3];              
            }
            else if ((screenX > rightStretchRect.origin.x) 
                     && (screenX < rightwidthSize)) 
            {                
                rightWidth = powf(rightwidthSize-screenX, stretchRateTmp);
                indexSrc = rightwidthSize - rightWidth*rightScale_;
                width = indexSrc/scaleWidth;
                indexSrc = 4*(row*imageWidth+width);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3]; 
            }
            else 
            {
                destImagePixel_[index] = imagePixel_[index];
                destImagePixel_[index+1] = imagePixel_[index+1];
                destImagePixel_[index+2] = imagePixel_[index+2];
                destImagePixel_[index+3] = imagePixel_[index+3];
            }
		}
	}  
    
    NSLog(@"imageHStretch end");
}

/**
 * @brief 垂直拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageVStretch:(UIImage *)image
{
    unsigned char *imagePixel_ = [Common RequestImagePixelData:image];
    unsigned char *destImagePixel_ = (unsigned char *)malloc(4*image.size.width*image.size.height);    
    
    int imageWidth_ = image.size.width;
    int imageHeight_ = image.size.height;    
    
    float stretchRateTmp = 100.0f;
    
    if (stretchRateTmp > 0) 
    {
        stretchRateTmp *= -1;
        stretchRateTmp /= 200;
        stretchRateTmp += 1;
    }
    else 
    {
        stretchRateTmp /= -100;
        stretchRateTmp += 1;
    }
    
    CGRect leftStretchRect = CGRectMake(0, 0, image.size.width, image.size.height/2);
    CGRect rightStretchRect = CGRectMake(0, 
                                         image.size.height/2, 
                                         image.size.width, 
                                         image.size.height/2);
    
	int leftImageWidth = leftStretchRect.size.height;
    int rightImageWidth = rightStretchRect.size.height;
    
	int index = 0;
    int indexSrc = 0;    
	
	int row=0;
	int col=0;
    
    float leftMaxWidth = powf(leftImageWidth, stretchRateTmp);
    float leftScale = leftMaxWidth/leftImageWidth;
    float leftWidth = 0;
    
    float rightMaxWidth = powf(rightImageWidth, stretchRateTmp);
    float rightScale = rightMaxWidth/rightImageWidth;
    float rightWidth = 0;
    
	for (row=0; row<imageHeight_; ++row)
	{
		for (col=0; col<imageWidth_; ++col)
        {
            index = 4*(row*imageWidth_+col);         
            
            if ((row > leftStretchRect.origin.y) 
                && (row < leftStretchRect.origin.y+leftStretchRect.size.height)) 
            {
                if (leftImageWidth < kEPSINON)
                {
                    continue;
                }
                
                leftWidth = powf(row-leftStretchRect.origin.y, stretchRateTmp);
                indexSrc = leftStretchRect.origin.y+leftWidth/leftScale;
                indexSrc = 4*(indexSrc*imageWidth_+col);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3];              
            }
            else if ((row > rightStretchRect.origin.y) 
                     && (row < rightStretchRect.origin.y+rightStretchRect.size.height)) 
            {
                if (rightImageWidth < kEPSINON)
                {
                    continue;
                }
                
                rightWidth = powf(rightStretchRect.origin.y+rightStretchRect.size.height-row, stretchRateTmp);
                indexSrc = rightStretchRect.origin.y+rightStretchRect.size.height
                - rightWidth/rightScale;
                indexSrc = 4*(indexSrc*imageWidth_+col);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3]; 
            }
            else 
            {
                destImagePixel_[index] = (unsigned char)imagePixel_[index];
                destImagePixel_[index+1] = (unsigned char)imagePixel_[index+1];
                destImagePixel_[index+2] = (unsigned char)imagePixel_[index+2];
                destImagePixel_[index+3] = (unsigned char)imagePixel_[index+3];
            }
		}
	}   
    
    return [DistirtBaseViewController GenerateImageFromData:destImagePixel_
                                          withImgPixelWidth:imageWidth_
                                         withImgPixelHeight:imageHeight_];   
}

/**
 * @brief 垂直拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)imageVStretch
{      
	float stretchRateTmp = stretchRate_;
    
    CGRect leftStretchRect = CGRectMake(0, 
                                        leftLineImageView_.frame.origin.y-imageRect_.origin.y, 
                                        imageWidth_,
                                        middleRoundView_.frame.origin.y+diamondImageSize_/2
                                        -leftLineImageView_.frame.origin.y
                                        );
    CGRect rightStretchRect = CGRectMake(0, 
                                         middleRoundView_.frame.origin.y+diamondImageSize_/2
                                         -imageRect_.origin.y, 
                                         imageWidth_,
                                         rightLineImageView_.frame.origin.y
                                         -(middleRoundView_.frame.origin.y+diamondImageSize_/2)
                                         );
    
	int leftImageWidth = leftStretchRect.size.height;
    int rightImageWidth = rightStretchRect.size.height;
    
    float leftAndSize = leftStretchRect.origin.y+leftStretchRect.size.height;
    float rightAndSize = rightStretchRect.origin.y+rightStretchRect.size.height;
    
	int index = 0;
    int indexSrc = 0;    
	
	int row=0;
	int col=0;
    
    float leftMaxWidth = powf(leftImageWidth, stretchRateTmp);
    float leftScale_ = leftImageWidth/leftMaxWidth;
    float leftWidth = 0;
    
    float rightMaxWidth = powf(rightImageWidth, stretchRateTmp);
    float rightScale_ = rightImageWidth/rightMaxWidth;
    float rightWidth = 0;
    
    int imageWidth = srcImage_.size.width;
    int imageHeight = srcImage_.size.height;
    
    float scaleheight = imageHeight_*1.0f/imageHeight;
    float scaleheight_ = imageHeight*1.0f/imageHeight_;
    
    int height = 0;
    
    float screenY = 0;
    
    NSLog(@"imageVStretch begin");
    
	for (row=0; row<imageHeight; ++row)
	{
		for (col=0; col<imageWidth; ++col)
        {     
            screenY = row*scaleheight;
            
            if ((screenY > leftStretchRect.origin.y) 
                && (screenY < leftAndSize)) 
            {                              
                leftWidth = powf(screenY-leftStretchRect.origin.y, stretchRateTmp);
                indexSrc = leftStretchRect.origin.y+leftWidth*leftScale_;
                height = indexSrc*scaleheight_;
                indexSrc = 4*(height*imageWidth+col);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3];              
            }
            else if ((screenY > rightStretchRect.origin.y) 
                     && (screenY < rightAndSize)) 
            {                
                rightWidth = powf(rightAndSize-screenY, stretchRateTmp);
                indexSrc = rightAndSize - rightWidth*rightScale_;
                height = indexSrc*scaleheight_;
                indexSrc = 4*(height*imageWidth+col);
                
                destImagePixel_[index] = imagePixel_[indexSrc];
                destImagePixel_[index+1] = imagePixel_[indexSrc+1];
                destImagePixel_[index+2] = imagePixel_[indexSrc+2];                     
                destImagePixel_[index+3] = imagePixel_[indexSrc+3]; 
            }
            else 
            {
                destImagePixel_[index] = (unsigned char)imagePixel_[index];
                destImagePixel_[index+1] = (unsigned char)imagePixel_[index+1];
                destImagePixel_[index+2] = (unsigned char)imagePixel_[index+2];
                destImagePixel_[index+3] = (unsigned char)imagePixel_[index+3];
            }
            
            index += 4;
		}
	}    
    
    NSLog(@"imageVStretch end");
}

/**
 * @brief 拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)imageStretch
{     
    if (stretchRate_ == 1) 
    {
        destImage_ = nil;
        imageView_.image = srcImage_;
    }
    else 
    {
        if (horizontalStretch_)
        {
            [self imageHStretch];
        }
        else 
        {
            [self imageVStretch];
        }
        
        [destImage_ release];
        destImage_ = [[Common GenerateImageFromData:destImagePixel_ 
                                  withImgPixelWidth:srcImage_.size.width 
                                 withImgPixelHeight:srcImage_.size.height] retain];       
        imageView_.image = destImage_;
    }
}

/**
 * @brief 图片显示区域 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (CGRect)showImageRect 
{
    return CGRectMake(0, 44, 320, 396);
}

/**
 * @brief 设置布局
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setLayout
{
    if (horizontalStretch_) 
    {
        self.navigationItem.title = @"水平拉伸";	
        
        UIImage *lineImage = [UIImage imageNamed:@"VerticalLine.png"];
        lineOffset = lineImage.size.width/2;
        leftLineImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                              imageRect_.origin.y, 
                                              1, 
                                              imageHeight_);
        rightLineImageView_.frame = CGRectMake(imageRect_.origin.x+imageRect_.size.width, 
                                               imageRect_.origin.y, 
                                               1, 
                                               imageHeight_);
        
        leftLineShowImageView_.frame = CGRectMake(imageRect_.origin.x-lineOffset, 
                                                  imageRect_.origin.y, 
                                                  lineImage.size.width, 
                                                  imageHeight_);
        rightLineShowImageView_.frame = CGRectMake(imageRect_.origin.x+imageRect_.size.width-lineOffset, 
                                                   imageRect_.origin.y, 
                                                   lineImage.size.width, 
                                                   imageHeight_);
        
        leftLineShowImageView_.image = lineImage;
        rightLineShowImageView_.image = lineImage;
    }
    else 
    {
        self.navigationItem.title = @"垂直拉伸";	
        
        UIImage *lineImage = [UIImage imageNamed:@"HorizonLine.png"];
        lineOffset = lineImage.size.height/2;
        leftLineImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                              imageRect_.origin.y, 
                                              imageWidth_, 
                                              1);
        rightLineImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                               imageRect_.origin.y+imageRect_.size.height, 
                                               imageWidth_, 
                                               1);
        
        leftLineShowImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                                  imageRect_.origin.y-lineOffset, 
                                                  imageWidth_, 
                                                  lineImage.size.height);
        rightLineShowImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                                   imageRect_.origin.y+imageRect_.size.height-lineOffset, 
                                                   imageWidth_, 
                                                   lineImage.size.height);
        
        leftLineShowImageView_.image = lineImage;
        rightLineShowImageView_.image = lineImage;
    }
}

/**
 * @brief 设置拉伸率
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setStretchRate:(float)stretchRate
{
    if (stretchRate > -kSliderValue && stretchRate < kSliderValue)
    {
        stretchRate_ = 1;        
    }
    else 
    {
        stretchRate_ = stretchRate;
        if (stretchRate_ > 0) 
        {
            stretchRate_ /= -200;
            stretchRate_ += 1;
        }
        else 
        {
            stretchRate_ /= -100;
            stretchRate_ += 1;
        }
    }
}

/**
 * @brief 视图加载 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self setSlider];
    
    middleRoundPercent_ = 0.5;
	
    imageView_ = [[UIImageView alloc] initWithFrame:imageRect_];
	[imageView_ setImage:srcImage_];
    [self.view addSubview:imageView_];
	
	imageWidth_ = imageRect_.size.width;
	imageHeight_ = imageRect_.size.height;
	
	leftLineImageView_ = [[UIImageView alloc] init];
	[self.view addSubview:leftLineImageView_];
	
	rightLineImageView_ = [[UIImageView alloc] init];
	[self.view addSubview:rightLineImageView_];
    
    leftLineShowImageView_ = [[UIImageView alloc] init];
	[self.view addSubview:leftLineShowImageView_];
	
	rightLineShowImageView_ = [[UIImageView alloc] init];
	[self.view addSubview:rightLineShowImageView_];
    
    UIImage *diamondImage = [UIImage imageNamed:@"Diamond.png"];
    diamondImageSize_ = diamondImage.size.width;
    
    leftDiamondView_ = [[UIImageView alloc] initWithFrame:CGRectMake(imageRect_.origin.x-diamondImageSize_/2, 
                                                                     imageRect_.origin.y-diamondImageSize_/2, 
                                                                     diamondImageSize_, 
                                                                     diamondImageSize_)];
	[leftDiamondView_ setImage:diamondImage];
	[self.view addSubview:leftDiamondView_];
	
    CGRect rightDiamondRc = CGRectMake(imageRect_.origin.x+imageRect_.size.width-diamondImageSize_/2,
                                       imageRect_.origin.y+imageHeight_-diamondImageSize_/2, 
                                       diamondImageSize_, 
                                       diamondImageSize_);
	rightDiamondView_ = [[UIImageView alloc] initWithFrame:rightDiamondRc];	
    [rightDiamondView_ setImage:diamondImage];
	[self.view addSubview:rightDiamondView_];
	
	UIImage *roundImage = [UIImage imageNamed:@"MiddleRound.png"];
	middleRoundView_ = [[UIImageView alloc] initWithImage:roundImage];
	middleRoundView_.frame = CGRectMake(imageRect_.origin.x+(imageWidth_-diamondImageSize_)/2, 
										imageRect_.origin.y+(imageHeight_-diamondImageSize_)/2, 
										diamondImageSize_, 
										diamondImageSize_);
	[self.view addSubview:middleRoundView_];    
    
    [self setLayout]; 
    
    [self setStretchRate:slider_.slider.value];
    [self imageStretch];
    [self sliderTouchUp];
}

#pragma mark - touches

/**
 * @brief touchesEnded
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    leftLineShowImageView_.alpha = 1.0;
    rightLineShowImageView_.alpha = 1.0;
    middleRoundView_.alpha = 1.0;
    
    if (singleTap_) 
    {
        leftLineShowImageView_.hidden = !leftLineShowImageView_.hidden;
        rightLineShowImageView_.hidden = !rightLineShowImageView_.hidden;
        middleRoundView_.hidden = !middleRoundView_.hidden;
    }
    
    if (nil != destImage_) 
    {        
        [[ReUnManager sharedReUnManager] storeSnap:destImage_];
    }    
}

/**
 * @brief touchesBegan
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{       
	UITouch *touch = [touches anyObject];
	lastPoint_ = [touch locationInView:self.view];
    
    CGRect middleRoundRc = middleRoundView_.frame;
    middleRoundRc.origin.x -= 15;
    middleRoundRc.origin.y -= 15;
    middleRoundRc.size.width += 30;
    middleRoundRc.size.height += 30;
    
    CGRect leftDiamondRc = leftDiamondView_.frame;
    leftDiamondRc.origin.x -= 15;
    leftDiamondRc.origin.y -= 15;
    leftDiamondRc.size.width += 30;
    leftDiamondRc.size.height += 30;
    
    CGRect rightDiamondRc = rightDiamondView_.frame;
    rightDiamondRc.origin.x -= 15;
    rightDiamondRc.origin.y -= 15;
    rightDiamondRc.size.width += 30;
    rightDiamondRc.size.height += 30;
    
    hStretchMoveType_ = EHStretchNoneMove;    
    if (horizontalStretch_)
    {
        if (CGRectContainsPoint(middleRoundRc, lastPoint_))
        {
            hStretchMoveType_ = EHStretchMiddlePointMove;
        }
        else if (CGRectContainsPoint(leftDiamondRc, lastPoint_)
                 || lastPoint_.x < leftLineImageView_.frame.origin.x) 
        {
            hStretchMoveType_ = EHStretchLeftMove;
        }
        else if (CGRectContainsPoint(rightDiamondRc, lastPoint_)
                 || lastPoint_.x > rightLineImageView_.frame.origin.x)
        {
            hStretchMoveType_ = EHStretchRightMove;
        }
        else if (lastPoint_.x >= leftLineImageView_.frame.origin.x
                 && lastPoint_.x <= rightLineImageView_.frame.origin.x) 
        {
            hStretchMoveType_ = EHStretchMiddleMove;
        }
    }
    else 
    {
        if (CGRectContainsPoint(middleRoundRc, lastPoint_))
        {
            hStretchMoveType_ = EHStretchMiddlePointMove;
        }
        else if (CGRectContainsPoint(leftDiamondRc, lastPoint_)
                 || lastPoint_.y < leftLineImageView_.frame.origin.y) 
        {
            hStretchMoveType_ = EHStretchLeftMove;
        }
        else if (CGRectContainsPoint(rightDiamondRc, lastPoint_)
                 || lastPoint_.y > rightLineImageView_.frame.origin.y)
        {
            hStretchMoveType_ = EHStretchRightMove;
        }
        else if (lastPoint_.y >= leftLineImageView_.frame.origin.y
                 && lastPoint_.y <= rightLineImageView_.frame.origin.y) 
        {
            hStretchMoveType_ = EHStretchMiddleMove;
        }
    }   
    
    singleTap_ = YES;
}

/**
 * @brief 左边移动
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)leftMove:(int)moveX
{
    if (horizontalStretch_) 
    {
        int leftlineViewX = leftLineImageView_.frame.origin.x+moveX;
        
        if (leftlineViewX < imageRect_.origin.x)
        {
            leftlineViewX = imageRect_.origin.x;
        }
        
        if (leftlineViewX-(rightLineImageView_.frame.origin.x) > 0)
        {
            leftlineViewX = (rightLineImageView_.frame.origin.x);
        }
        leftLineImageView_.frame = CGRectMake(leftlineViewX, 
                                              imageRect_.origin.y, 
                                              leftLineImageView_.frame.size.width, 
                                              imageHeight_);	
        leftLineShowImageView_.frame = CGRectMake(leftlineViewX-lineOffset, 
                                                  imageRect_.origin.y, 
                                                  leftLineShowImageView_.frame.size.width, 
                                                  imageHeight_);	
        leftDiamondView_.frame = CGRectMake(leftlineViewX-diamondImageSize_/2, 
                                            imageRect_.origin.y-diamondImageSize_/2, 
                                            diamondImageSize_, 
                                            diamondImageSize_);
        
        float middleRoundX = leftLineImageView_.frame.origin.x+middleRoundPercent_
        *(rightLineImageView_.frame.origin.x
          -leftLineImageView_.frame.origin.x);
        middleRoundView_.frame = CGRectMake(middleRoundX-diamondImageSize_/2, 
                                            imageRect_.origin.y+(imageHeight_-diamondImageSize_)/2, 
                                            diamondImageSize_, 
                                            diamondImageSize_);
    }
    else
    {
        int leftlineViewX = leftLineImageView_.frame.origin.y+moveX;
        
        if (leftlineViewX < imageRect_.origin.y)
        {
            leftlineViewX = imageRect_.origin.y;
        }
        
        if (leftlineViewX-(rightLineImageView_.frame.origin.y) > 0)
        {
            leftlineViewX = (rightLineImageView_.frame.origin.y);
        }
        leftLineImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                              leftlineViewX, 
                                              imageWidth_, 
                                              leftLineImageView_.frame.size.height);	
        leftLineShowImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                                  leftlineViewX-lineOffset, 
                                                  imageWidth_, 
                                                  leftLineShowImageView_.frame.size.height);	
        leftDiamondView_.frame = CGRectMake(imageRect_.origin.x-diamondImageSize_/2, 
                                            leftlineViewX-diamondImageSize_/2, 
                                            diamondImageSize_, 
                                            diamondImageSize_);
        
        float middleRoundX = leftLineImageView_.frame.origin.y+middleRoundPercent_
                                *(rightLineImageView_.frame.origin.y
                                  -leftLineImageView_.frame.origin.y);
        middleRoundView_.frame = CGRectMake(imageRect_.origin.x+(imageWidth_-diamondImageSize_)/2, 
                                            middleRoundX-diamondImageSize_/2, 
                                            diamondImageSize_, 
                                            diamondImageSize_);
    }
}

/**
 * @brief 右边移动
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)rightMove:(int)moveX
{
    if (horizontalStretch_)
    {
        int rightlineViewX = rightLineImageView_.frame.origin.x+moveX;
        
        if (rightlineViewX-(leftLineImageView_.frame.origin.x) < kEPSINON) 
        {
            rightlineViewX = (leftLineImageView_.frame.origin.x);
        }
        
        if (rightlineViewX-(imageRect_.origin.x+imageRect_.size.width) > kEPSINON) 
        {
            rightlineViewX = (imageRect_.origin.x+imageRect_.size.width);
        }
        
        rightLineImageView_.frame = CGRectMake(rightlineViewX, 
                                               imageRect_.origin.y, 
                                               rightLineImageView_.frame.size.width, 
                                               imageHeight_);	
        rightLineShowImageView_.frame = CGRectMake(rightlineViewX-lineOffset, 
                                                   imageRect_.origin.y, 
                                                   rightLineShowImageView_.frame.size.width, 
                                                   imageHeight_);	
        rightDiamondView_.frame = CGRectMake(rightlineViewX-diamondImageSize_/2, 
                                             imageRect_.origin.y+imageHeight_-diamondImageSize_/2, 
                                             diamondImageSize_, 
                                             diamondImageSize_);
        
        float middleRoundX = leftLineImageView_.frame.origin.x+middleRoundPercent_
        *(rightLineImageView_.frame.origin.x
          -leftLineImageView_.frame.origin.x);
        middleRoundView_.frame = CGRectMake(middleRoundX-diamondImageSize_/2, 
                                            imageRect_.origin.y+(imageHeight_-diamondImageSize_)/2, 
                                            diamondImageSize_, 
                                            diamondImageSize_);
    }
    else
    {
        int rightlineViewX = rightLineImageView_.frame.origin.y+moveX;
        
        if (rightlineViewX-(leftLineImageView_.frame.origin.y) < kEPSINON) 
        {
            rightlineViewX = (leftLineImageView_.frame.origin.y);
        }
        
        if (rightlineViewX-(imageRect_.origin.y+imageRect_.size.height) > kEPSINON) 
        {
            rightlineViewX = (imageRect_.origin.y+imageRect_.size.height);
        }
        
        rightLineImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                               rightlineViewX, 
                                               imageWidth_, 
                                               rightLineImageView_.frame.size.height);	
        rightLineShowImageView_.frame = CGRectMake(imageRect_.origin.x, 
                                                   rightlineViewX-lineOffset, 
                                                   imageWidth_, 
                                                   rightLineShowImageView_.frame.size.height);	
        rightDiamondView_.frame = CGRectMake(imageRect_.origin.x+imageWidth_-diamondImageSize_/2, 
                                             rightlineViewX-diamondImageSize_/2,                                              
                                             diamondImageSize_, 
                                             diamondImageSize_);
        
        float middleRoundX = leftLineImageView_.frame.origin.y+middleRoundPercent_
                                *(rightLineImageView_.frame.origin.y
                                  -leftLineImageView_.frame.origin.y);
        middleRoundView_.frame = CGRectMake(imageRect_.origin.x+(imageWidth_-diamondImageSize_)/2, 
                                            middleRoundX-diamondImageSize_/2,                                             
                                            diamondImageSize_, 
                                            diamondImageSize_);
    }
}

/**
 * @brief 中间移动
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)middleMove:(int)moveX
{
    if (horizontalStretch_)
    {
        if (moveX > 0) 
        {
            int rightlineViewX = rightLineImageView_.frame.origin.x+moveX;
            
            if (rightlineViewX-(imageRect_.origin.x+imageRect_.size.width) > kEPSINON) 
            {
                moveX = (imageRect_.origin.x+imageRect_.size.width)-rightLineImageView_.frame.origin.x;
            }   
        }
        else if (moveX < 0) 
        {
            int leftlineViewX = leftLineImageView_.frame.origin.x+moveX;
            
            if (leftlineViewX < imageRect_.origin.x)
            {
                moveX = imageRect_.origin.x - leftLineImageView_.frame.origin.x;
            }
        }
        
        CGRect rect;
        
        rect = leftLineImageView_.frame;
        rect.origin.x += moveX;
        leftLineImageView_.frame = rect;	

        rect = leftLineShowImageView_.frame;
        rect.origin.x += moveX;
        leftLineShowImageView_.frame = rect;	
        
        rect = leftDiamondView_.frame;
        rect.origin.x += moveX;
        leftDiamondView_.frame = rect;	
        
        rect = middleRoundView_.frame;
        rect.origin.x += moveX;
        middleRoundView_.frame = rect;
        
        rect = rightLineImageView_.frame;
        rect.origin.x += moveX;
        rightLineImageView_.frame = rect;
        
        rect = rightLineShowImageView_.frame;
        rect.origin.x += moveX;
        rightLineShowImageView_.frame = rect;
        
        rect = rightDiamondView_.frame;
        rect.origin.x += moveX;
        rightDiamondView_.frame = rect;
    }
    else
    {
        if (moveX > 0) 
        {
            int rightlineViewX = rightLineImageView_.frame.origin.y+moveX;
            
            if (rightlineViewX-(imageRect_.origin.y+imageRect_.size.height) > kEPSINON) 
            {
                moveX = (imageRect_.origin.y+imageRect_.size.height)-rightLineImageView_.frame.origin.y;
            }   
        }
        else if (moveX < 0) 
        {
            int leftlineViewX = leftLineImageView_.frame.origin.y+moveX;
            
            if (leftlineViewX < imageRect_.origin.y)
            {
                moveX = imageRect_.origin.y - leftLineImageView_.frame.origin.y;
            }
        }
        
        CGRect rect;
        
        rect = leftLineImageView_.frame;
        rect.origin.y += moveX;
        leftLineImageView_.frame = rect;	

        rect = leftLineShowImageView_.frame;
        rect.origin.y += moveX;
        leftLineShowImageView_.frame = rect;	
        
        rect = leftDiamondView_.frame;
        rect.origin.y += moveX;
        leftDiamondView_.frame = rect;	
        
        rect = middleRoundView_.frame;
        rect.origin.y += moveX;
        middleRoundView_.frame = rect;
        
        rect = rightLineImageView_.frame;
        rect.origin.y += moveX;
        rightLineImageView_.frame = rect;

        rect = rightLineShowImageView_.frame;
        rect.origin.y += moveX;
        rightLineShowImageView_.frame = rect;
        
        rect = rightDiamondView_.frame;
        rect.origin.y += moveX;
        rightDiamondView_.frame = rect;
    }
}

/**
 * @brief 圆点移动
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)middlePointMove:(int)moveX
{
    if (horizontalStretch_)
    {
        int middleRoundViewX = middleRoundView_.frame.origin.x+moveX;
        
        if (middleRoundViewX-(leftLineImageView_.frame.origin.x-diamondImageSize_/2) < kEPSINON) 
        {
            middleRoundViewX = (leftLineImageView_.frame.origin.x-diamondImageSize_/2);
        }
        
        if (middleRoundViewX-(rightLineImageView_.frame.origin.x-diamondImageSize_/2) > kEPSINON) 
        {
            middleRoundViewX = (rightLineImageView_.frame.origin.x-diamondImageSize_/2);
        }
        
        middleRoundView_.frame = CGRectMake(middleRoundViewX, 
                                            imageRect_.origin.y+(imageHeight_-diamondImageSize_)/2, 
                                            diamondImageSize_, 
                                            diamondImageSize_);          
        //中间圆点百分比
        if (0 != (rightLineImageView_.frame.origin.x
                  -leftLineImageView_.frame.origin.x)) 
        {
            middleRoundPercent_ = (middleRoundView_.frame.origin.x+diamondImageSize_/2
                                   -leftLineImageView_.frame.origin.x)
                                /(rightLineImageView_.frame.origin.x
                                  -leftLineImageView_.frame.origin.x);    
        }   
        else 
        {
            middleRoundPercent_ = 0.0f;
        }
    }
    else
    {
        int middleRoundViewX = middleRoundView_.frame.origin.y+moveX;
        
        if (middleRoundViewX-(leftLineImageView_.frame.origin.y-diamondImageSize_/2) < kEPSINON) 
        {
            middleRoundViewX = (leftLineImageView_.frame.origin.y-diamondImageSize_/2);
        }
        
        if (middleRoundViewX-(rightLineImageView_.frame.origin.y-diamondImageSize_/2) > kEPSINON) 
        {
            middleRoundViewX = (rightLineImageView_.frame.origin.y-diamondImageSize_/2);
        }
        
        middleRoundView_.frame = CGRectMake(imageRect_.origin.x+(imageWidth_-diamondImageSize_)/2, 
                                            middleRoundViewX, 
                                            diamondImageSize_, 
                                            diamondImageSize_);          
        //中间圆点百分比
        if (0 != (rightLineImageView_.frame.origin.y
                  -leftLineImageView_.frame.origin.y)) 
        {
            middleRoundPercent_ = (middleRoundView_.frame.origin.y+diamondImageSize_/2
                                   -leftLineImageView_.frame.origin.y)
                                /(rightLineImageView_.frame.origin.y
                                  -leftLineImageView_.frame.origin.y);    
        }   
        else 
        {
            middleRoundPercent_ = 0.0f;
        }
    }
}

/**
 * @brief touchesMoved
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch *touch = [touches anyObject];
	CGPoint curLoc = [touch locationInView:self.view];
	
	BOOL needStretch = NO;
    singleTap_ = NO;
    
    leftLineShowImageView_.hidden = NO;
    rightLineShowImageView_.hidden = NO;
    middleRoundView_.hidden = NO;

    leftLineShowImageView_.alpha = 0.3;
    rightLineShowImageView_.alpha = 0.3;
    middleRoundView_.alpha = 0.3;
    
    int moveX = horizontalStretch_ ? (curLoc.x - lastPoint_.x) : (curLoc.y - lastPoint_.y); 
    
    switch (hStretchMoveType_) 
    {
        case EHStretchLeftMove:
        {
            needStretch = YES;  
            [self leftMove:moveX];
            
            break;
        }  
        case EHStretchMiddleMove:
        {
            needStretch = YES;
            [self middleMove:moveX];
            
            break;
        }    
        case EHStretchMiddlePointMove:
        {
            needStretch = YES;
            [self middlePointMove:moveX];
            
            break;
        }    
        case EHStretchRightMove:
        {
            needStretch = YES;
            [self rightMove:moveX];
            
            break;
        }    
        default:
        {
            break;
        }            
    }
	
	lastPoint_ = curLoc;	
    
	if (needStretch) 
    {
		[self imageStretch];
        [self sliderTouchUp];
	}
}

/**
 * @brief 视图卸载
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)viewDidUnload 
{
    RELEASE_OBJECT(imageView_);    
	RELEASE_OBJECT(leftLineImageView_);	
	RELEASE_OBJECT(rightLineImageView_);	
    RELEASE_OBJECT(leftLineShowImageView_);	
	RELEASE_OBJECT(rightLineShowImageView_);	
	RELEASE_OBJECT(leftDiamondView_);
	RELEASE_OBJECT(rightDiamondView_);
	RELEASE_OBJECT(middleRoundView_);	
	
	[super viewDidUnload];
}

/**
 * @brief 析构
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)dealloc 
{
    [imageView_ release];    
	[leftLineImageView_ release];	
	[rightLineImageView_ release];
    [leftLineShowImageView_ release];	
	[rightLineShowImageView_ release];
	
	[leftDiamondView_ release];
	[rightDiamondView_ release];
	[middleRoundView_ release];	
	
    [super dealloc];
}

#pragma mark-
#pragma mark CustomSlider Delegate Method

/**
 * @brief slider值改变
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)sliderValueChanged:(float)value
{   
    [self setStretchRate:slider_.slider.value];
    [self imageStretch];
}

/**
 * @brief 手指从slider上移开时的处理函数 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)sliderTouchUp
{
    float sliderValue = slider_.slider.value;
    if (nil != destImage_ && (sliderValue>=kSliderValue||sliderValue<=-kSliderValue))
    {        
        [[ReUnManager sharedReUnManager] storeSnap:destImage_];
    }    
}

@end
