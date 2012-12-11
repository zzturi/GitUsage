//
//  DrawingImageView.h
//  Aico
//
//  Created by rongtaowu on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"

enum TwistType
{
    kSpherize,     //球面化
    kTwirl,        //旋转
    kPinch,        //凸出
    kSplash        //发散
};


@class RotateView;

@interface DrawingImageView : UIView
{
    UIImage *srcImage_;                //操作的源图片
    CGPoint centerPoint_;              //显示区域的圆心
    CGPoint lastPoint_;                //上次圆心位置
    CGFloat radius_;                   //操作区域半径
    enum TwistType effecttype_;        //当前特效类型
    RotateView  *cycleView_;           //移动的视图
    
    CGPoint srcPoint_;                 //图片显示原点坐标
    CGPoint adjustPoint_;              //转换后的在图片相对坐标
    CGFloat scaleRatio_;               //调节扭曲效果的幅度
    ImageInfo *srcImageInfo_;
    
    UIImage *dstImage_;                //特效操作后的目标图片
    
}

@property(nonatomic, retain)UIImage *srcImage;
@property(nonatomic, assign)enum TwistType effecttype;

/**
 * @brief 自定义初始化函数 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)srcImage;

/**
 * @brief 改变特效幅度 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)changeEffectRatio:(CGFloat)ratio;

/**
 * @brief 获取处理之后的图片 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (UIImage *)getEffectImage;
@end
