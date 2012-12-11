//
//  SplitView.h
//  DSM_iPad
//
//  Created by Wu Rongtao on 11-12-29.
//  Copyright 2011 cienet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitDisplayView : UIView {
@private
    UIImageView *displayImageView_;         //显示当前所在区域图像    

    NSMutableArray *cornerImageViewArray_;  //四个角的视图数组
    NSMutableArray *lineImageViewArray_;    //分割线视图数组
    
    float scale;                            //图片的放大倍数
    
}
@property(assign)float scale;
@property(nonatomic, retain) UIImageView *displayImageView;
- (void)resetCornerViewFrame;
- (void)resetScaleValue;
@end


@interface SplitView : UIView {
	
	SplitDisplayView *imageView_;		//选择区域框的图片视图
	CGPoint mouseXY;     		        //鼠标单击坐标
	/*
	 sx:imageView的起始X坐标
	 sy:imageView的起始y坐标
	 w:imageView的width：宽
	 h:imageView的height：高
	 ex:imageView的右下角坐标endX：终止X坐标
	 ey:imageView的endY：终止Y坐标
	 sxm:触摸点距离imageView的起始X坐标的位置
	 sym:触摸点距离imageView的起始Y坐标的位置
	 */
	CGFloat sx,sy,w,h,ex,ey,sxm,sym;	
	NSInteger number;						//记录触摸点不同位置的不同处理方案
	
	UIImage   *srcImage_;                   //要剪切的图片
	UIImage   *dstImage_;                   //剪切完成的图片
    UIImage   *clipImage_;                  //裁剪操作的图片
    
    
    CGFloat   imageRightEdge_;              //剪切图片右侧边界区域
    CGFloat   imageBottomEdge_;             //剪切图片下侧边界区域
    
    CGFloat   beginX,beginY;                //记录触摸起始点x,y坐标值
    
    /*******选择比例索引,根据索引设定比例******* 
     索引          比例
     0            1：1
     1            3：2
     2            4：3
     3            2：3
     4            3：4
     5           16：9
     ************************************/
    NSInteger clipRatioIndex_;   
    
    BOOL isFreedomRatio_;                  //标记是否自由比例裁减
    float magnification;                   //图片的放大倍数
    BOOL         isFromInsert;             //判断当前裁剪页面是否是由插图触发

}
@property(nonatomic, retain) SplitDisplayView *imageView;
@property(nonatomic, assign) CGPoint mouseXY;
@property(nonatomic, assign) CGFloat sx,sy,w,h,ex,ey,sxm,sym;
@property(nonatomic, assign) NSInteger number;
@property(nonatomic, copy)   UIImage   *srcImage;
@property(nonatomic, copy)   UIImage   *dstImage;
@property(nonatomic, assign) CGFloat   imageRightEdge;
@property(nonatomic, assign) CGFloat   imageBottomEdge;
@property(nonatomic, assign) NSInteger clipRatioIndex;
@property(nonatomic, assign) BOOL isFromInsert;

/**
 * @brief 
 * 设置裁减视图的图片源
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(void)setSourceImage:(UIImage *)image;

/**
 * @brief 
 * 根据区域截取图片
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 * @brief 
 * 调整图片大小
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;
/**
 * @brief 
 * 进入裁剪，不做任何操作，直接点击确定,需要走本函数，设定frame
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)splitWithNoOperation;
/**
 * @brief 
 * 根据索引修正裁减框的比例
 *
 * @param [in]
 * @param [out]
 * @return 
 * @note
 */
- (void)setFrameFromRatio:(NSInteger )index rangeX:(CGFloat *)deltX rangeY:(CGFloat *)deltY;
@end
