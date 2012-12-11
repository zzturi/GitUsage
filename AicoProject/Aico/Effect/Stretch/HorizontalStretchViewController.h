//
//  HorizontalStretchViewController.h
//  HorizontalStretch
//
//  Created by yu cao on 12-6-14.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistirtBaseViewController.h"

enum EHStretchMoveType
{	
    EHStretchLeftMove,	       //左边线移动	
    EHStretchMiddleMove,       //中间区域移动	
    EHStretchMiddlePointMove,  //中间点移动
    EHStretchRightMove,        //右边线移动
    EHStretchNoneMove          //不移动
};


//水平拉伸
@interface HorizontalStretchViewController : DistirtBaseViewController 
{   
	int imageWidth_;                          //图片宽度
	int imageHeight_;                         //图片高度
	float stretchRate_;                       //拉伸率
	
    UIImageView *imageView_;                  //图片视图
    
	UIImageView *leftLineImageView_;          //左边直线图片视图
	UIImageView *rightLineImageView_;         //右边直线图片视图	
	UIImageView *leftDiamondView_;            //左边菱形图片视图
	UIImageView *rightDiamondView_;           //右边菱形图片视图
	UIImageView *middleRoundView_;            //中间菱形图片视图
    
    UIImageView *leftLineShowImageView_;      //用于显示 左边直线图片视图
	UIImageView *rightLineShowImageView_;     //用于显示 右边直线图片视图	
	
	CGPoint lastPoint_;                       //上次点击坐标
    enum EHStretchMoveType hStretchMoveType_; //移动类型
    
    int diamondImageSize_;                    //菱形图片大小
    float middleRoundPercent_;                //中间圆点位置百分比
    
    BOOL horizontalStretch_;                  //水平拉伸    
    BOOL singleTap_;                          //单击
    
    int lineOffset;                           //偏移量
}

@property (nonatomic, assign) BOOL horizontalStretch;   //是否水平拉伸

/**
 * @brief 水平拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageHStretch:(UIImage *)image;

/**
 * @brief 垂直拉伸 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)imageVStretch:(UIImage *)image;

@end

