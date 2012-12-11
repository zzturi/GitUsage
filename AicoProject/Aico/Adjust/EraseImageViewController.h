//
//  EraseImageViewController.h
//  Aico
//
//  Created by Yin Cheng on 7/16/12.
//  Copyright (c) 2012 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EraseView.h"
#import "IMPopoverController.h"

//此视图用于切换橡皮擦模式（恢复/擦除）
@interface EraseModeViewController : UIViewController
{
    UISlider *slider_;      //透明度滑动条
    UILabel *sliderLabel_;  //滑动条状态显示标签
    UIButton *restoreBtn_;  //恢复按钮
    UIButton *eraseBtn_;    //擦除按钮
}
@property(nonatomic,assign)UIViewController *superViewController; //保存的交互的上级视图
@property(nonatomic,assign)int opacityValue;

/**
 * @brief 透明度滑动条滑动触发 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)opacityValueChanged:(UISlider *)slider;

/**
 * @brief 恢复和擦除按钮按下触发 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)modelButtonPressed:(UIButton *)sender;
@end

//橡皮擦视图
@interface EraseImageViewController : UIViewController<EraseImageMaskDelegate,IMPopoverDelegate>
{
    UIImage *backgroundImage_;
    UIImage *eraseImage_;
    UIImageView *backgroundView_;
    EraseView *eraseView_;
        
    UIButton *undoBtn_;
    UIButton *redoBtn_;
    UIButton *brushBtn_;
    
    UIButton *eraseModeBtn_;
    IMPopoverController *popover_;//弹出视图
}
@property(nonatomic,copy) UIImage *backgroundImage;
@property(nonatomic,copy) UIImage *eraseImage;

@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) CGPoint center;
@property(nonatomic,assign) CGAffineTransform transform;
@property(nonatomic,assign) CGFloat alpha;
@property(nonatomic,assign) float magnification;
@property(nonatomic,assign) int opacityValue; //橡皮擦画笔透明度
@property(nonatomic,assign) int brushSizeNum; //橡皮擦画笔Tag
/**
 * @brief 返回按钮事件响应 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)leftButtonPress:(id)sender;

/**
 * @brief 确认按钮事件响应 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)rightButtonPress:(id)sender;

/**
 * @brief 缩放手势处理(底图) 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)doPinch:(UIGestureRecognizer *)gesture;

/**
 * @brief 检查撤销和恢复按钮的有效性 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)checkButtonEnable;

/**
 * @brief 重置导航栏中的橡皮擦模式图片 
 * @param [in] mode:Yes-erase No-restore
 * @param [out]
 * @return
 * @note 
 */
- (void)resetModePicture:(BOOL)mode;

/**
 * @brief 橡皮擦模式按钮按下触发（Erase/Restore）
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseModePressed:(UIButton *)sender;

/**
 * @brief 设置橡皮擦大小和类型
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setEraseRadiusAndType;

/**
 * @brief undo按钮按下触发（撤销）
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undo:(id)sender;

/**
 * @brief redo按钮按下触发（重做/恢复）
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redo:(id)sender;
@end
