//
//  AdjustMosaicViewController.h
//  Aico
//
//  Created by Yincheng on 12-3-30.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMPopoverController.h"
#import "ImageInfo.h"
#import "Pixelize.h"
#import "ImageMaskView.h"

//笔刷视图页面
@interface MosaicSizeViewController : UIViewController 
{
    UIViewController *superViewController_;
    int sizeNum_;
}
@property(nonatomic,assign)UIViewController *superViewController;
@property(nonatomic,assign)int sizeNum;

/**
 * @brief 选择笔刷按钮按下
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setSelectedButton;

/**
 * @brief 笔刷类型按钮按下
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseSize:(id)sender;
@end

//马塞克处理视图页面
@interface AdjustMosaicViewController : UIViewController<UINavigationControllerDelegate,UIGestureRecognizerDelegate,IMPopoverDelegate,ImageMaskFilledDelegate>
{
    ImageMaskView *imageView_;    //涂抹层
    UIImageView *pixelizeView_;   //像素化层
    UIButton *brushBtn_;          //笔刷按钮
    UIButton *undoBtn_;           //撤销按钮
    UIButton *redoBtn_;           //重做按钮
    IMPopoverController *popover_;//弹出视图
}
@property(nonatomic,assign)float magnification;//缩放比例
@property(nonatomic,assign)int brushSizeNum;   //标记笔刷类型tag

/**
 * @brief 导航栏初始化
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initNavigation;
/**
 * @brief 导航栏初始化
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)initToolBar;
/**
 * @brief 取消马赛克操作，返回编辑 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)returnAdjustMenu:(id)sender;

/**
 * @brief 完成马赛克操作，返回主界面
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)finishMosaicOperate:(id)sender;

/**
 * @brief 撤销操作 Undo 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)undoMosaic:(id)sender;

/**
 * @brief 重做操作 Redo
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)redoMosaic:(id)sender;

/**
 * @brief 选择画刷操作 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)chooseBrush:(id)sender;

/**
 * @brief 全图像素化 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)pixelizeImage:(UIImage *)srcImage;
/**
 * @brief 设置画刷
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)setBrushType;
/**
 * @brief 检查撤销和恢复按钮的有效性 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)checkButtonEnable;
/**
 * @brief 合成图像处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (UIImage *)mergeImage;
@end
