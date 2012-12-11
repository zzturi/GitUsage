//
//  EffectMethods.h
//  Aico
//
//  Created by  on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
static const double  RGBLUMINACE_RED = 0.2126;
static const double  RGBLUMINACE_GREEN = 0.7152;
static const double  RGBLUMINACE_BLUE = 0.0722;
#define SQR(x) ((x)*(x))
#define RGB_LUMINACE(r, g, b) ((r) * RGBLUMINACE_RED + (g) * RGBLUMINACE_GREEN + (b) * RGBLUMINACE_BLUE)
#define ROUND(x) ((int)((x) + 0.5))
#define ASSERT_VOID(p) {assert(p);if(!(p)){return;}}
#define ASSERT_NULL(p) {assert(p);if(!(p)){return 0;}}
//明暗调区域
enum ETransferMode
{
    ETransferShadows, //阴影
    ETransferMidtones,//中间调
    ETransferHighlights//高光
    
};

//RGB通道
enum EChanel 
{
    EChanelRGB,
    EChanelR,
    EChanelG,
    EChanelB
};

typedef struct TinyRGBATag
{
    unsigned char m_red;     //红色
    unsigned char m_green;   //绿色
    unsigned char m_blue;    //蓝色
    unsigned char m_alpha;   //Alpha通道
} TinyRGBA, *TinyRGBARef;

//RGB
typedef struct TinyRGBTag
{
    unsigned char m_red;	// 红 
    unsigned char m_green;	// 绿
    unsigned char m_blue;	// 蓝 
} TinyRGB, *TinyRGBRef;

//HSL
typedef struct TinyHSLTag
{
	int m_hue;				//色相   [0,360]
	double m_saturation;	//饱和度 [0,1]
	double m_lightness;		//亮度   [0,1]
} TinyHSL, *TinyHSLRef;;

@class ImageInfo;
@interface EffectMethods : NSObject

/**
 * @brief  RGB通道曲线调整 
 * 三通道曲线调整
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)adjustCurveWithInImage:(ImageInfo *)inImage 
                 withRedLookup:(unsigned char *)redLookup 
               withGreenLookup:(unsigned char *)greenLookup 
                withBlueLookup:(unsigned char *)blueLookup;

/**
 * @brief  指定通道曲线调整 
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)adjustCurveWithInImage:(ImageInfo *)inImage withLookup:(unsigned char *)lookup withChanel:(int)chanel;

/**
 * @brief  RGB通道曲线调整 
 * 保证像素点亮度不变的曲线调整
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)preserveLuminosityAdjustCurveWithInImage:(ImageInfo *)inImage 
                                   withRedLookup:(unsigned char *)redLookup 
                                 withGreenLookup:(unsigned char *)greenLookup 
                                  withBlueLookup:(unsigned char *)blueLookup;

/**
 * @brief  RGB转HSL 
 * 参数为［int，out］型
 * R返回Hue [0,360]，G返回Saturation[0,255]，B返回Lightness[0,255]
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)rgb2Hsl_IntWithRed:(int *)red 
                 withGreen:(int *)green 
                  withBlue:(int *)blue;

/**
 * @brief  RGB转HSL，只获取L
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (int)rgb2Hsl_LWithRed:(unsigned char)red 
              withGreen:(unsigned char)green 
               withBlue:(unsigned char)blue;


/**
 * @brief  HSL转RGB中间计算函数
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
static int hslValueInt(double n1, double n2, double hue);
/**
 * @brief  HSL转RGB 参数都是[int,out]类型
 * hue返回R ，saturation返回G，lightness返回B
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)hsl2Rgb_IntWithHue:(int *)hue 
            withSaturation:(int *)saturation 
             withLightness:(int *)lightness;


/**
 * @brief  调节色彩平衡，
 * 
 * @param [in] cyan－－－青蓝色 magenta －－－品红色 yellow －－－黄色
 * @param [out]
 * @return
 * @note 
 */
+ (void)balanceColorWithInImage:(ImageInfo *)imageInfo 
                       withCyan:(int)cyan 
                    withMagenta:(int)magenta 
                     withYellow:(int)yellow
               withTransferMode:(int)mode
         withPreserveLuminosity:(bool)preserveLuminosity;


/**
 * @brief  调整色阶，使图片变暗，
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)adjustLevelsWithInImage:(ImageInfo *)imageInfo
                 withBlackLimit:(int)blackTreshold 
                 withWhiteLimit:(int)whiteThreshold 
                      withGamma:(double)gamma 
                     withChanel:(int)chanel;


/**
 * @brief  添加暗角
 * lomo中间算法
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)darkenCornerWithInImage:(ImageInfo *)imageInfo 
                withBrightRatio:(double)brightRatio 
                  withMaskAlpha:(unsigned char)maskAlpha;

/**
 * @brief  蒙板图
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendLayerMaskWithInImage:(ImageInfo *)imageInfo 
                     withTinyRGBA:(TinyRGBARef)mask 
                        withMaskX:(int)maskX 
                        withMaskY:(int)maskY 
                    withMaskWidth:(int)maskWidth
                   withMaskHeight:(int)maskHeight 
                    withMaskAlpha:(unsigned char)maskAlpha;

/**
 * @brief  lomo中间算法
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendWithBgColor:(TinyRGBRef)bgColor 
        withBgColorAlpha:(unsigned char)bgColorAlpha
             withFgColor:(TinyRGBARef)fgColor 
            withDstColor:(TinyRGBRef)dstColor 
          withCoverAlpha:(unsigned char)coverAlpha; 

/**
 * @brief  lomo中间算法
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char)fastScaleByteByByte:(unsigned char)a andByte:(unsigned char)b;


/**
 * @brief  灰度化
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)grayScaleWithImageInfo:(ImageInfo *)imageInfo;

/**
 * @brief  获取灰度值
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char)getLuminaceFromTinyRGB:(TinyRGBRef)tinyRGB;

/**
 * @brief  获取灰度值
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char)getLuminaceWithRed:(unsigned char)red withGreen:(unsigned char)green withBlue:(unsigned char)blue;

/**
 * @brief  高斯模糊
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)gaussianBlurWithImageInfo:(ImageInfo *)imageInfo andRadius:(long)radius;

/**
 * @brief  
 * generate a matrix that goes out a certain radius
 * from the center, so we have to go out ceil(rad-0.5) pixels,
 * inlcuding the center pixel. 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (int)genConvolveMatrixWithRadius:(float)radius andMatrix:(float **)matrix;

/**
 * @brief  
 * generates a lookup table for every possible product of 0-255 and
 * each value in the convolution matrix.  The returned array is
 * indexed first by matrix position, then by input multiplicand (?)
 * value. 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (float *)genLookupTableWithMatrix:(float *)cMatrix andMatrixLen:(int)cMatrixLen;

/**
 * @brief  素描的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blurLineWithLookupTable:(float *)lookupTable 
                     withMatrix:(float *)matrix 
                  withMatrixLen:(int)matrixLength 
                    withSrcLine:(unsigned char *)srcLine 
                    withDstLine:(unsigned char *)dstLine 
                      withWidth:(int)width 
                        withBpp:(int)bpp;


/**
 * @brief  色彩减淡
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_ColorDodge(unsigned char *lookup,double opacity);

/**
 * @brief  素描的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GenerateLookupTable(unsigned char *lookup,double opacity);

/**
 * @brief  素描的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void AdjustBlendModeCurve(ImageInfo *srcImageInfo,
							 ImageInfo *blendImageInfo,
                             unsigned char *lookup);

/**
 * @brief  
 * 两个图层做滤色混合
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendMode:(ImageInfo *)srcBitmap withBlend:(ImageInfo *)blendBitmap withOpacity:(double)opacity;
                
/**
 * @brief  
 * 模拟hdr
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)exposure: (ImageInfo*)info 
  blackThreshold: (int)blackThreshold 
  whiteThreshold: (int)whiteThreshold
		   gamma: (double)gamma;

#pragma mark -
#pragma mark ConcentricCircle

// 坐标在圆形区域的位置
typedef enum 
{
	PositionInMinCircle,	// 在小圆内
	PositionInRing,			// 在环形区域内
	PositionOutMaxCircle,	// 在大圆外
} PositionTypeOfPointInConcentricCircle;

// 同心圆
typedef struct ConcentricCircleTag
{
	CGFloat xView, yView;			// 裁剪圆心在circleClipView中的坐标
	CGFloat x, y;					// 裁剪圆心在图像数据中坐标
	CGFloat minRadius, maxRadius;	// 大圆和小圆的半径
} ConcentricCircle, *ConcentricCirclePtr;

// 坐标在矩形区域的位置
typedef enum 
{
	PositionInRectangle,	// 在小矩形内
    PositionInOutRectangle, //在小矩形与大矩形交集内
	PositionOutRectangle,	// 在大矩形外
} PositionTypeOfPointInRectangle;
// 同心矩形
typedef struct RectangleTag
{
	CGFloat xView, yView;			// 矩形中心在 RectangleClipView中的坐标
	CGFloat x, y;					// 矩形中心在图像数据中坐标
    CGFloat heightInView;
    CGFloat widthInView;
    CGAffineTransform transform;
} Rectangle, *RectanglePtr;
/**
 * @brief 同心圆裁剪算法 在环形范围内，亮度一次递减，类似于聚光灯效果
 * 
 * @param [in] info: 图片对象
 * @param [in] pCircle: 聚光灯的参数信息
 * @param [out]
 * @return
 * @note 
 */
+ (void)concentricCircleClip:(ImageInfo*)info circle:(ConcentricCirclePtr)pCircle;
 
/**
 * @brief 获取给定点在同心圆中的位置
 * 
 * @param [in] pt: 指定的点
 * @param [in] pCircle: 聚光灯的参数信息
 * @return
 * @note 
 */
+ (PositionTypeOfPointInConcentricCircle)getPositionTypeInCircle:(CGPoint)pt circle:(ConcentricCirclePtr)pCircle;

/**
 * @brief  在矩形范围外，图片模糊
 * viewArray为空时，是用来处理特效列表的缩略图的
 * @param [in] imageInfo: 图片对象
 * @param [in] clearView :矩形view
 * @param [in] rotationAngle:clearView旋转的角度
 * @param [in] scale:是图片与imageview的大小比例
 * @param [out]
 * @return
 * @note 
 */
+(void)rectangleClip:(ImageInfo *)imageInfo withClearView:(UIView *)clearView withRotationAngle:(CGFloat)rotationAngle withScale:(CGFloat)scale;


/**
 * @brief  
 * 混合两个图层
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendMode:(ImageInfo *)srcBitmap withBlend:(ImageInfo *)blendBitmap 
         withMode:(int)mode 
      withOpacity:(double)opacity;
/**
 * @brief  柔和
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_SoftLight(unsigned char *lookup,double opacity);
/**
 * @brief  强光
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_HardLight(unsigned char *lookup,double opacity);
/**
 * @brief  变亮
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_Lighten(unsigned char *lookup,double opacity);
/**
 * @brief  叠加
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
void GLT_Overlay(unsigned char *lookup,double opacity);
/**
 * @brief  
 * 给图层着色
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)addColourToImageInfo:(ImageInfo *)imageInfo hue:(float)h saturation:(float)sat;
/**
 * @brief 调整两个图层
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)BlendModeCurve:(ImageInfo *)srcBitmap 
             withBlend:(ImageInfo *)blendBitmap 
            withlookup:(unsigned char *)lookup;
/**
 * @brief 增加杂点，杂点幅度[0,255]
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)addNoiseWithImageInfo:(ImageInfo *)imageInfo andDegree:(int)degree;
/**
 * @brief  像素霓虹处理 
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)neonWithInImage:(ImageInfo *)imageInfo;
/**
 * @brief  
 * 克隆图层赋值给原图层
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)blendMode:(ImageInfo *)imageInfo withClone:(ImageInfo *)clone;
/**
 * @brief  单色化
 * 
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)piexlSingleWithInImageInfo:(ImageInfo *)imageInfo;

/**
 * @brief  移轴中模糊的中间算法
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)tiltShiftBlurLineWithLookupTable:(float *)lookupTable 
                     withMatrix:(float *)matrix 
                  withMatrixLen:(int)matrixLength 
                    withSrcLine:(unsigned char *)srcLine 
                    withDstLine:(unsigned char *)dstLine 
                      withWidth:(int)width 
                        withBpp:(int)bpp
                  withViewArray:(NSArray *)viewArray
                      withScale:(CGFloat)sizeScale
                        withNum:(int)num
                       withFlag:(BOOL)flag;

/**
 * @brief  判断图片上的点pointInImage是否在viewArray第三个view上
 *  
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (BOOL)isInClearView:(CGPoint)pointInImage withViewArray:(NSArray *)viewArray withScale:(CGFloat)scale;

@end
