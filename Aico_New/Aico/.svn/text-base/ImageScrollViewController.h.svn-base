//
//  ImageScrollViewController.h
//  Aico
//
//  Created by Wu RongTao on 12-3-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DoPanDelegate<NSObject>

- (void)doPanAdditional:(CGPoint)ptTranslation;

@end

@protocol singleTapDelegate <NSObject>

- (void)singleTap;

@end


@interface ImageScrollViewController : UIViewController<UIScrollViewDelegate> {
	id<DoPanDelegate> delegateDoPan_;
    id<singleTapDelegate> singleTapDelegate_;
    float magnification_;                   //当前放大倍数
    BOOL  flag_;                            //如果源图片的宽高比大于300／360，flag＝yes，否则为no
    UIView *backgroundView_;                //背景视图
    CGSize imageDisplayRectSize_;           //显示尺寸
    CGRect imageScrollViewRect_;            //显示区域
    BOOL isEnableZoom_;						// 是否支持手势缩放
    int  effectType_;                       //特效类型
}
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, assign) id<DoPanDelegate> delegateDoPan;
@property (nonatomic, assign) id<singleTapDelegate> singleTapDelegate;
@property (nonatomic, assign) CGSize imageDisplayRectSize;
@property (nonatomic, assign) CGRect imageScrollViewRect;
@property BOOL isEnableZoom;
@property int effectType;
@end
