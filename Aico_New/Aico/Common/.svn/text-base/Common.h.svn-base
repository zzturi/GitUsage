//
//  Common.h
//  Aico
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageInfo;
@class UINavigationBar;

@interface Common : NSObject
{
}
//+ (UIImage *)getGlobalSrcImage;
//+ (void)setGlobalSrcImage:(UIImage *)image;
//+ (NSMutableArray *)getAllSrcImage;
//+ (UIImage *)getNextStepImage;
//+ (UIImage *)getPreStepImage;

/**
 * @brief  Return a bitmap context using alpha/red/green/blue byte values 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (CGContextRef)CreateRGBABitmapContext:(CGImageRef)inImage;
/**
 * @brief  Return Image Pixel data as an RGBA bitmap 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (unsigned char *)RequestImagePixelData:(UIImage *)inImage;
/**
 * @brief  Generate image from data bytes 
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)GenerateImageFromData:(unsigned char *)imgPixelData 
                 withImgPixelWidth:(NSUInteger) imgPixelWidth 
                withImgPixelHeight:(NSUInteger)imgPixelHeight;

/**
 * @brief  翻转图片 
 *
 * @param [in] Type 0:Horizontal 1:Vertical
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageRotatedFlip:(UIImage *)image withType:(NSUInteger)flipType;

// RGB -> HSB 
+ (void)red: (unsigned char)r 
	  green: (unsigned char)g 
	   blue: (unsigned char)b 
	  toHue: (CGFloat*)pH 
 saturation: (CGFloat*)pS 
 brightness: (CGFloat*)pV;

// HSB颜色转换成RGB颜色 saturation在[0,1]之间
+ (void)hue: (CGFloat)h 
 saturation: (CGFloat)s 
 brightness: (CGFloat)v 
	  toRed: (unsigned char*)pR 
	  green: (unsigned char*)pG 
	   blue: (unsigned char*)pB;

/**
 * @brief  定制导航栏
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */

+ (void)customizeTitle:(NSString *)titleString 
  targetViewController:(UIViewController *)viewController 
             viewFrame:(CGRect)rect
		    titleColor:(UIColor *)targetColor;


/**
 * @brief  ios5设置导航栏背景图片
 *
 * @param [in] 
 * @param [out]
 * @return
 * @note 
 */
+ (void)setNavigationBarBackgroundBkg:(UINavigationBar *)navigationBar;
/**
 * @brief 
 * 根据区域截取图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
/**
 * @brief 
 * 根据比例缩放图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+(CGRect)adaptImageToScreen:(UIImage *)image;

/**
 * @brief 
 * 图片写入aico文件夹
 *
 * @param [in]  image 需要写入的图片数据
 * @param [in]  name 图片名字，如果为空则按照时间自动生成一个
 * @param [out]
 * @return 
 * @note
 */
+ (BOOL)writeImageAico:(UIImage *)image withName:(NSString *)name;

/**
 * @brief 
 * 提示框 移植于dsmiphone
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (void)showToastView:(NSString *)titleText hiddenInTime:(NSTimeInterval)timeDelay;

/**
 * @brief  将图片转换成圆角图片
 * @param [in]　 image 待转换的图片指针
 * @param [in]	size 转换后的尺寸
 * @param [out] N/A
 * @return　　id 转换后的对象　
 * @note
 */
+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size;

/**
 * @brief  
 *
 * 根据图片质量返回处理后的图片路径
 * @param [in] N/A
 * @param [out] N/A
 * @return 调整后的图片路径
 * @note N/A
 */
+ (UIImage *) adjustedImagePathForImage:(UIImage *)image;

/**
 * @brief 将origin按照原有比例缩放显示在target上
 *
 * @param [in] sizeTarget: 目标区域大小
 * @param [in] ptOffset: 缩放后显示在target上的偏移量
 * @param [in] ptMargin: 缩放后距离target边框的距离
 * @param [out]
 * @return 调整后的显示区域
 * @note 
 */
+ (CGRect)size:(CGSize)sizeOrigin autoFitSize:(CGSize)sizeTarget offset:(CGPoint)ptOffset margin:(CGPoint)ptMargin;

/**
 * @brief 将imageview上的图片按照原有比例缩放显示在指定view上
 *
 * @param [in] view: 目标view
 * @param [in] ptMargin: 缩放后距离view边框的距离
 * @param [out]
 * @return 调整后的显示区域
 * @note 
 */
+ (void)imageView:(UIImageView *)imageView autoFitView:(UIView *)view margin:(CGPoint)ptMargin;

/**
 * @brief 将imageview上的图片按照原有比例缩放显示在指定view上
 *
 * @param [in] view: 目标view
 * @param [in] ptOffset: 缩放后显示在view上的偏移量
 * @param [in] ptMargin: 缩放后距离view边框的距离
 * @param [out]
 * @return 调整后的显示区域
 * @note 
 */
+ (void)imageView:(UIImageView *)imageView autoFitView:(UIView *)view offset:(CGPoint)ptOffset margin:(CGPoint)ptMargin;
/**
 * @brief 把twoImg合并到oneImg的subImgRect区域
 * @param N/A
 * @param N/A
 * @return N/A
 * @note N/A
 */
+ (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(NSString *)twoImgName toRect:(CGRect)subImgRect;

/**
 * @brief  将图片写入Aico相册方法
 *
 * @param [in] path为图片的绝对地址
 * @param [out]
 * @return
 * @note 
 */
+ (BOOL)writeIconAico:(NSString *)path;

/**
 * @brief 从UIColor中获取RGBA分量的值，范围[0,1]
 *
 * @param [out] red: 红色值
 * @param [out] green: 绿色值
 * @param [out] blue: 蓝色值
 * @param [out] alpha: 透明度值
 * @param [in] color: 指定的颜色
 * @return 
 * @note 
 */
+ (void)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromUIColor:(UIColor *)color;


/**
 * @brief 
 * 生成随机数，包括from,to
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (int)getRandomNumber:(int)from to:(int)to;

/**
 * @brief 
 * 计算旋转角度，
 * begin和end以origin为原点形成的夹角
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (CGFloat)makeRotate:(CGPoint)origin withBegin:(CGPoint) begin andEnd:(CGPoint) end;
/**
 * @brief 
 * 计算拉伸比例，
 * begin和end以origin为原点形成的两线段比例
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (CGFloat)makeScale:(CGPoint)origin beginPoint:(CGPoint)begin andEndPoint:(CGPoint)end;

/**
 * @brief 
 * 发表微博结果alert
 * @param [in] params －8个bool值 ，各个微博是否配置且开关是否打开，各自的分享结果
 * @param [out]
 * @return 
 * @note
 */
+ (void)showCustomAlertInfo:(NSDictionary *)params number:(NSUInteger)number;


/**
 * @brief 
 * 在发表微博结果alert上添加标签和图片
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (void)addLabelAndImageViewToAlertView:(UIAlertView *)alertView 
                            inLabelRect:(CGRect)labelRect 
                        inImageViewRect:(CGRect)imageViewRect
                               useImage:(BOOL)successOrFail
                             labelTitle:(NSString *)title;

/**
 * @brief 
 * 图片放缩
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+ (UIImage*)resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height;
/**
 * @brief 
 * 调整图片大小
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;

/**
 * @brief  解析svg中viewBox数据
 * @param [in] rspData  响应数据
 * @param [out]
 * @return 返回数据width 和 height
 * @note
 */
+ (CGSize)parseLoginResAndSaveInfo:(NSString *)rspData;

/**
 * @brief  获取本地时间
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (NSString *)localTimer;

/**
 * @brief  是否需要激活
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (BOOL)isNeedActived;

/**
 * @brief  保存激活结果
 * @param [in] 
 * @param [out]
 * @return 
 * @note
 */
+ (void)saveActiveResult:(BOOL)isSuccess;

/**
 * @brief  时间格式转化为utc
 * @param [in] localDate 本地世界
 * @param [out]
 * @return 
 * @note
 */
+ (NSString *)getUTCFormateDate:(NSDate *)localDate;

/**
 * @brief get download directory
 *
 * @param [in]
 * @param [out]　
 * @return　download directory 
 * @note
 */
+ (NSString *)downloadDirectory;

/**
 * @brief 通过url地址获取名称
 *
 * @param [in]
 * @param [out]　
 * @return　
 * @note
 */
+ (NSString *)getNameFromUrl:(NSString *)url;

/**
 * @brief 通过url地址获取本地存储路径
 *
 * @param [in]
 * @param [out]　
 * @return　
 * @note
 */
+ (NSString *)getLocalPathFromUrl:(NSString *)url;
@end
