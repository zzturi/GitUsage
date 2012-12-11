//
//  TopLensFilterAndEdgeLensFilterProcess.h
//  Aico
//
//  Created by cienet on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedEyeProcess.h"

@interface TopLensFilterAndEdgeLensFilterProcess : RedEyeProcess
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
- (UIImage *)edgeLensFilter:(UIImage *)inImage 
                        red:(int)inR
                      green:(int)inG 
                       blue:(int)inB 
                    opacity:(float)inOpacity 
                heightRatio:(float)heightRatio;
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
- (UIImage *)topLensFilter:(UIImage *)inImage 
                       red:(int)inR 
                     green:(int)inG
                      blue:(int)inB 
                   opacity:(float)inOpacity 
               heightRatio:(float)heightRatio;
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
                            heightRatio:(float)heightRatio;
@end
