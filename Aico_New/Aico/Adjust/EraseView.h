//
//  EraseView.h
//  Aico
//
//  Created by Yin Cheng on 7/30/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchesData.h"

@protocol EraseImageMaskDelegate
@optional
- (void)eraseImageViewHasChanged;
@end

@class ImageInfo;
@interface EraseView : UIImageView
{
    UIImage *srcImage_;       //The source image
    BOOL brushMode_;          //Erase or restore
    BOOL brushType_;          //Round or square
    CGFloat brushRadius_;     //Brush's radius
    int brushOpacity_;
    ImageInfo *imageInfo_;
    ImageInfo *sourceInfo_;
    
    NSMutableArray *touchesArray_;
    TouchesData *touchesData_;
    
    int undoNumber_;
    int redoNumber_;
    
    id<EraseImageMaskDelegate>delegate_;
    
    BOOL drawType_;//Line or Point
}
@property(nonatomic,copy)   UIImage *srcImage;
@property(nonatomic,assign) BOOL brushMode;
@property(nonatomic,assign) BOOL brushType;
@property(nonatomic,assign) CGFloat brushRadius;
@property(nonatomic,assign) int brushOpacity;
@property(nonatomic,retain) TouchesData *touchesData;
@property(nonatomic,assign) int undoNumber;
@property(nonatomic,assign) int redoNumber;
@property(nonatomic,assign) id<EraseImageMaskDelegate>delegate;

/**
 * @brief 初始化 
 * @param [in] frame image
 * @param [out]
 * @return
 * @note 
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage *)img;

/**
 * @brief 橡皮擦核心功能 -- 画点操作
 * @param [in] point:操作点
 *             mode:橡皮擦模式 YES/擦除 NO/反擦除
 *             type:橡皮擦笔刷类型 YES/圆形 NO/正方形
 *             radius:橡皮擦笔刷大小 
 *             opacity:橡皮擦笔刷透明度 0~255
 * @param [out] nil
 * @return
 * @note 
 */
- (void)drawPoint:(CGPoint)point
             mode:(BOOL)mode
             type:(BOOL)type 
           radius:(CGFloat)radius
          opacity:(int)opacity;

/**
 * @brief 橡皮擦核心功能 -- 画线操作
 * @param [in] previousPoint:上一个操作点
 *             currentPoint:当前操作点
 *             mode:橡皮擦模式 YES/擦除 NO/反擦除
 *             type:橡皮擦笔刷类型 YES/圆形 NO/正方形
 *             radius:橡皮擦笔刷大小 
 *             opacity:橡皮擦笔刷透明度 0~255
 * @param [out] nil
 * @return
 * @note 
 */
- (void)drawLine:(CGPoint)previousPoint 
            currentPoint:(CGPoint)currentPoint
                    mode:(BOOL)mode
                    type:(BOOL)type 
                  radius:(CGFloat)radius_N
                 opacity:(int)opacity;
/**
 * @brief 撤销恢复操作管理
 * @param [in] managerType:YES/撤销 NO/恢复
 * @param [out] 返回操作后的图片
 * @return
 * @note 
 */
- (void)undoManagerOperation:(BOOL)managerType;

/**
 * @brief 执行undo(撤销)操作
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undo;

/**
 * @brief 执行redo(恢复)操作
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redo;

/**
 * @brief 当前能否进行撤销操作
 * @param [in]
 * @param [out] YES:可以撤销 NO:不能撤销
 * @return
 * @note 
 */
- (BOOL)canUndo;

/**
 * @brief 当前能否进行恢复操作
 * @param [in]
 * @param [out] YES:可以恢复 NO:不能恢复
 * @return
 * @note 
 */
- (BOOL)canRedo;

/**
 * @brief 首次进入橡皮擦页面需要将视图的alpha转化成像素的alpha
 * @param [in] alpha:转化的比例
 * @param [out]
 * @return
 * @note 
 */
- (void)transformViewAlpha:(CGFloat)alpha;

/**
 * @brief view的alpha转化为像素alpha
 * @param [in] alpha:转化的比例
 * @param [out]
 * @return
 * @note 
 */
- (void)transformAlphaFromViewToPixel:(CGFloat)alpha;
@end
