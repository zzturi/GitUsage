//
//  RotateView.h
//  Aico
//
//  Created by rongtaowu on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotateView : UIView
{
    CGPoint centerPoint_;           //视图中心点位置坐标
    CGFloat radius_;                //视图显示区域半径    
    UIImageView *rotateView_;       //操作指示按钮视图    
    CGPoint pointArray[8];          //记录显示点所在位置数组 
    
}
@property(nonatomic, assign)CGFloat radius;
@property(nonatomic, assign)CGPoint centerPoint; 

/**
 * @brief 设置指示视图的位置 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setAutoPosition;

/**
 * @brief 设置指示视图的位置 
 * 
 * @param [in] 
 * @param [out] 
 * @return 
 * @note 
 */
- (void)setAccuartePosition:(CGPoint)inPoint;
@end
