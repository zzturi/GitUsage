//
//  ImageSplitViewController.h
//  DSM_iPad
//
//  Created by Wu Rongtao on 11-12-28.
//  Copyright 2011 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClipSizeViewController.h"
#import "IMPopoverController.h"

@protocol SetSplitView <NSObject>
@optional
- (void)setPicture:(UIImage *)curImage;
@end

@class SplitView,IMPopoverController;

@interface ImageSplitViewController : UIViewController<UIScrollViewDelegate,SelectSizeDelegate,IMPopoverDelegate> {
	UIImage                   *srcImage_;                 //要处理的源图片
	UIImage                   *dstImage_;                 //要处理的目标图片
    SplitView                 *splitView_;                //图片剪切视图
	id<SetSplitView>          delegate_;                  //申明协议
    NSInteger                 sizeIndex_;                 //记录上次选择尺寸操作   
    IMPopoverController       *popoverViewCntroller_;     //弹出视图      
    BOOL         isFromInsert;                            //判断当前裁剪页面是否是由插图触发
    IBOutlet     UIButton *resetBtn_;                     //重置按钮
    IBOutlet     UIButton *chooseBtn_;                    //选择尺寸按钮
    IBOutlet     UIButton *doneBtn_;                      //确定裁剪按钮
    IBOutlet     UIView   *bottomBgView_;                 //底部背景视图
    float        magnification;                           //当前放大倍数
    BOOL         flag;                                    //如果源图片的宽高比大于300／360，flag＝yes，否则为no
    
    CGAffineTransform tansform;
}
@property(nonatomic, copy)   UIImage *srcImage;           //源图片
@property(nonatomic, copy)   UIImage *dstImage;           //目标图片
@property(nonatomic, assign) id<SetSplitView> delegate;
@property(nonatomic, assign) BOOL isFromInsert;
/**
 * @brief 
 *
 * 确定裁剪
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)clipImageDone:(id)sender;
/**
 * @brief 
 *
 * 重置
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)resetClipFrame:(id)sender;
/**
 * @brief 
 *
 * 选择尺寸
 * @param [in]
 * @param [out]
 * @return
 * @note
 */
- (IBAction)selectClipSize:(id)sender;
@end
