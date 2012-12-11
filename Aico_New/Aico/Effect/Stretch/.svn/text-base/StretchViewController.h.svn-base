//
//  StretchViewController.h
//  Stretch
//
//  Created by yu cao on 12-6-15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistirtBaseViewController.h"

enum EStretchType
{	
    EStretchMove,	       //移动编辑区域	
    EStretchRotateRadius,  //改变半径，旋转角度	
    EStretchNone           //无变化
};

//拉伸
@interface StretchViewController : DistirtBaseViewController  
{    
    float stretchRate_;                       //拉伸率
    int imageWidth_;                          //图片宽度
    int imageHeight_;                         //图片高度
    
    UIImageView *imageView_;                  //图片视图	
	NSMutableArray *roundImgViewArray_;       //8个圆点
    
    float roundImageSize_;                    //圆图片大小
	
	CGPoint lastPoint_;	                      //上次点击坐标
	CGPoint roundPoint_;                      //圆点
    CGPoint rotatepoint_;                     //旋转点
    
	float roundRadius_;                       //圆半径		
	float rotateAngle_;                       //旋转角度    
    
    enum EStretchType stretchType_;           //移动类型
    BOOL singleTap_;                          //单击
    
    CGPoint centerPoint_;                     //中心点
}

/**
 * @brief 列表界面特效
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageStretch:(UIImage *)image;

@end
