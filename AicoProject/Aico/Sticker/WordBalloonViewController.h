//
//  WordBalloonViewController.h
//  Aico
//
//  Created by Mike on 12-5-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBalloonView.h"

@interface WordBalloonViewController : UIViewController<UIActionSheetDelegate>
{
    UIImage *sourcePicture_;                            //要处理的源图片
    UIImageView *currentImageView_;                     //显示的图片
    UIButton *cancelBtn_;                               //左上角取消按钮
    UIButton *confirmBtn_;                              //右上角确定按钮
    CustomBalloonView *balloonView_;                    //添加的定制泡泡
    CGPoint begPoint_;                                   //触摸开始位置
    CGPoint curPoint_;                                   //触摸当前位置
    CGPoint btnPointFirst_;                              //用作矫正切图和图钉位置
    BOOL inBalloon_;                                     //判断当前点击的坐标是否在泡泡内区域
    UIPanGestureRecognizer *panGestureRecognizer_;      //拖动泡泡手势
    
    int theNumberOfBalloonsCreated_;                    //创建过的泡泡数目
    NSMutableArray *balloonArray_;                      //存放所有的泡泡
    int selectedBalloonTag_;                            //当前选中的泡泡的tag
    
    UIActionSheet *actionSheet_;                        //长按某泡泡后弹出的，可以编辑，删除该泡泡
    UIImageView *rotateAndZoomImageView_;               //这是一个全局的view，customballoonview上的旋转缩放按钮有问题，改用这个
    BOOL isBlank_;                                      //判断当前点击坐标是否为空白处（即不是泡泡，也不是旋转缩放按钮view）
    int balloonsOnView_;
}
@property(nonatomic,copy)UIImage *sourcePicture;
@property(nonatomic,retain)UIImageView *currentImageView;
@property(nonatomic,retain)UIButton *cancelBtn;
@property(nonatomic,retain)UIButton *confirmBtn;
@property(nonatomic,retain)CustomBalloonView *balloonView;
@property(nonatomic,retain)UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic,retain)NSMutableArray *balloonArray;
@property(nonatomic,retain)UIActionSheet *actionSheet;
@property(assign)int selectedBalloonTag;
@property(nonatomic,retain)UIImageView *rotateAndZoomImageView;

/**
 * @brief  添加一个新的泡泡
 *
 * @param[in] 
 * @param[out]
 * @return
 * @note 
 */
- (BOOL)addWordBalloon;
- (void)savePicture;
@end