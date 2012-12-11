//
//  StickerProcess.h
//  Aico
//
//  Created by Yincheng on 12-5-15.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
  修改记录：从原来读取png图片，改为图片svg图片。目前使用UIWebView读取svg
    时间：2012-06-21 
    修改事项：1）将此类继承从UIView修改为UIWebView
            2）修改读取图片方法，修改替换图片时候重绘图片方法
 */
@interface StickerProcess : UIWebView
{
    EStickerPositionType posType_; //旋转按钮位置
    UIViewController *delegateVC_;   //保存的superView
    NSString *imageName_;          //图片名
}
@property(nonatomic,assign) EStickerPositionType posType;
@property(nonatomic,assign) UIViewController *delegateVC;
@property(nonatomic,copy)   NSString *imageName;

/**
 * @brief 初始化入口 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (id)initWithImageName:(NSString *)name;

/**
 * @brief 重绘图片 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (void)reloadImage:(NSString *)newName;

/**
 * @brief 长按手势处理 
 * @param [in]
 * @param [out]
 * @return
 * @note 
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer;

/**
 * @brief 加载webview信息 
 * @param [in] imageStr 需要加载的svg图片
 * @param [in] lenght   以此值进行重设webview的bounds值
 * @param [out]
 * @return
 * @note 
 */
- (void)loadImage:(NSString *)imageStr andSize:(CGFloat)size;

/**
 * @brief 隐藏webview的背景 
 * @param [in] 图片文件名
 * @param [out]
 * @return
 * @note 
 */
- (void) hideGradientBackground:(UIView*)theView;

@end
