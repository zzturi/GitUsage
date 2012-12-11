//
//  StretchViewController.m
//  Stretch
//
//  Created by yu cao on 12-6-15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StretchViewController.h"
#import "ReUnManager.h"
#import "Common.h"

//弧度
#define kAngle(angle) (angle)/57.295780f

//弧度
#define kOneRadian 57.295780f

#define kStretchRate 0.009f

@implementation StretchViewController

/**
 * @brief 列表界面特效
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageStretch:(UIImage *)image
{	 
    unsigned char *imagePixel = [Common RequestImagePixelData:image];    
    unsigned char *destImagePixel_ = (unsigned char *)malloc(4*image.size.width*image.size.height);  
    
    float roundRadius_ = 20;
    float rotateAngle_ = 0.0001;
    
	float stretchRateTmp = 0.9;	
	float roundRadiusSquare = (roundRadius_*roundRadius_);
	
	float bb=0;
	float cc=0;
	float hh=0;
	float hhTmp=0;
	float det=0;
	float sumHeight=0;
	
	float stretchRate__ = (1-stretchRateTmp);
	float twoStretchRate__ = 2*stretchRate__;
	float twoStretchRate_ = 2*stretchRateTmp;
	float _twoStretchRate = 1/twoStretchRate_;
	float fourStretchRate_ = 4*stretchRateTmp;
	
	float distance=0;
	
	int currentIndex = 0;
	int srcIndex = 0;
	
	float currentDistance = 0;
	float srcDistance = 0;
	
	float pointToRoundDistance=0;
	float distanceTmp=0;
	
	float verticalRate = 0;
	if (0 != rotateAngle_) 
    {
		verticalRate = -1/tan(kAngle(rotateAngle_));
	}
	
	float rateRadius = verticalRate*roundRadius_;
	
	float value = 1/sqrt(verticalRate*verticalRate + 1);
	
	float sinRotateAngle = sin(kAngle(rotateAngle_));
	float cosRotateAngle = cos(kAngle(rotateAngle_));
    
    float _sinRotateAngle = 1/sinRotateAngle;
	float _cosRotateAngle = 1/cosRotateAngle;
    
    float _sinRotateAngle180 = _sinRotateAngle;
    float _cosRotateAngle180 = -_cosRotateAngle;
	
	int xSrc = 0;
	int ySrc = 0;	
	int x = 0;
	int y = 0;
	
	float yyy=0;
    
    BOOL bigThanZero = YES;
    
    BOOL lessThan90 = NO;
    if (90 > rotateAngle_) 
    {
        lessThan90 = YES;
    }
    
    BOOL lineDown= NO;
    
    float yRoundRadius_ = 0;
    float xRoundRadius_ = 0;
    
    CGPoint roundPointTmp = CGPointMake(image.size.width/2, image.size.height/2);
    
    int imageWidth_ = image.size.width;
    int imageHeight_ = image.size.height;
    
	for (x=0; x<imageWidth_; ++x) 
    {
		for (y=0; y<imageHeight_; ++y)
        {	
			pointToRoundDistance = sqrt((x-roundPointTmp.x)*(x-roundPointTmp.x)+
										(y-roundPointTmp.y)*(y-roundPointTmp.y));
            
            //半径内
			if (pointToRoundDistance < roundRadius_) 
			{				
				xSrc = x;
				ySrc = y;
                
                if (bigThanZero) 
                {		
                    xRoundRadius_ = x-roundPointTmp.x;
                    yRoundRadius_ = y-roundPointTmp.y;
                    
                    currentDistance = fabs(verticalRate*xRoundRadius_-yRoundRadius_)*value;
                    distanceTmp = sqrt(pointToRoundDistance*pointToRoundDistance
                                       -currentDistance*currentDistance);	
                    hh = sqrt(roundRadiusSquare-distanceTmp*distanceTmp);						
                    yyy = verticalRate*(x-(roundPointTmp.x-roundRadius_))
                    -rateRadius;
                    if (yRoundRadius_ < yyy) 
                    {
                        lineDown = YES;
                    }           
                    else 
                    {
                        lineDown = NO;
                    }
                    
                    if (lessThan90)  
                    {
                        if (lineDown) 
                        {		
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }
                        }
                        else 
                        {								
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    else 
                    {
                        if (lineDown) 
                        {
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }					
                            
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }								
                        }
                        else 
                        {
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    
                    bb = (twoStretchRate__*hh+twoStretchRate_);		
                    sumHeight = (bb+stretchRateTmp*hh)*hh*0.5;
                    cc = -2*currentDistance*sumHeight/hh;										
                    det=bb*bb-fourStretchRate_*cc;						
                    
                    if (det>0.000001)
                    {
                        srcDistance=((-bb+sqrt(det))*_twoStretchRate);	
                        distance = currentDistance-srcDistance;
                        
                        if (lineDown) 
                        {		
                            xSrc += cosRotateAngle*distance;
                            ySrc += sinRotateAngle*distance;
                        }
                        else 
                        {	
                            xSrc -= cosRotateAngle*distance;
                            ySrc -= sinRotateAngle*distance;
                        }	
                        
                        srcIndex = 4*(ySrc*imageWidth_+xSrc);
                        currentIndex = 4*(y*imageWidth_+x);	
                        
                        destImagePixel_[currentIndex] = imagePixel[srcIndex];
                        destImagePixel_[currentIndex+1] = imagePixel[srcIndex+1];
                        destImagePixel_[currentIndex+2] = imagePixel[srcIndex+2];
                        destImagePixel_[currentIndex+3] = imagePixel[srcIndex+3];
                    }						
                }
                else
                {	
                    xRoundRadius_ = x-roundPointTmp.x;
                    yRoundRadius_ = y-roundPointTmp.y;
                    
                    currentDistance = fabs(verticalRate*xRoundRadius_-yRoundRadius_)*value;
                    distanceTmp = sqrt(pointToRoundDistance*pointToRoundDistance
                                       -currentDistance*currentDistance);	
                    hh = sqrt(roundRadiusSquare-distanceTmp*distanceTmp);						         
                    
                    yyy = verticalRate*(x-(roundPointTmp.x-roundRadius_))
                    -rateRadius;
                    if (yRoundRadius_ < yyy) 
                    {
                        lineDown = YES;
                    }           
                    else 
                    {
                        lineDown = NO;
                    }
                    
                    if (lessThan90)  
                    {
                        if (lineDown) 
                        {		
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }
                        else 
                        {								
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    else 
                    {
                        if (lineDown) 
                        {
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }					
                            
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }								
                        }
                        else 
                        {
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    
                    currentDistance = hh - currentDistance;   
                    
                    if (lessThan90)  
                    {
                        if (lineDown) 
                        {	
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }
                        else 
                        {								
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    else 
                    {
                        if (lineDown) 
                        {
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }
                        else 
                        {
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }					
                            
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }						
                    
                    bb = (twoStretchRate__*hh+twoStretchRate_);		
                    sumHeight = (bb+stretchRateTmp*hh)*hh*0.5;
                    cc = -2*currentDistance*sumHeight/hh;										
                    det=bb*bb-fourStretchRate_*cc;		
                    
                    if (det>0)
                    {
                        srcDistance=((-bb+sqrt(det))*_twoStretchRate);							
                        distance = currentDistance-srcDistance;
                        
                        if (lineDown) 
                        {								
                            xSrc -= cosRotateAngle*distance;
                            ySrc -= sinRotateAngle*distance;
                        }
                        else 
                        {	
                            xSrc += cosRotateAngle*distance;
                            ySrc += sinRotateAngle*distance;
                        }	
                        
                        srcIndex = 4*(ySrc*imageWidth_+xSrc);
                        currentIndex = 4*(y*imageWidth_+x);	
                        
                        destImagePixel_[currentIndex] = imagePixel[srcIndex];
                        destImagePixel_[currentIndex+1] = imagePixel[srcIndex+1];
                        destImagePixel_[currentIndex+2] = imagePixel[srcIndex+2];
                        destImagePixel_[currentIndex+3] = imagePixel[srcIndex+3];
                    }							
                }
			}			
			else
			{
				currentIndex= 4*(y*imageWidth_+x);	
                
                destImagePixel_[currentIndex] = imagePixel[currentIndex];
                destImagePixel_[currentIndex+1] = imagePixel[currentIndex+1];
                destImagePixel_[currentIndex+2] = imagePixel[currentIndex+2];
                destImagePixel_[currentIndex+3] = imagePixel[currentIndex+3];
			}			
		}
	}
    
    return [DistirtBaseViewController GenerateImageFromData:destImagePixel_ 
                                          withImgPixelWidth:imageWidth_ 
                                         withImgPixelHeight:imageHeight_];  
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
    //没有拉伸
	if (stretchRate_<kEPSINON && stretchRate_>-kEPSINON)
	{
		return;
	}
    
	float stretchRateTmp = fabs(stretchRate_);	
	float roundRadiusSquare = (roundRadius_*roundRadius_);
	
	float bb=0;
	float cc=0;
	float hh=0;
	float hhTmp=0;
	float det=0;
	float sumHeight=0;
	
	float stretchRate__ = (1-stretchRateTmp);
	float twoStretchRate__ = 2*stretchRate__;
	float twoStretchRate_ = 2*stretchRateTmp;
	float _twoStretchRate = 1/twoStretchRate_;
	float fourStretchRate_ = 4*stretchRateTmp;
	
	float distance=0;
	
	int currentIndex = 0;
	int srcIndex = 0;
	
	float currentDistance = 0;
	float srcDistance = 0;
	
	float pointToRoundDistance=0;
	float distanceTmp=0;
	
	float verticalRate = 0;
	if (0 != rotateAngle_) 
    {
		verticalRate = -1/tan(kAngle(rotateAngle_));
	}
	
	float rateRadius = verticalRate*roundRadius_;
	
	float value = 1/sqrt(verticalRate*verticalRate + 1);
	
	float sinRotateAngle = sin(kAngle(rotateAngle_));
	float cosRotateAngle = cos(kAngle(rotateAngle_));
    
    float _sinRotateAngle = 1/sinRotateAngle;
	float _cosRotateAngle = 1/cosRotateAngle;
    
    float _sinRotateAngle180 = _sinRotateAngle;
    float _cosRotateAngle180 = -_cosRotateAngle;
	
	int xSrc = 0;
	int ySrc = 0;	
	int x = 0;
	int y = 0;
	
	float yyy=0;
    
    BOOL bigThanZero = NO;
    if (stretchRate_ > 0) 
    {
        bigThanZero = YES;
    }
    
    BOOL lessThan90 = NO;
    if (90 > rotateAngle_) 
    {
        lessThan90 = YES;
    }
    
    BOOL lineDown= NO;
    
    float yRoundRadius_ = 0;
    float xRoundRadius_ = 0;
    
    CGPoint roundPointTmp = CGPointMake(roundPoint_.x-imageRect_.origin.x,
                                        roundPoint_.y-imageRect_.origin.y);
   
	for (x=0; x<imageWidth_; ++x) 
    {
		for (y=0; y<imageHeight_; ++y)
        {	
			pointToRoundDistance = sqrt((x-roundPointTmp.x)*(x-roundPointTmp.x)+
										(y-roundPointTmp.y)*(y-roundPointTmp.y));
            
            //半径内
			if (pointToRoundDistance < roundRadius_) 
			{				
				xSrc = x;
				ySrc = y;
                
                if (bigThanZero) 
                {		
                    xRoundRadius_ = x-roundPointTmp.x;
                    yRoundRadius_ = y-roundPointTmp.y;
                    
                    currentDistance = fabs(verticalRate*xRoundRadius_-yRoundRadius_)*value;
                    distanceTmp = sqrt(pointToRoundDistance*pointToRoundDistance
                                       -currentDistance*currentDistance);	
                    hh = sqrt(roundRadiusSquare-distanceTmp*distanceTmp);						
                    yyy = verticalRate*(x-(roundPointTmp.x-roundRadius_))
                          -rateRadius;
                    if (yRoundRadius_ < yyy) 
                    {
                        lineDown = YES;
                    }           
                    else 
                    {
                        lineDown = NO;
                    }
                    
                    if (lessThan90)  
                    {
                        if (lineDown) 
                        {		
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }
                        }
                        else 
                        {								
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    else 
                    {
                        if (lineDown) 
                        {
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }					
                            
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }								
                        }
                        else 
                        {
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    
                    bb = (twoStretchRate__*hh+twoStretchRate_);		
                    sumHeight = (bb+stretchRateTmp*hh)*hh*0.5;
                    cc = -2*currentDistance*sumHeight/hh;										
                    det=bb*bb-fourStretchRate_*cc;						
                    
                    if (det>0.000001)
                    {
                        srcDistance=((-bb+sqrt(det))*_twoStretchRate);	
                        distance = currentDistance-srcDistance;
                        
                        if (lineDown) 
                        {		
                            xSrc += cosRotateAngle*distance;
                            ySrc += sinRotateAngle*distance;
                        }
                        else 
                        {	
                            xSrc -= cosRotateAngle*distance;
                            ySrc -= sinRotateAngle*distance;
                        }	
                        
                        srcIndex = 4*(ySrc*imageWidth_+xSrc);
                        currentIndex = 4*(y*imageWidth_+x);	
                        
                        destImagePixel_[currentIndex] = imagePixel_[srcIndex];
                        destImagePixel_[currentIndex+1] = imagePixel_[srcIndex+1];
                        destImagePixel_[currentIndex+2] = imagePixel_[srcIndex+2];
                        destImagePixel_[currentIndex+3] = imagePixel_[srcIndex+3];
                    }						
                }
                else
                {	
                    xRoundRadius_ = x-roundPointTmp.x;
                    yRoundRadius_ = y-roundPointTmp.y;
                    
                    currentDistance = fabs(verticalRate*xRoundRadius_-yRoundRadius_)*value;
                    distanceTmp = sqrt(pointToRoundDistance*pointToRoundDistance
                                       -currentDistance*currentDistance);	
                    hh = sqrt(roundRadiusSquare-distanceTmp*distanceTmp);						         
                    
                    yyy = verticalRate*(x-(roundPointTmp.x-roundRadius_))
                            -rateRadius;
                    if (yRoundRadius_ < yyy) 
                    {
                        lineDown = YES;
                    }           
                    else 
                    {
                        lineDown = NO;
                    }
                    
                    if (lessThan90)  
                    {
                        if (lineDown) 
                        {		
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }
                        else 
                        {								
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    else 
                    {
                        if (lineDown) 
                        {
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }					
                            
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }								
                        }
                        else 
                        {
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    
                    currentDistance = hh - currentDistance;   
                    
                    if (lessThan90)  
                    {
                        if (lineDown) 
                        {	
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }
                        else 
                        {								
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }
                    else 
                    {
                        if (lineDown) 
                        {
                            //x=0
                            distanceTmp = xSrc*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                            
                            //y=height
                            distanceTmp = (imageHeight_-ySrc)*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }
                        else 
                        {
                            //y=0
                            distanceTmp = ySrc*_sinRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }					
                            
                            //x=width
                            distanceTmp = (imageWidth_-xSrc)*_cosRotateAngle180;
                            hhTmp = distanceTmp+currentDistance;
                            if (hhTmp < hh) 
                            {
                                hh = hhTmp;
                            }	
                        }	
                    }						
                    
                    bb = (twoStretchRate__*hh+twoStretchRate_);		
                    sumHeight = (bb+stretchRateTmp*hh)*hh*0.5;
                    cc = -2*currentDistance*sumHeight/hh;										
                    det=bb*bb-fourStretchRate_*cc;		
                    
                    if (det>0)
                    {
                        srcDistance=((-bb+sqrt(det))*_twoStretchRate);							
                        distance = currentDistance-srcDistance;
                        
                        if (lineDown) 
                        {								
                            xSrc -= cosRotateAngle*distance;
                            ySrc -= sinRotateAngle*distance;
                        }
                        else 
                        {	
                            xSrc += cosRotateAngle*distance;
                            ySrc += sinRotateAngle*distance;
                        }	
                        
                        srcIndex = 4*(ySrc*imageWidth_+xSrc);
                        currentIndex = 4*(y*imageWidth_+x);	
                        
                        destImagePixel_[currentIndex] = imagePixel_[srcIndex];
                        destImagePixel_[currentIndex+1] = imagePixel_[srcIndex+1];
                        destImagePixel_[currentIndex+2] = imagePixel_[srcIndex+2];
                        destImagePixel_[currentIndex+3] = imagePixel_[srcIndex+3];
                    }							
                }
			}			
			else
			{
				currentIndex= 4*(y*imageWidth_+x);	
                
                destImagePixel_[currentIndex] = imagePixel_[currentIndex];
                destImagePixel_[currentIndex+1] = imagePixel_[currentIndex+1];
                destImagePixel_[currentIndex+2] = imagePixel_[currentIndex+2];
                destImagePixel_[currentIndex+3] = imagePixel_[currentIndex+3];
			}			
		}
	}
    
    [destImage_ release];
    destImage_ = [Common GenerateImageFromData:destImagePixel_ 
                             withImgPixelWidth:imageWidth_ 
                            withImgPixelHeight:imageHeight_];   
    
    if (stretchRate_<kEPSINON && stretchRate_>-kEPSINON) 
    {
        destImage_ = nil;
        imageView_.image = srcImage_;
    }
    else 
    {
        [destImage_ retain];
        imageView_.image = destImage_;
    }
}

/**
 * @brief 设置8个圆位置
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setRoundImgViewFrame 
{
	UIImageView *imageView = [roundImgViewArray_ objectAtIndex:7];	
	imageView.frame = CGRectMake(rotatepoint_.x-imageView.frame.size.width/2, 
                                 rotatepoint_.y-imageView.frame.size.height/2, 
                                 imageView.frame.size.width, 
                                 imageView.frame.size.height);
	
	double lastX = rotatepoint_.x;
	double lastY = rotatepoint_.y;
	double x = 0;
	double y = 0;
	for (NSInteger i=0; i<[roundImgViewArray_ count]-1; ++i) 
    {
		x = roundPoint_.x + (lastX-roundPoint_.x)*cos(kAngle(45)) 
            - (lastY-roundPoint_.y)*sin(kAngle(45));
		y = roundPoint_.y + (lastX-roundPoint_.x)*sin(kAngle(45)) 
            + (lastY-roundPoint_.y)*cos(kAngle(45));
		
		imageView = [roundImgViewArray_ objectAtIndex:i];
		imageView.frame = CGRectMake(x-imageView.frame.size.width/2,
                                     y-imageView.frame.size.height/2,
                                     imageView.frame.size.width,
                                     imageView.frame.size.height
                                     );
		
		lastX = x;
		lastY = y;		
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
    return CGRectMake(20, 64, 280, 356);
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
    
    self.navigationItem.title = @"拉伸";	
    
    [self setSlider];    
    
    centerPoint_ = self.view.center;
    
    CGSize imageSize = srcImage_.size;
	imageWidth_ = imageSize.width;
	imageHeight_ = imageSize.height;
    
    UIImage *smallRoundImage = [UIImage imageNamed:@"SmallRound.png"];
    UIImage *rotateImage = [UIImage imageNamed:@"RotateRound.png"];
	
	stretchRate_ = 0;
	rotateAngle_ = 0.1;
    roundImageSize_ = rotateImage.size.width;
    
	roundPoint_ = CGPointMake(imageRect_.origin.x+imageWidth_/2,
                              imageRect_.origin.y+imageHeight_/2);
	roundRadius_ = 80;
    rotatepoint_ = CGPointMake(roundPoint_.x, roundPoint_.y+roundRadius_);

    imageView_ = [[UIImageView alloc] initWithFrame:imageRect_];
	[imageView_ setImage:srcImage_];
    [self.view addSubview:imageView_];
	
	roundImgViewArray_ = [[NSMutableArray alloc] initWithCapacity:8];
	for (NSInteger i=0; i<8; ++i) 
    {
        UIImageView *imageView;
        if (7 == i) 
        {
            imageView = [[UIImageView alloc] initWithImage:rotateImage];
            imageView.frame = CGRectMake(0, 0, 
                                         rotateImage.size.width,
                                         rotateImage.size.height);
        }        
        else 
        {
            imageView = [[UIImageView alloc] initWithImage:smallRoundImage];
            imageView.frame = CGRectMake(0, 0, 
                                         smallRoundImage.size.width,
                                         smallRoundImage.size.height);
        }
        
		[roundImgViewArray_ addObject:imageView];
		[self.view addSubview:imageView];	
		[imageView release];
	}		
	[self setRoundImgViewFrame];
    
    float sliderValue = slider_.slider.value;
    stretchRate_ = -sliderValue*kStretchRate;
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
    if (singleTap_) 
    {
        for (NSInteger i=0; i<[roundImgViewArray_ count]; ++i) 
        {            
            UIImageView *imageView = [roundImgViewArray_ objectAtIndex:i];
            imageView.hidden = !imageView.hidden;
        }	
    }
    else 
    {
        if (stretchType_ == EStretchMove
            || stretchType_ == EStretchRotateRadius)
        {
            for (NSInteger i=0; i<[roundImgViewArray_ count]; ++i) 
            {            
                UIImageView *imageView = [roundImgViewArray_ objectAtIndex:i];
                imageView.hidden = NO;
            }	
        }    
        
        if (stretchType_ == EStretchMove)
        {
            if (roundPoint_.x == centerPoint_.x)
            {
                if (roundPoint_.y > centerPoint_.y) 
                {
                    rotatepoint_.x = centerPoint_.x;                    
                    float distance = roundPoint_.y - centerPoint_.y;
                    rotatepoint_.y = centerPoint_.y + (distance - roundRadius_);
                }
                if (roundPoint_.y < centerPoint_.y)
                {
                    rotatepoint_.x = centerPoint_.x;                    
                    float distance = centerPoint_.y - roundPoint_.y;
                    rotatepoint_.y = centerPoint_.y - (distance - roundRadius_);
                }
            }
            else if (roundPoint_.y == centerPoint_.y)
            {
                if (roundPoint_.x > centerPoint_.x) 
                {
                    rotatepoint_.y = centerPoint_.y;                    
                    float distance = roundPoint_.x - centerPoint_.x;
                    rotatepoint_.x = centerPoint_.x + (distance - roundRadius_);
                }
                if (roundPoint_.x < centerPoint_.x)
                {
                    rotatepoint_.y = centerPoint_.y;                    
                    float distance = centerPoint_.x - roundPoint_.x;
                    rotatepoint_.x = centerPoint_.x - (distance - roundRadius_);
                }
            }
            else 
            {
                float distance = sqrt((roundPoint_.x-centerPoint_.x)*(roundPoint_.x-centerPoint_.x) 
                                      + (roundPoint_.y-centerPoint_.y)*(roundPoint_.y-centerPoint_.y));
                float distanceX = roundPoint_.x - centerPoint_.x;
                rotatepoint_.x = roundPoint_.x - (distanceX * roundRadius_/distance);
                float distanceY = roundPoint_.y - centerPoint_.y;
                rotatepoint_.y = roundPoint_.y - (distanceY * roundRadius_/distance);
            }            
            
            [self setRoundImgViewFrame];
        }
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
    
    stretchType_ = EStretchNone;  
    
    float distance = sqrt(pow(lastPoint_.x-roundPoint_.x, 2)+
                          pow(lastPoint_.y-roundPoint_.y, 2));
    
    if (distance < (roundRadius_ - (roundImageSize_/2+3))) 
	{
        stretchType_ = EStretchMove;
	}	
    else if (distance > (roundRadius_ - (roundImageSize_/2+3))
             && distance < (roundRadius_ + (roundImageSize_/2+3)))
    {
        stretchType_ = EStretchRotateRadius;
    }
    
    singleTap_ = YES;
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
    
    singleTap_ = NO;
    BOOL needStretch = NO;
    
    float moveX = curLoc.x - lastPoint_.x;
    float moveY = curLoc.y - lastPoint_.y;
    
    float currentDistance = sqrt(pow(curLoc.x-roundPoint_.x, 2)+
                                 pow(curLoc.y-roundPoint_.y, 2));
    
    switch (stretchType_) 
    {
        case EStretchMove:
        {
            needStretch = YES;     
            
            for (NSInteger i=0; i<[roundImgViewArray_ count]; ++i) 
            {            
                UIImageView *imageView = [roundImgViewArray_ objectAtIndex:i];
                imageView.hidden = YES;
            }	
            
            roundPoint_.x += moveX;
            roundPoint_.y += moveY;
            
            rotatepoint_.x += moveX;
            rotatepoint_.y += moveY;
            
            break;
        }    
        case EStretchRotateRadius:
        {
            needStretch = YES;
            rotatepoint_ = curLoc;
                      
            roundRadius_ = currentDistance;   
            
            double k1 = 0;
            double k2 = 0;
            if (curLoc.x != roundPoint_.x
                && lastPoint_.x != roundPoint_.x) 
            {
                k1 = (curLoc.y - roundPoint_.y)/(curLoc.x - roundPoint_.x);
                k2 = (lastPoint_.y - roundPoint_.y)/(lastPoint_.x - roundPoint_.x);
                
                double rotateAngleTmp = atan((k1-k2)/(1+k1*k2));
                rotateAngle_ += kOneRadian*rotateAngleTmp;
                
                if (rotateAngle_ < 0)
                {
                    rotateAngle_ += 180;
                }            
                if (rotateAngle_ > 180) 
                {
                    rotateAngle_ -= 180;
                }
                if (0 == rotateAngle_) 
                {
                    rotateAngle_ = 0.1;
                }                
            }
            
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
        [self setRoundImgViewFrame];
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
	RELEASE_OBJECT(roundImgViewArray_);
    
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
	[roundImgViewArray_ release];      
    
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
    float sliderValue = slider_.slider.value;
    stretchRate_ = -sliderValue*kStretchRate;
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
    if (nil != destImage_ && (sliderValue>=0.8||sliderValue<=-0.8))
    {        
        [[ReUnManager sharedReUnManager] storeSnap:destImage_];
    }    
}

@end
