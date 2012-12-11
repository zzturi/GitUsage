//
//  FixRedEyeViewController.h
//  Aico
//
//  Created by Mike on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedEyeProcess;
@interface FixRedEyeViewController : UIViewController
{
    UIImage  *sourcePicture_;                        //要处理的源图片
    UIImageView *currentImageView_;                  //显示的图片
    CGPoint roundCenter_;                            //页面中间圆的圆心坐标
    RedEyeProcess *redEyeProcess_;                   //去红眼涉及的逻辑操作都在这里面
    UIButton *zoomInBtn_;                            //放大按钮
    UIButton *zoomOutBtn_;                           //缩小按钮
    UIButton *undoBtn_;                              //撤销按钮
    UIButton *redoBtn_;                              //恢复按钮
    UIButton *cancelBtn_;                            //左上角取消按钮
    UIButton *confirmBtn_;                           //右上角确定按钮
    CGSize ImageSize;                                //放大缩小后的currentImageView(或者说bgView)的尺寸
    CGPoint ImageCenterPoint;                        //放大缩小移动后的图片在固定坐标系(以屏幕左上角(不包括状态栏和导航栏)为原点，向右为x轴正方向，向下为y轴正方向)的中心点坐标
    UIView *bgView_;                                 //加在self.view上，上面再加一个uiimageview，放置要显示的图片
    UIImageView *smallWindowImageView_;              //左侧小窗口
    int roundButtonClicks;                           //记录图片上圆的个数
    int undoButtonClicks;                            //可以撤销的次数
    int redoButtonClicks;                            //可以恢复的次数
    float magnification;                             //放大倍数
    BOOL flag;                                       //如果原图片的宽度除以高度大于kImageViewWidth/kImageViewHeight，那么flag＝no，否则为yes
    float x0;                                        //anchorPoint会变动，这是x值
    float y0;                                        //anchorPoint的y值
    CGRect cutFrame;                                  //它的作用是当移动图片后，保存要切的图片的frame,点击去红眼后会用到
    float maxMagnification;                           //最大放大倍数为25＊25（圆半径）的范围内容纳四个像素
    float minMagnification;                           //最小缩小倍数为长和宽中较长的一条边长度为100像素
    CGPoint imageCenter;
}
@property(nonatomic,copy)  UIImage *sourcePicture;
@property(nonatomic,retain)UIImageView *currentImageView;
@property(nonatomic,retain)RedEyeProcess *redEyeProcess;
@property(nonatomic,retain)UIButton *zoomInBtn;
@property(nonatomic,retain)UIButton *zoomOutBtn;
@property(nonatomic,retain)IBOutlet UIButton *undoBtn;                              
@property(nonatomic,retain)IBOutlet UIButton *redoBtn; 
@property(nonatomic,retain)IBOutlet UIButton *cancelBtn;
@property(nonatomic,retain)IBOutlet UIButton *confirmBtn;
@property(nonatomic,retain)UIView *bgView;
@property(nonatomic,retain)UIImageView *smallWindowImageView;

/**
 * @brief 刚进入本页面时放大图片
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)initialZoomInPicture;
/**
 * @brief  放大图片
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)zoomIn;
/**
 * @brief  缩小图片
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)zoomOut;
/**
 * @brief  撤销操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)undo;
/**
 * @brief  恢复之前撤销的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)redo;
/**
 * @brief  取消当前去红眼的操作,返回上层页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)cancelOperation;
/**
 * @brief  保存当前去红眼的操作，返回上上层页面
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (IBAction)confirmOperation;
/**
 * @brief  去红眼，调用RedEyeProcess中的方法
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)fixRedEye;
/**
 * @brief  拖动图片时所做的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)doPan:(UIPanGestureRecognizer *)recognizer;
/**
 * @brief  捏合图片时所做的操作
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (void)doPinch:(UIPinchGestureRecognizer *)recognizer;
@end
