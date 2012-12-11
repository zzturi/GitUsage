//
//  MirrorViewController.h
//  Mirror
//
//  Created by yu cao on 12-6-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistirtBaseViewController.h"
#import "ImageScrollViewController.h"

//镜像视图
@interface MirrorViewController : DistirtBaseViewController <singleTapDelegate>
{
	BOOL leftMirror_;                           //是否为左镜像
    
    ImageScrollViewController *imageScrollVC_;  //滚动视图
}

/**
 * @brief 图片显示区域 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (CGRect)showImageRect;

/**
 * @brief 镜像效果 
 *
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
+ (UIImage *)mirrorEffect:(UIImage *)image;

@end

