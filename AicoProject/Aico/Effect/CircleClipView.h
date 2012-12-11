//
//  CircleClipView.h
//  Aico
//
//  Created by zhou yong on 4/13/12.
//  Copyright 2012 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectMethods.h"

typedef enum
{
	DragTypeOrigin,			// 拖动以移动圆心
	DragTypeRadius,			// 拖动以改变半径
	DragTypeNone,			// 不做任何处理
} CircleClipDragType;

@class ImageInfo;
@interface CircleClipView : UIView 
{
	ConcentricCircle		circle_;				// 聚光灯的各种参数信息
	CGPoint					ptTouchBegin_;			// 第一次按下的点的坐标
	CircleClipDragType		dragType_;				// 拖动的类型
	
	UIImageView				*viewImageDest_;		// 显示编辑图片的iamgeview
	ImageInfo				*imageInfo_;			// 编辑图片的ImageInfo表现形式
	CGFloat					scale_;					// 图片的缩放比例
    
	NSMutableArray			*arrayViewEdge_;		// 周边的圆,8个,7小1大 父窗口为根窗口
	CGFloat					angle_;					// 点击的点与与圆心的连线形成的角度，点击的点在圆的最上方时就是0度
}

@property(assign) ConcentricCircle circle;
@property(nonatomic, retain) ImageInfo *imageInfo;
@property CGFloat scale;

/**
 * @brief 初始化本view 
 *
 * @param [in] frame: view的区域
 * @param [in] pCircle: view的聚光灯区域
 * @param [in] imageView: 图片所在的imageview
 * @param [out]
 * @return 初始化好view
 * @note 
 */
-(id)initWithFrame:(CGRect)frame circle:(ConcentricCirclePtr)pCircle imageView:(UIImageView*)imageView;

/**
 * @brief 对当前的图片应用聚光灯效果 
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)effect;

/**
 * @brief 更新聚光灯边框上的8个点，来显示聚光灯中心全亮部分的边框 
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note 
 */
- (void)updateCircle;

@end
