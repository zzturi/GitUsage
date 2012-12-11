//
//  TopLensFilterAndEdgeLensFilterProcess.m
//  Aico
//
//  Created by cienet on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopLensFilterAndEdgeLensFilterProcess.h"
#import <OpenGLES/ES2/gl.h>
#import "UIImage+extend.h"
#import "RedEyeProcess.h"
#import "ImageInfo.h"

@implementation TopLensFilterAndEdgeLensFilterProcess

- (id)init 
{
    
    self = [super init];
    if (self) 
    {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - 
#pragma mark 最高滤镜

/**
 * @brief 
 * 最高滤镜
 * @param [in] inImage:待处理的颜色
 * @param [in] inR:传入颜色的red值
 * @param [in] inG:传入颜色的green值
 * @param [in] inB:传入颜色的blue值
 * @param [in] inOpacity:传入的透明值
 * @param [in] heightRatio:滤镜处理的高度占图片高度的比例
 * @param [out] 
 * @return 处理完的图片
 * @note
 */
- (UIImage *)topLensFilter:(UIImage *)inImage 
                       red:(int)inR 
                     green:(int)inG 
                      blue:(int)inB
                   opacity:(float)inOpacity 
               heightRatio:(float)heightRatio
{
    ImageInfo *imageInfo = [ImageInfo UIImageToImageInfo:inImage];
    unsigned char *imgPixel = imageInfo.data;
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
    
	long wOff = 0;
	long pixOff = 0;	
    
    float rpass = inR;
    float gpass = inG;
    float bpass = inB;
    
    CGFloat ph,ps,pb;
    //hue 0-360
    //saturation 0-1
    //brightness 0-255
    [Common red:rpass green:gpass blue:bpass toHue:&ph saturation:&ps brightness:&pb];
    
    float brightness = pb/255.0;//brightness 0-1
    //覆盖高度
    int height = (int)(h*heightRatio);
    //透明度
    float opacity = 1.0;
    //标志rgb大小排序
    int flag = -1;
    int max = MAX(MAX(rpass, gpass), bpass);
    int min = MIN(MIN(rpass, gpass), bpass);
    
    float tmpValue;
    
    if (rpass == max)
    {
        if (bpass == min)
        {
            flag = 0;//rgb
            if (gpass/rpass + 1 - opacity > 1)
            {
                tmpValue = brightness;
            }
            else 
            {
                tmpValue = brightness*(gpass/rpass + 1-opacity);
            }
        }
        else
        {
            flag = 1;//rbg
            tmpValue = brightness*(bpass/rpass + 1-opacity);
        }
    }
    if (gpass == max)
    {
        if (bpass == min)
        {
            flag = 2;//grb
            tmpValue = brightness*(rpass/gpass + 1-opacity);
        }
        else
        {
            flag = 3;//gbr
            tmpValue = brightness*(bpass/gpass + 1-opacity);
        }
    }
    if (bpass == max)
    {
        if (gpass == min)
        {
            flag = 4;//brg
            tmpValue = brightness*(rpass/bpass + 1-opacity);
        }
        else
        {
            flag = 5;//bgr
            tmpValue = brightness*(gpass/bpass + 1-opacity);
        }
    }
    
    {
        for(GLuint y = 0;y< h;y++) //高
        {
            pixOff = wOff;		
            if (y >= height)
            {
                break;
            }   
            for (GLuint x = 0; x<w; x++)//宽
            {
                float r,g,b;
                
                int red = (unsigned char)imgPixel[pixOff];
                int green = (unsigned char)imgPixel[pixOff+1];
                int blue = (unsigned char)imgPixel[pixOff+2];
                
                float ratio = ((height-1.0)*(1.0-inOpacity) + y*inOpacity)/(height-1.0);
                
                switch (flag)
                {
                    case 0://rgb
                    {
                        r = red*(brightness*(1-ratio)+ratio);
                        g = green*(tmpValue*(1-ratio)+ratio);
                        b = blue*ratio;
                    }
                        break;
                    case 1://rbg
                    {
                        r = red*(brightness*(1-ratio)+ratio);
                        b = blue*(tmpValue*(1-ratio)+ratio);
                        g = green*ratio;
                        
                    }
                        break;
                    case 2://grb
                    {
                        g = green*(brightness*(1-ratio)+ratio);
                        r = red*(tmpValue*(1-ratio)+ratio);
                        b = blue*ratio;
                    }
                        break;
                    case 3://gbr
                    {
                        g = green*(brightness*(1-ratio)+ratio);
                        b = blue*(tmpValue*(1-ratio)+ratio);
                        r = red*ratio;
                    }
                        break;
                    case 4://brg
                    {
                        b = blue*(brightness*(1-ratio)+ratio);
                        r = red*(tmpValue*(1-ratio)+ratio);
                        g = green*ratio;
                    }
                        break;
                    case 5://bgr
                    {
                        b = blue*(brightness*(1-ratio)+ratio);
                        g = green*(tmpValue*(1-ratio)+ratio);
                        r = red*ratio;
                    }
                        break;
                    default:
                        break;
                }               
                imgPixel[pixOff] = r;
                imgPixel[pixOff+1] = g;
                imgPixel[pixOff+2] = b;
                
                pixOff += 4;
            }
            wOff += w * 4;
        }
    }
    return [[ImageInfo ImageInfoToUIImage:imageInfo]imageRotatedByDegrees:0];
}

#pragma mark - 
#pragma mark 边框滤镜

/**
 * @brief 
 * 边框滤镜，只处理上下两边
 * @param [in] inImage:待处理的颜色
 * @param [in] inR:传入颜色的red值
 * @param [in] inG:传入颜色的green值
 * @param [in] inB:传入颜色的blue值
 * @param [in] inOpacity:传入的透明值
 * @param [in] heightRatio:上边（每一边）滤镜处理的高度占图片高度的比例
 * @param [out] 
 * @return 处理完的图片
 * @note
 */
- (UIImage *)edgeLensFilter:(UIImage *)inImage 
                        red:(int)inR 
                      green:(int)inG 
                       blue:(int)inB 
                    opacity:(float)inOpacity
                heightRatio:(float)heightRatio
{
    ImageInfo *imageInfo = [ImageInfo UIImageToImageInfo:inImage];
    unsigned char *imgPixel = imageInfo.data;
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
    
	long wOff = 0;
	long pixOff = 0;	
    
    float lengthRatio = heightRatio;
    
    float rpass = inR;
    float gpass = inG;
    float bpass = inB;
    
    CGFloat ph,ps,pb;
    //h 0-360
    //s 0-1
    //b 0-255
    [Common red:rpass green:gpass blue:bpass toHue:&ph saturation:&ps brightness:&pb];
    
    float brightness = pb/255.0;//b 0-1
    
    float opacity = 1.0;
    
    int flag = -1;
    int max = MAX(MAX(rpass, gpass), bpass);
    int min = MIN(MIN(rpass, gpass), bpass);
    
    float tmpValue;
    
    if (rpass == max)
    {
        if (bpass == min)
        {
            flag = 0;//rgb
            tmpValue = brightness*(gpass/rpass + 1-opacity);
        }
        else
        {
            flag = 1;//rbg
            tmpValue = brightness*(bpass/rpass + 1-opacity);
        }
    }
    if (gpass == max)
    {
        if (bpass == min)
        {
            flag = 2;//grb
            tmpValue = brightness*(rpass/gpass + 1-opacity);
        }
        else
        {
            flag = 3;//gbr
            tmpValue = brightness*(bpass/gpass + 1-opacity);
        }
    }
    if (bpass == max)
    {
        if (gpass == min)
        {
            flag = 4;//brg
            tmpValue = brightness*(rpass/bpass + 1-opacity);
        }
        else
        {
            flag = 5;//bgr
            tmpValue = brightness*(gpass/bpass + 1-opacity);
        }
    }
    
    int length;
    if (h > w)
    {
        length = w*lengthRatio;
    }
    else
    {
        length = h*lengthRatio;
    }
    {
        //y 的
        for(GLuint y = 0;y< h;y++) //高
        {
            pixOff = wOff;		
            
            if (y < length)//y range
            {
//                float param = 1.0*h/w;
                float param = 1.0;
                for (GLuint x = 0; x<w; x++)//宽
                {
                    if (y<=(param*x) && y<=(-param*x+w))//y<1.0*x*h/w && y<-1.0*x*h/w+h
                    {
                        float r,g,b;
                        float ratio = ((length-1.0)*(1.0-inOpacity) + y*inOpacity)/(length-1.0);//((length-1.0)*(length-1.0)*(1.0-inOpacity) + y*y*inOpacity)/((length-1.0)*(length-1.0));  
                        int red = (unsigned char)imgPixel[pixOff];
                        int green = (unsigned char)imgPixel[pixOff+1];
                        int blue = (unsigned char)imgPixel[pixOff+2];
                        
                        switch (flag)
                        {
                            case 0://rgb
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 1://rbg
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                                
                            }
                                break;
                            case 2://grb
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 3://gbr
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            case 4://brg
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                            }
                                break;
                            case 5://bgr
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            default:
                                break;
                        }
                        
                        imgPixel[pixOff] = r;
                        imgPixel[pixOff+1] = g;
                        imgPixel[pixOff+2] = b;
                    }
                        
                    pixOff += 4;
                }
            }

            if (y > h - length)//y range
            {
//                float param = 1.0*h/w;
                float param = 1.0;
                for (GLuint x = 0; x<w; x++)//宽
                {
                    if (y>=param*x+h-w && y>=-param*x+h)//y>1.0*x*h/w && y>-1.0*x*h/w+h
                    {
                        float r,g,b;
                        float ratio = ((length-1.0)*(1.0-inOpacity) + (h-1.0-y)*inOpacity)/(length-1.0);//((length-1.0)*(length-1.0)*(1.0-inOpacity) + (h-1.0-y)*(h-1.0-y)*inOpacity)/((length-1.0)*(length-1.0));
                        int red = (unsigned char)imgPixel[pixOff];
                        int green = (unsigned char)imgPixel[pixOff+1];
                        int blue = (unsigned char)imgPixel[pixOff+2];
                        
                        switch (flag)
                        {
                            case 0://rgb
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 1://rbg
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                                
                            }
                                break;
                            case 2://grb
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 3://gbr
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            case 4://brg
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                            }
                                break;
                            case 5://bgr
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            default:
                                break;
                        }
                        
                        imgPixel[pixOff] = r;
                        imgPixel[pixOff+1] = g;
                        imgPixel[pixOff+2] = b;
                    }
                    
                    pixOff += 4;
                }
            }
            wOff += w * 4;
        } 
    }
    return [self leftAndRightEdgeLensFilter:[[ImageInfo ImageInfoToUIImage:imageInfo] imageRotatedByDegrees:0] 
                                        red:rpass 
                                      green:gpass 
                                       blue:bpass 
                                    opacity:inOpacity 
                                heightRatio:heightRatio];
//    return [[ImageInfo ImageInfoToUIImage:imageInfo]imageRotatedByDegrees:0];
}

/**
 * @brief 
 * 边框滤镜，处理左右两边，和上个方法大部分相同，本应该两者合并，但多次尝试，没实现
 * @param [in] inImage:待处理的颜色
 * @param [in] inR:传入颜色的red值
 * @param [in] inG:传入颜色的green值
 * @param [in] inB:传入颜色的blue值
 * @param [in] inOpacity:传入的透明值
 * @param [in] heightRatio:滤镜处理的高度占图片高度的比例
 * @param [out] 
 * @return 处理完的图片
 * @note
 */
- (UIImage *)leftAndRightEdgeLensFilter:(UIImage *)inImage 
                                    red:(int)inR 
                                  green:(int)inG 
                                   blue:(int)inB 
                                opacity:(float)inOpacity
                            heightRatio:(float)heightRatio
{
    inImage = [inImage imageRotatedByDegrees:90];
    ImageInfo *imageInfo = [ImageInfo UIImageToImageInfo:inImage];
    unsigned char *imgPixel = imageInfo.data;
	CGImageRef inImageRef = [inImage CGImage];
	GLuint w = CGImageGetWidth(inImageRef);
	GLuint h = CGImageGetHeight(inImageRef);
    
	long wOff = 0;
	long pixOff = 0;	
    
    float lengthRatio = heightRatio;
    
    float rpass = inR; 
    float gpass = inG;
    float bpass = inB;
    
    CGFloat ph,ps,pb;
    //h 0-360
    //s 0-1
    //b 0-255
    [Common red:rpass green:gpass blue:bpass toHue:&ph saturation:&ps brightness:&pb];
    
    float brightness = pb/255.0;//b 0-1
    float opacity = 1.0;
    
    int flag = -1;
    int max = MAX(MAX(rpass, gpass), bpass);
    int min = MIN(MIN(rpass, gpass), bpass);
    
    float tmpValue;
    
    if (rpass == max)
    {
        if (bpass == min)
        {
            flag = 0;//rgb
            tmpValue = brightness*(gpass/rpass + 1-opacity);
        }
        else
        {
            flag = 1;//rbg
            tmpValue = brightness*(bpass/rpass + 1-opacity);
        }
    }
    if (gpass == max)
    {
        if (bpass == min)
        {
            flag = 2;//grb
            tmpValue = brightness*(rpass/gpass + 1-opacity);
        }
        else
        {
            flag = 3;//gbr
            tmpValue = brightness*(bpass/gpass + 1-opacity);
        }
    }
    if (bpass == max)
    {
        if (gpass == min)
        {
            flag = 4;//brg
            tmpValue = brightness*(rpass/bpass + 1-opacity);
        }
        else
        {
            flag = 5;//bgr
            tmpValue = brightness*(gpass/bpass + 1-opacity);
        }
    }
    
    int length;
    if (h > w)
    {
        length = w*lengthRatio;
    }
    else
    {
        length = h*lengthRatio;
    }
//    int length = h*lengthRatio;
    {
        //y 的
        for(GLuint y = 0;y< h;y++) //高
        {
            pixOff = wOff;		
            
            if (y < length)//y range
            {
//                float param = 1.0*h/w;
                float param = 1.0;
                for (GLuint x = 0; x<w; x++)//宽
                {
                    if (y<=param*x && y<-param*x+w-1.0)//y<1.0*x*h/w && y<-1.0*x*h/w+h
                    {
                        float r,g,b;
                        float ratio = ((length-1.0)*(1.0-inOpacity) + y*inOpacity)/(length-1.0);//((length-1.0)*(length-1.0)*(1.0-inOpacity) + y*y*inOpacity)/((length-1.0)*(length-1.0));
                        int red = (unsigned char)imgPixel[pixOff];
                        int green = (unsigned char)imgPixel[pixOff+1];
                        int blue = (unsigned char)imgPixel[pixOff+2];
                        
                        switch (flag)
                        {
                            case 0://rgb
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 1://rbg
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                                
                            }
                                break;
                            case 2://grb
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 3://gbr
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            case 4://brg
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                            }
                                break;
                            case 5://bgr
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            default:
                                break;
                        }
                        
                        imgPixel[pixOff] = r;
                        imgPixel[pixOff+1] = g;
                        imgPixel[pixOff+2] = b;
                    }
                    
                    pixOff += 4;
                }
            }
            if (y > h - length)//y range
            {
//                float param = 1.0*h/w;
                float param = 1.0;
                for (GLuint x = 0; x<w; x++)//宽
                {
                    if (y>param*x+h-w+1.0 && y>=-param*x+h)//y>1.0*x*h/w && y>-1.0*x*h/w+h
                    {
                        float r,g,b;
                        float ratio = ((length-1.0)*(1.0-inOpacity) + (h-1.0-y)*inOpacity)/(length-1.0);//((length-1.0)*(length-1.0)*(1.0-inOpacity) + (h-1.0-y)*(h-1.0-y)*inOpacity)/((length-1.0)*(length-1.0));
                        int red = (unsigned char)imgPixel[pixOff];
                        int green = (unsigned char)imgPixel[pixOff+1];
                        int blue = (unsigned char)imgPixel[pixOff+2];
                        
                        switch (flag)
                        {
                            case 0://rgb
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 1://rbg
                            {
                                r = red*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                                
                            }
                                break;
                            case 2://grb
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                b = blue*ratio;
                            }
                                break;
                            case 3://gbr
                            {
                                g = green*(brightness*(1-ratio)+ratio);
                                b = blue*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            case 4://brg
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                r = red*(tmpValue*(1-ratio)+ratio);
                                g = green*ratio;
                            }
                                break;
                            case 5://bgr
                            {
                                b = blue*(brightness*(1-ratio)+ratio);
                                g = green*(tmpValue*(1-ratio)+ratio);
                                r = red*ratio;
                            }
                                break;
                            default:
                                break;
                        }
                        
                        imgPixel[pixOff] = r;
                        imgPixel[pixOff+1] = g;
                        imgPixel[pixOff+2] = b;
                    }
                    
                    pixOff += 4;
                }
            }
            wOff += w * 4;
        } 
    }
    
    return [[[ImageInfo ImageInfoToUIImage:imageInfo] imageRotatedByDegrees:0.0]imageRotatedByDegrees:-90.0 ];
}
@end
