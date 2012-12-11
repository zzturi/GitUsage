//
//  AdjustInsertPictureViewController.h
//  Aico
//
//  Created by Yincheng on 12-3-31.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSlider.h"
#import "ImageSplitViewController.h"

enum ETouchRangeID {
    RangeOne = 1,
    RangeTwo,
    RangeThree,
};

@interface AdjustInsertPictureViewController : UIViewController<CustomSliderDelegate,UIGestureRecognizerDelegate>
{
    UIImage                    *srcImage_;      //页面显示的背景图片
    UIImage                    *insImage_;      //页面的插图图片 
    UIImageView                *imageView_;     //加载背景图片
    CustomSlider               *alphaSlider_;   //透明度滑动条
    
    CGSize                     ImageSize_;       //图片缩放后的相对尺寸
    CGFloat                    magnification_;   //相对原图的缩放比例
    CGSize                     beginImageSize_;  //记录原始图片尺寸
    
    UIImageView                *insertView_;    //用于加载切图
    UIImageView                *btnView_;       //用于加载旋转图钉
    
    CGPoint                    begPoint_;        //触摸开始位置
    CGPoint                    curPoint_;        //触摸当前位置
    CGPoint                    btnPointFirst_;   //用作矫正切图和图钉位置
    
    UIPinchGestureRecognizer   *pinchGesture_;   //底图的缩放手势
    UIPanGestureRecognizer     *panGesture_;     //底图的移动手势
    
    enum ETouchRangeID          tRange_;         //标记触摸点位于切图边界周围
    
    CGPoint                     imageCenter_;     //计算底图imageview的初始center
    CGPoint                     buttonCenter_;    //计算图钉btnview的初始center
    BOOL                        flag_;
}
@property(nonatomic,copy)   UIImage *srcImage;
@property(nonatomic,copy)   UIImage *insImage;
@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UIImageView *insertView;
@property(nonatomic,retain) UIImageView *btnView;
@end
