//
//  RedEyeProcess.h
//  Aico
//
//  Created by Mike on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedEyeProcess : NSObject
{
    NSMutableArray *recoveryArray_;          //保存像素位置和RGB值，用于撤销和恢复操作的数组
    int remainedOnView;                      //记录当前屏幕上还剩余黑色圆的个数，即点击了多少次中心圆，进行了多少次去红眼操作
    
}
@property(nonatomic,retain)NSMutableArray *recoveryArray;

/**
 * @brief  初始化设置
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (id)init;
/**
 * @brief  由RGB的值计算出HSI模型中Hue的值
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (float)getHueOfHSIModelFromRed:(int)red Green:(int)green Blue:(int)blue;
/**
 * @brief  由RGB的值计算出HSI模型中Saturation的值
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (float)getSaturationOfHSIModelFromRed:(int)red Green:(int)green Blue:(int)blue;
/**
 * @brief  由RGB的值计算出HSI模型中Intensity的值
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (float)getIntensityOfHSIModelFromRed:(int)red Green:(int)green Blue:(int)blue;
/**
 * @brief  这是点击Fix Red-Eye页面中间的圆后，进行修复红眼的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)fixRedEye:(UIImage *)inImage roundCenter:(CGPoint)center andRadius:(int)r;
/**
 * @brief  这是点击Fix Red-Eye页面的后退按钮后，撤销上一步修复红眼操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)backward:(UIImage *)inImage;
/**
 * @brief  这是点击Fix Red-Eye页面的前进按钮后，恢复上一步撤销的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)forward:(UIImage *)inImage;
/**
 * @brief  源图片经过此函数处理后，一进入去红眼页面拖动图片会不卡（why？）
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (UIImage *)initializeOriginalPicture:(UIImage *)inImage;
@end
